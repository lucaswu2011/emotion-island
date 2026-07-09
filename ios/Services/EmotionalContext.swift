import Foundation

/// 情绪是否在对话中发生了转向
enum EmotionalShift: Sendable {
    case brightened
    case darkened
}

/// 单轮对话的情绪上下文 — 以「此刻」为主，避免还用旧情绪安慰
struct TurnEmotionalContext: Sendable {
    let currentTone: SentimentTone
    let priorTurnTone: SentimentTone
    let priorStoryTone: SentimentTone
    let effectiveTone: SentimentTone
    let shift: EmotionalShift?
    let topicChanged: Bool
    /// 用于场景/情境匹配的主文本
    let focusText: String
    let currentIntent: EmotionIntent
    let effectiveIntent: EmotionIntent
    let matchCurrentOnly: Bool
}

enum EmotionalContextBuilder {

    static func build(
        currentText: String,
        session: ConversationSession,
        analyzer: EmotionAnalyzer
    ) -> TurnEmotionalContext {
        let priorStory = priorUserStory(from: session)
        let immediatePrior = immediatePriorUserText(from: session)

        let currentTone = detectTone(in: currentText)
        let priorTurnTone = immediatePrior.isEmpty ? .neutral : detectTone(in: immediatePrior)
        let priorStoryTone = priorStory.isEmpty ? .neutral : detectTone(in: priorStory)

        let topicChanged = TopicDetector.hasShifted(from: immediatePrior.isEmpty ? priorStory : immediatePrior, to: currentText)
        let shift = detectShift(
            currentTone: currentTone,
            priorTurnTone: priorTurnTone,
            priorStoryTone: priorStoryTone,
            currentText: currentText,
            topicChanged: topicChanged
        )

        let effectiveTone = resolveEffectiveTone(
            currentText: currentText,
            session: session,
            currentTone: currentTone,
            priorTurnTone: priorTurnTone,
            priorStoryTone: priorStoryTone,
            shift: shift,
            topicChanged: topicChanged
        )

        let matchCurrentOnly = shouldMatchCurrentOnly(
            currentText: currentText,
            session: session,
            currentTone: currentTone,
            effectiveTone: effectiveTone,
            shift: shift,
            topicChanged: topicChanged
        )

        let focusText = matchCurrentOnly ? currentText : session.accumulatedStory

        let currentAnalysis = analyzer.analyze(currentText)
        let storyAnalysis = analyzer.analyze(session.accumulatedStory)

        let effectiveIntent = resolveIntent(
            currentAnalysis: currentAnalysis,
            storyAnalysis: storyAnalysis,
            effectiveTone: effectiveTone,
            shift: shift,
            topicChanged: topicChanged,
            session: session
        )

        return TurnEmotionalContext(
            currentTone: currentTone,
            priorTurnTone: priorTurnTone,
            priorStoryTone: priorStoryTone,
            effectiveTone: effectiveTone,
            shift: shift,
            topicChanged: topicChanged,
            focusText: focusText,
            currentIntent: currentAnalysis.intent,
            effectiveIntent: effectiveIntent,
            matchCurrentOnly: matchCurrentOnly
        )
    }

    static func buildOpening(text: String, analyzer: EmotionAnalyzer) -> TurnEmotionalContext {
        let tone = detectTone(in: text)
        let intent = analyzer.analyze(text).intent
        let resolved = tone == .positive ? .joy : (intent == .unknown ? .unknown : intent)
        return TurnEmotionalContext(
            currentTone: tone,
            priorTurnTone: .neutral,
            priorStoryTone: .neutral,
            effectiveTone: tone,
            shift: nil,
            topicChanged: false,
            focusText: text,
            currentIntent: resolved,
            effectiveIntent: resolved,
            matchCurrentOnly: true
        )
    }

    // MARK: - Private

    private static func priorUserStory(from session: ConversationSession) -> String {
        let userTexts = session.messages.filter { $0.role == .user }.map(\.text)
        guard userTexts.count > 1 else { return "" }
        return userTexts.dropLast().joined(separator: session.userLanguage.listSeparator)
    }

    private static func immediatePriorUserText(from session: ConversationSession) -> String {
        let userTexts = session.messages.filter { $0.role == .user }.map(\.text)
        guard userTexts.count > 1 else { return "" }
        return userTexts[userTexts.count - 2]
    }

    private static func detectTone(in text: String) -> SentimentTone {
        LanguageSignals.detectSentimentTone(in: text)
    }

    private static func detectShift(
        currentTone: SentimentTone,
        priorTurnTone: SentimentTone,
        priorStoryTone: SentimentTone,
        currentText: String,
        topicChanged: Bool
    ) -> EmotionalShift? {
        let hasBrightCue = LanguageSignals.hasBrighteningCue(currentText)
        let hasDarkCue = LanguageSignals.hasDarkeningCue(currentText)

        if currentTone == .positive {
            if priorTurnTone == .negative || hasBrightCue { return .brightened }
            if priorStoryTone == .negative && (topicChanged || hasBrightCue) { return .brightened }
        }

        if currentTone == .negative {
            if priorTurnTone == .positive { return .darkened }
            if hasDarkCue && priorTurnTone != .negative { return .darkened }
        }

        if hasBrightCue && priorTurnTone != .positive && currentTone != .negative {
            return .brightened
        }
        if hasDarkCue && priorTurnTone == .positive {
            return .darkened
        }

        return nil
    }

    private static func resolveEffectiveTone(
        currentText: String,
        session: ConversationSession,
        currentTone: SentimentTone,
        priorTurnTone: SentimentTone,
        priorStoryTone: SentimentTone,
        shift: EmotionalShift?,
        topicChanged: Bool
    ) -> SentimentTone {
        if GameSignals.isRankGrindFollowUp(currentText: currentText, session: session) {
            return .positive
        }

        if LanguageSignals.isExamFailThread(
            accumulated: session.accumulatedStory,
            current: currentText
        ) {
            return .negative
        }

        switch shift {
        case .brightened: return .positive
        case .darkened: return .negative
        case nil:
            switch currentTone {
            case .positive: return .positive
            case .negative: return .negative
            case .neutral:
                if topicChanged { return .neutral }
                return priorTurnTone != .neutral ? priorTurnTone : priorStoryTone
            }
        }
    }

    private static func shouldMatchCurrentOnly(
        currentText: String,
        session: ConversationSession,
        currentTone: SentimentTone,
        effectiveTone: SentimentTone,
        shift: EmotionalShift?,
        topicChanged: Bool
    ) -> Bool {
        if GameSignals.isRankGrindFollowUp(currentText: currentText, session: session) {
            return true
        }
        if LanguageSignals.isExamFailThread(
            accumulated: session.accumulatedStory,
            current: currentText
        ) {
            return false
        }
        if LanguageSignals.isSchoolBullyingContext(session.accumulatedStory + " " + currentText) {
            return false
        }
        if topicChanged || shift != nil { return true }
        if effectiveTone == .positive { return true }
        if currentTone != .neutral && currentTone == effectiveTone { return true }
        if currentText.count >= (LanguageSignals.isMostlyEnglish(currentText) ? 18 : 8) { return true }
        return false
    }

    private static func resolveIntent(
        currentAnalysis: EmotionAnalysisResult,
        storyAnalysis: EmotionAnalysisResult,
        effectiveTone: SentimentTone,
        shift: EmotionalShift?,
        topicChanged: Bool,
        session: ConversationSession
    ) -> EmotionIntent {
        if effectiveTone == .positive { return .joy }
        if shift == .brightened { return .joy }
        if shift == .darkened, currentAnalysis.intent != .unknown { return currentAnalysis.intent }

        if topicChanged, currentAnalysis.intent != .unknown {
            return currentAnalysis.intent
        }

        if currentAnalysis.intent != .unknown,
           toneMatchesIntent(currentTone: detectTone(in: currentAnalysis.userText), intent: currentAnalysis.intent) {
            return currentAnalysis.intent
        }

        if !topicChanged, storyAnalysis.intent != .unknown { return storyAnalysis.intent }
        return session.dominantIntent
    }

    private static func toneMatchesIntent(currentTone: SentimentTone, intent: EmotionIntent) -> Bool {
        switch intent {
        case .joy: return currentTone == .positive
        case .sadness, .anger, .frustration, .anxiety, .fear, .disappointment, .exhaustion:
            return currentTone != .positive
        default: return true
        }
    }
}
