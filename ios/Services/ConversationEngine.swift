import Foundation

/// 多轮对话引擎 — 根据用户原话生成贴切回应
struct ConversationEngine: Sendable {

    private let analyzer = EmotionAnalyzer()
    private let responder = ContextualResponder()
    private let deepSeek = DeepSeekClient()

    func startSession(
        with result: EmotionAnalysisResult,
        language: AppLanguage,
        provider: CompanionAIProvider = .local,
        apiKey: String = ""
    ) async -> ConversationSession {
        switch provider {
        case .local:
            return startSessionLocal(with: result, language: language)
        case .deepSeek:
            return await startSessionDeepSeek(with: result, language: language, apiKey: apiKey)
        }
    }

    private func startSessionLocal(with result: EmotionAnalysisResult, language: AppLanguage) -> ConversationSession {
        var messages: [ChatMessage] = [
            ChatMessage(role: .user, text: result.userText)
        ]

        let opening = responder.openingReply(for: result, language: language)
        messages.append(ChatMessage(role: .assistant, text: opening.text, emojis: opening.emojis))

        let distress = assessDistress(in: result.userText)
        let stage = assessDisclosure(text: result.userText, accumulated: result.userText)

        var initialKeys = Set<String>()
        recordReplyKeys(opening, into: &initialKeys)

        var profanityAttackStreak = 0
        var profanityBoundaryStep = 0
        var awaitingProfanityCalmCheck = false
        if ProfanityBreakdownHandler.isAttackAtAssistant(result.userText) {
            profanityAttackStreak = 1
        }
        if ProfanityBreakdownHandler.isProfanityReplyKey(opening.replyKey) {
            awaitingProfanityCalmCheck = true
            if ProfanityBreakdownHandler.isTier3ReplyKey(opening.replyKey) {
                profanityBoundaryStep = 1
            }
        }

        return ConversationSession(
            initialResult: result,
            messages: messages,
            phase: stage == .readyForComfort ? .comforting : .listening,
            turnCount: 0,
            negativeStreak: isNegativeIntent(result.intent) ? 1 : 0,
            distressLevel: distress,
            usedReplyKeys: initialKeys,
            discussedTopics: [TopicDetector.detect(in: result.userText)],
            dominantIntent: result.intent,
            disclosureStage: stage,
            userLanguage: language,
            pendingFollowUpTone: nil,
            profanityAttackStreak: profanityAttackStreak,
            profanityBoundaryStep: profanityBoundaryStep,
            awaitingProfanityCalmCheck: awaitingProfanityCalmCheck
        )
    }

    private func startSessionDeepSeek(
        with result: EmotionAnalysisResult,
        language: AppLanguage,
        apiKey: String
    ) async -> ConversationSession {
        var messages: [ChatMessage] = [
            ChatMessage(role: .user, text: result.userText)
        ]

        let distress = assessDistress(in: result.userText)
        let stage = assessDisclosure(text: result.userText, accumulated: result.userText)
        var initialKeys = Set<String>()

        let reply: ChatReply
        if let guardReply = responder.openingLocalGuardReply(for: result, language: language) {
            reply = guardReply
        } else if let aiText = try? await deepSeek.complete(
            apiKey: apiKey,
            messages: messages,
            language: language,
            intent: result.intent
        ), !CompanionRules.containsForbiddenPattern(aiText) {
            let tone = ContextualResponder.detectToneStatic(in: result.userText)
            reply = ChatReply(
                aiText,
                emojis: CompanionAIReplyFormatter.emojis(intent: result.intent, tone: tone),
                replyKey: "deepseek_open"
            )
        } else {
            reply = responder.openingReply(for: result, language: language)
        }

        messages.append(ChatMessage(role: .assistant, text: reply.text, emojis: reply.emojis))
        recordReplyKeys(reply, into: &initialKeys)

        return ConversationSession(
            initialResult: result,
            messages: messages,
            phase: stage == .readyForComfort ? .comforting : .listening,
            turnCount: 0,
            negativeStreak: isNegativeIntent(result.intent) ? 1 : 0,
            distressLevel: distress,
            usedReplyKeys: initialKeys,
            discussedTopics: [TopicDetector.detect(in: result.userText)],
            dominantIntent: result.intent,
            disclosureStage: stage,
            userLanguage: language,
            pendingFollowUpTone: nil,
            profanityAttackStreak: 0,
            profanityBoundaryStep: 0,
            awaitingProfanityCalmCheck: false
        )
    }

    func continueSession(
        _ session: ConversationSession,
        userInput: String,
        provider: CompanionAIProvider = .local,
        apiKey: String = ""
    ) async -> ConversationSession {
        switch provider {
        case .local:
            return continueSessionLocal(session, userInput: userInput)
        case .deepSeek:
            return await continueSessionDeepSeek(session, userInput: userInput, apiKey: apiKey)
        }
    }

    private func continueSessionLocal(_ session: ConversationSession, userInput: String) -> ConversationSession {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return session }

        var updated = session
        updated.messages.append(ChatMessage(role: .user, text: trimmed))
        updated.turnCount += 1

        if ClosingSignals.isFarewellPhrase(trimmed) || LanguageSignals.isThanks(trimmed) {
            updated.pendingFollowUpTone = nil
        }

        updated.discussedTopics.insert(TopicDetector.detect(in: trimmed))
        let ctx = EmotionalContextBuilder.build(currentText: trimmed, session: updated, analyzer: analyzer)
        updated.dominantIntent = ctx.effectiveIntent
        updated.distressLevel = max(updated.distressLevel, assessDistress(in: trimmed))

        if isNegativeIntent(ctx.effectiveIntent) {
            updated.negativeStreak += 1
        } else if ctx.effectiveIntent == .joy || ctx.shift == .brightened {
            updated.negativeStreak = max(0, updated.negativeStreak - 1)
        }

        if ctx.topicChanged && ctx.effectiveTone == .positive {
            updated.negativeStreak = 0
        }

        updated.disclosureStage = assessDisclosure(text: trimmed, accumulated: updated.accumulatedStory)
        updated.phase = updated.disclosureStage == .readyForComfort ? .comforting : .listening

        updateProfanityStateForUserTurn(&updated, text: trimmed)

        let reply = responder.respond(
            currentText: trimmed,
            session: updated,
            usedKeys: updated.usedReplyKeys
        )
        recordReplyKeys(reply, into: &updated.usedReplyKeys)
        if FollowUpGuides.isFollowUpReply(reply.replyKey) {
            updated.pendingFollowUpTone = nil
        } else if let tone = FollowUpGuides.pendingTone(from: reply.replyKey) {
            updated.pendingFollowUpTone = tone
        } else if updated.pendingFollowUpTone != nil {
            updated.pendingFollowUpTone = nil
        }
        applyProfanityStateAfterReply(reply, to: &updated)
        updated.messages.append(ChatMessage(role: .assistant, text: reply.text, emojis: reply.emojis))

        return updated
    }

    private func continueSessionDeepSeek(
        _ session: ConversationSession,
        userInput: String,
        apiKey: String
    ) async -> ConversationSession {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return session }

        let updated = applyUserTurn(to: session, userInput: trimmed)
        let reply: ChatReply

        if let guardReply = responder.localGuardReply(
            currentText: trimmed,
            session: updated,
            usedKeys: updated.usedReplyKeys
        ) {
            reply = guardReply
        } else if let aiText = try? await deepSeek.complete(
            apiKey: apiKey,
            messages: updated.messages,
            language: updated.userLanguage,
            intent: updated.dominantIntent
        ), !CompanionRules.containsForbiddenPattern(aiText) {
            let tone = ContextualResponder.detectToneStatic(in: trimmed)
            reply = ChatReply(
                aiText,
                emojis: CompanionAIReplyFormatter.emojis(intent: updated.dominantIntent, tone: tone),
                replyKey: "deepseek_\(updated.turnCount)"
            )
        } else {
            reply = responder.respond(
                currentText: trimmed,
                session: updated,
                usedKeys: updated.usedReplyKeys
            )
        }

        return appendAssistantReply(reply, to: updated)
    }

    private func applyUserTurn(to session: ConversationSession, userInput trimmed: String) -> ConversationSession {
        var updated = session
        updated.messages.append(ChatMessage(role: .user, text: trimmed))
        updated.turnCount += 1

        if ClosingSignals.isFarewellPhrase(trimmed) || LanguageSignals.isThanks(trimmed) {
            updated.pendingFollowUpTone = nil
        }

        updated.discussedTopics.insert(TopicDetector.detect(in: trimmed))
        let ctx = EmotionalContextBuilder.build(currentText: trimmed, session: updated, analyzer: analyzer)
        updated.dominantIntent = ctx.effectiveIntent
        updated.distressLevel = max(updated.distressLevel, assessDistress(in: trimmed))

        if isNegativeIntent(ctx.effectiveIntent) {
            updated.negativeStreak += 1
        } else if ctx.effectiveIntent == .joy || ctx.shift == .brightened {
            updated.negativeStreak = max(0, updated.negativeStreak - 1)
        }

        if ctx.topicChanged && ctx.effectiveTone == .positive {
            updated.negativeStreak = 0
        }

        updated.disclosureStage = assessDisclosure(text: trimmed, accumulated: updated.accumulatedStory)
        updated.phase = updated.disclosureStage == .readyForComfort ? .comforting : .listening
        updateProfanityStateForUserTurn(&updated, text: trimmed)
        return updated
    }

    private func appendAssistantReply(_ reply: ChatReply, to session: ConversationSession) -> ConversationSession {
        var updated = session
        recordReplyKeys(reply, into: &updated.usedReplyKeys)
        if FollowUpGuides.isFollowUpReply(reply.replyKey) {
            updated.pendingFollowUpTone = nil
        } else if let tone = FollowUpGuides.pendingTone(from: reply.replyKey) {
            updated.pendingFollowUpTone = tone
        } else if updated.pendingFollowUpTone != nil {
            updated.pendingFollowUpTone = nil
        }
        applyProfanityStateAfterReply(reply, to: &updated)
        updated.messages.append(ChatMessage(role: .assistant, text: reply.text, emojis: reply.emojis))
        return updated
    }

    private func updateProfanityStateForUserTurn(_ session: inout ConversationSession, text: String) {
        if ProfanityBreakdownHandler.isHighSensitiveContext(text, accumulated: session.accumulatedStory) {
            session.profanityBoundaryStep = 0
        }

        if ProfanityBreakdownHandler.isAttackAtAssistant(text) {
            session.profanityAttackStreak += 1
        } else if !ProfanityBreakdownHandler.containsProfanity(text) {
            session.profanityAttackStreak = 0
            if ProfanityBreakdownHandler.hasSubstantiveEvent(in: text) {
                session.profanityBoundaryStep = 0
            }
        } else {
            session.profanityAttackStreak = 0
        }
    }

    private func applyProfanityStateAfterReply(_ reply: ChatReply, to session: inout ConversationSession) {
        if ProfanityBreakdownHandler.isCalmGuidanceKey(reply.replyKey) {
            session.awaitingProfanityCalmCheck = false
            session.profanityBoundaryStep = 0
            session.profanityAttackStreak = 0
        } else if ProfanityBreakdownHandler.isTier3ReplyKey(reply.replyKey) {
            session.profanityBoundaryStep = min(2, session.profanityBoundaryStep + 1)
            session.awaitingProfanityCalmCheck = true
        } else if ProfanityBreakdownHandler.isProfanityReplyKey(reply.replyKey) {
            session.awaitingProfanityCalmCheck = true
        }
    }

    private func recordReplyKeys(_ reply: ChatReply, into keys: inout Set<String>) {
        if reply.replyKey.contains("|") {
            for part in reply.replyKey.split(separator: "|") {
                keys.insert(String(part))
            }
        } else {
            keys.insert(reply.replyKey)
        }
    }

    func islandMessage(for session: ConversationSession) -> String {
        let acc = session.accumulatedStory
        let lang = session.userLanguage
        let lastUser = session.messages.last(where: { $0.role == .user })?.text ?? acc
        let tone = ContextualResponder.detectToneStatic(in: lastUser)
        let seed = CompanionLanguage.seed(session: session, text: lastUser, usedKeys: session.usedReplyKeys)

        if tone == .positive {
            if acc.contains("第一") || acc.localizedCaseInsensitiveContains("first") {
                return CompanionLanguage.pickB(
                    zh: ["太棒了，真为你高兴！", "第一名！听着就替你开心。", "好事值得被记住～"],
                    en: ["That's wonderful — so happy for you!", "First place! I can hear the joy.", "Good news worth remembering."],
                    lang: lang, seed: seed
                )
            }
            if TopicDetector.detect(in: lastUser) == .gaming
            || GameSignals.hasGamingContext(lastUser)
            || ["五杀", "吃鸡", "上王者", "出金", "连胜", "超神", "非洲之心"].contains(where: { lastUser.contains($0) }) {
                let gamingAchievement = GameSignals.hasGamingAchievementContext(lastUser)
                return CompanionLanguage.pickB(
                    zh: gamingAchievement
                        ? ["这波操作太帅了！", "听着就替你开心～", "太厉害了！"]
                        : ["好好放松一下吧～", "听着就替你开心！", "开心的事，值得被记住。"],
                    en: gamingAchievement
                        ? ["What a play!", "I can hear the hype!", "That's awesome!"]
                        : ["Enjoy the downtime!", "Sounds like a good plan.", "Happy moments are worth holding onto."],
                    lang: lang, seed: seed
                )
            }
            let lifeTopic = TopicDetector.detect(in: lastUser)
            if [.family, .pet, .travel, .consumption].contains(lifeTopic) {
                return CompanionLanguage.pickB(
                    zh: ["生活里的暖时刻，值得被记住。", "听着就替你开心～", "这种小幸运真好。"],
                    en: ["Life's warm moments are worth holding onto.", "So happy for you.", "Little joys like this matter."],
                    lang: lang, seed: seed
                )
            }
            return CompanionLanguage.pickB(
                zh: ["开心的事，值得被记住。", "这语气听着就轻快。", "替你高兴着呢。"],
                en: ["Happy moments are worth holding onto.", "You sound lighter already.", "I'm happy for you."],
                lang: lang, seed: seed
            )
        }
        if session.dominantIntent == .exhaustion || LanguageSignals.expressesExhaustion(lastUser) {
            return CompanionLanguage.pickB(
                zh: ["累了就歇一歇，不催你。", "先照顾好自己。", "嗯…我陪着你。"],
                en: ["Rest when you need to — no rush.", "Take care of yourself first.", "I'm here with you."],
                lang: lang, seed: seed
            )
        }
        if TopicDetector.detect(in: lastUser) == .gaming,
           ["连跪", "掉段", "演员", "挂机", "歪了", "沉船", "460", "落地成盒"].contains(where: { lastUser.contains($0) }) {
            return CompanionLanguage.pickB(
                zh: ["游戏搞心态的时候真的气人。", "先别硬打，缓一缓。", "破防了也正常，我听着呢。"],
                en: ["Games can be so frustrating sometimes.", "No need to force another match.", "It's okay to be tilted — I'm here."],
                lang: lang, seed: seed
            )
        }
        let negLifeTopic = TopicDetector.detect(in: lastUser)
        if [.family, .pet, .travel, .consumption, .health].contains(negLifeTopic)
            || ["冷暴力", "催婚", "拆家", "跑丢", "误了", "踩雷", "插队"].contains(where: { lastUser.contains($0) }) {
            return CompanionLanguage.pickB(
                zh: ["生活里的糟心事，慢慢讲。", "听着就替你闹心。", "嗯…我陪着你。"],
                en: ["Take your time with life's rough patches.", "That sounds really frustrating.", "I'm here with you."],
                lang: lang, seed: seed
            )
        }
        if session.distressLevel >= .overwhelming {
            return CompanionLanguage.pickB(
                zh: ["不用一个人扛，我在这儿。", "先喘口气，我陪着你。", "此刻不用想解决办法。"],
                en: ["You don't have to carry this alone.", "Take a breath — I'm here.", "No need to fix anything right now."],
                lang: lang, seed: seed
            )
        }
        if LanguageSignals.suggestsBoundaryViolation(acc) || acc.localizedCaseInsensitiveContains("stolen") {
            return CompanionLanguage.pickB(
                zh: ["你的边界，值得被尊重。", "没经过同意就动你的东西，谁都会火大。"],
                en: ["Your boundaries matter.", "Anyone would be upset if their things were taken without consent."],
                lang: lang, seed: seed
            )
        }
        if acc.contains("冤枉") || acc.contains("委屈") || acc.contains("诬陷") || acc.contains("背锅")
            || acc.localizedCaseInsensitiveContains("wronged") || acc.localizedCaseInsensitiveContains("framed") {
            return CompanionLanguage.pickB(
                zh: ["你的委屈，是成立的。", "被误解、被诬陷的时候，有口难言…"],
                en: ["Your hurt is valid.", "Being misunderstood or framed can leave you speechless…"],
                lang: lang, seed: seed
            )
        }
        if acc.contains("考试") || acc.contains("题目") || acc.localizedCaseInsensitiveContains("exam") || acc.localizedCaseInsensitiveContains("test") {
            return CompanionLanguage.pickB(
                zh: ["考试的事，慢慢讲。", "考场上那些事，不着急。", "分数不能定义你。"],
                en: ["Take your time with the exam stuff.", "No rush — tell me about it.", "A score doesn't define you."],
                lang: lang, seed: seed
            )
        }
        if session.disclosureStage != .readyForComfort {
            return CompanionLanguage.pickB(
                zh: ["慢慢讲，我听着。", "想到哪说到哪就好。", "不催你，我在这儿。"],
                en: ["I'm listening — go at your pace.", "Say whatever comes to mind.", "No rush. I'm here."],
                lang: lang, seed: seed
            )
        }
        return analyzer.islandMessage(for: session.initialResult, lang: lang)
    }

    // MARK: - Helpers

    private func assessDisclosure(text: String, accumulated: String) -> DisclosureStage {
        if accumulated.count <= 8 { return .emotionOnly }
        if SituationHandlerProxy.needsFollowUp(accumulated: accumulated) { return .unfolding }
        if accumulated.count >= 20 { return .readyForComfort }
        return .unfolding
    }

    private func assessDistress(in text: String) -> DistressLevel {
        if LanguageSignals.containsAny(LanguageSignals.crisisSevereZH + LanguageSignals.crisisSevereEN, in: text) { return .overwhelming }
        if ["好痛苦", "哭", "忍不住", "so painful", "crying", "can't stop crying"].contains(where: { text.localizedCaseInsensitiveContains($0) }) { return .high }
        if ["还是", "依然", "一直", "still", "keep feeling"].contains(where: { text.localizedCaseInsensitiveContains($0) }) { return .elevated }
        return .calm
    }

    private func isNegativeIntent(_ intent: EmotionIntent) -> Bool {
        switch intent {
        case .sadness, .anger, .frustration, .anxiety, .fear, .disappointment, .exhaustion, .confusion, .maskedLoneliness:
            return true
        default: return false
        }
    }

    private func mergeIntent(current: EmotionIntent, new: EmotionIntent) -> EmotionIntent {
        new == .unknown ? current : (current == .unknown ? new : new)
    }
}

/// 供 ConversationEngine 判断是否需要继续追问
private enum SituationHandlerProxy {
    static func needsFollowUp(accumulated: String) -> Bool {
        if accumulated.contains("会做的") || accumulated.contains("没做出来"), !mentionsSubject(accumulated) { return true }
        if accumulated.contains("没发挥") || accumulated.contains("真实水平"), !mentionsSubject(accumulated) { return true }
        if accumulated.contains("偷") || LanguageSignals.suggestsBoundaryViolation(accumulated), accumulated.count < 30 { return true }
        if accumulated.contains("冤枉"), !mentionsPerson(accumulated) { return true }
        if accumulated.contains("吵架"), !mentionsPerson(accumulated) { return true }
        if accumulated.count < 15 && isEmotionOnly(accumulated) { return true }
        return false
    }

    private static func mentionsSubject(_ text: String) -> Bool {
        ["数学", "语文", "英语", "物理", "化学", "生物", "历史", "地理", "政治"].contains { text.contains($0) }
    }

    private static func mentionsPerson(_ text: String) -> Bool {
        ["朋友", "同学", "老师", "父母", "妈妈", "爸爸", "他", "她"].contains { text.contains($0) }
    }

    private static func isEmotionOnly(_ text: String) -> Bool {
        ["委屈", "难过", "生气", "焦虑", "害怕"].contains { text.contains($0) } && text.count <= 8
    }
}
