import SwiftUI

enum AppScreen: Hashable {
    case welcome
    case diaryInput
    case moodSelection
    case aiDemo
    case companionChat
    case emotionCaught
    case recognitionSummary
    case diaryHistory
    case moodDiary
    case about
}

@MainActor
@Observable
final class AppViewModel {
    private static let languageKey = "selectedAppLanguage"

    var navigationPath: [AppScreen] = []
    var diaryText: String = ""
    var analysisResult: EmotionAnalysisResult?
    var conversation = ConversationSession.empty()
    var showSaveConfirmation = false
    var appLanguage: AppLanguage = .chinese
    var hasSelectedLanguage = false
    var companionAIProvider: CompanionAIProvider = CompanionAIProvider.load()
    var deepSeekAPIKey: String = DeepSeekAPIKeyStore.apiKey
    var isAwaitingAIReply = false
    var aiErrorMessage: String?
    var showDeepSeekKeyPrompt = false

    let analyzer = EmotionAnalyzer()
    let conversationEngine = ConversationEngine()
    let dataStore = EmotionDataStore()
    let moodDiaryStore = DailyMoodDiaryStore()

    var strings: AppStrings { AppStrings(language: appLanguage) }

    var isNetworkOnline: Bool { NetworkMonitor.shared.isOnline }

    var canUseDeepSeek: Bool { isNetworkOnline }

    init() {
        if let raw = UserDefaults.standard.string(forKey: Self.languageKey),
           let saved = AppLanguage(rawValue: raw) {
            appLanguage = saved
            hasSelectedLanguage = true
        }
    }

    var chatIslandMessage: String {
        guard !conversation.messages.isEmpty else {
            return analysisResult.map { analyzer.islandMessage(for: $0, lang: appLanguage) } ?? strings.companionListening
        }
        return conversationEngine.islandMessage(for: conversation)
    }

    func selectLanguage(_ language: AppLanguage) {
        appLanguage = language
        hasSelectedLanguage = true
        UserDefaults.standard.set(language.rawValue, forKey: Self.languageKey)
        if conversation.messages.isEmpty {
            conversation = ConversationSession.empty(language: language)
        }
    }

    func analyzeCurrentText() {
        analysisResult = analyzer.analyze(diaryText)
    }

    func startConversation() {
        guard let result = analysisResult else { return }
        let provider = resolvedProvider(for: companionAIProvider)
        isAwaitingAIReply = provider == .deepSeek
        aiErrorMessage = nil

        Task {
            defer { isAwaitingAIReply = false }
            if companionAIProvider == .deepSeek, !isNetworkOnline {
                aiErrorMessage = strings.networkRequiredForDeepSeek
            }
            conversation = await conversationEngine.startSession(
                with: result,
                language: appLanguage,
                provider: provider,
                apiKey: deepSeekAPIKey
            )
        }
    }

    func sendChatMessage(_ text: String) {
        guard !isAwaitingAIReply else { return }
        let provider = resolvedProvider(for: companionAIProvider)
        isAwaitingAIReply = provider == .deepSeek
        aiErrorMessage = nil
        let snapshot = conversation

        Task {
            defer { isAwaitingAIReply = false }
            if companionAIProvider == .deepSeek, !isNetworkOnline {
                aiErrorMessage = strings.networkRequiredForDeepSeek
            }
            conversation = await conversationEngine.continueSession(
                snapshot,
                userInput: text,
                provider: provider,
                apiKey: deepSeekAPIKey
            )
            refreshAnalysisFromConversation()
        }
    }

    func selectCompanionAIProvider(_ provider: CompanionAIProvider) {
        if provider == .deepSeek, !isNetworkOnline {
            aiErrorMessage = strings.networkRequiredForDeepSeek
            return
        }
        companionAIProvider = provider
        provider.save()
        aiErrorMessage = nil
    }

    /// DeepSeek 需联网；离线时自动回退本地话术
    private func resolvedProvider(for selected: CompanionAIProvider) -> CompanionAIProvider {
        if selected == .deepSeek, !isNetworkOnline { return .local }
        return selected
    }

    func saveDeepSeekAPIKey(_ key: String) {
        deepSeekAPIKey = key
        DeepSeekAPIKeyStore.apiKey = key
        showDeepSeekKeyPrompt = false
    }

    func refreshAnalysisFromConversation() {
        guard let result = analysisResult else { return }
        let allUserText = conversation.messages
            .filter { $0.role == .user }
            .map(\.text)
            .joined(separator: " ")

        let combined = analyzer.analyze(allUserText)
        analysisResult = EmotionAnalysisResult(
            intent: conversation.dominantIntent != .unknown ? conversation.dominantIntent : combined.intent,
            confidence: max(combined.confidence, result.confidence),
            triggerWords: Array(Set(result.triggerWords + combined.triggerWords)),
            userText: conversation.fullTranscript,
            timestamp: Date(),
            detectedCause: combined.detectedCause ?? result.detectedCause,
            contexts: Array(Set(result.contexts + combined.contexts))
        )
    }

    func saveCurrentRecord() {
        guard let result = analysisResult else { return }
        let lastAssistant = conversation.messages.last(where: { $0.role == .assistant })
        let record = EmotionRecord(
            text: conversation.fullTranscript,
            intent: result.intent,
            confidence: result.confidence,
            triggerWords: result.triggerWords,
            assistantResponse: lastAssistant?.text ?? analyzer.generateDetailedResponse(for: result, lang: appLanguage),
            chatMessages: conversation.messages
        )
        dataStore.save(record)
        moodDiaryStore.recordSession(
            conversation: conversation,
            analyzer: analyzer,
            language: appLanguage
        )
        showSaveConfirmation = true
    }

    func navigate(to screen: AppScreen) {
        navigationPath.append(screen)
    }

    func popToDiary() {
        navigationPath.removeAll()
        navigate(to: .diaryInput)
    }

    func reset() {
        diaryText = ""
        analysisResult = nil
        conversation = ConversationSession.empty(language: appLanguage)
        navigationPath.removeAll()
    }
}

extension ConversationSession {
    static func empty(language: AppLanguage = .chinese) -> ConversationSession {
        ConversationSession(
            initialResult: EmotionAnalysisResult(
                intent: .unknown,
                confidence: 0,
                triggerWords: [],
                userText: "",
                timestamp: Date(),
                detectedCause: nil,
                contexts: []
            ),
            messages: [],
            phase: .opening,
            turnCount: 0,
            negativeStreak: 0,
            distressLevel: .calm,
            usedReplyKeys: [],
            discussedTopics: [],
            dominantIntent: .unknown,
            disclosureStage: .emotionOnly,
            userLanguage: language,
            pendingFollowUpTone: nil,
            profanityAttackStreak: 0,
            profanityBoundaryStep: 0,
            awaitingProfanityCalmCheck: false
        )
    }
}
