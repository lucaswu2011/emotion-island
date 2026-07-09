import Foundation

// MARK: - 收尾场景与风格

enum ClosingScenario: Sendable {
    /// 用户明确道别
    case explicitEnd
    /// 正向分享已充分表达
    case positiveWrapped
    /// 负向情绪已落地
    case negativeSettled
    /// 告知行程 / 随口日常
    case neutralDeparture
}

enum ClosingStyle: Sendable {
    case achievementEncourage
    case casualBlessing
    case gentleWarmth
    case comfortHold
    case cheerSupport
    case gentleShift
    case tripAck
    case dailyAck
    case explicitFarewell
    /// 用户说拜拜 / 再见 / 不说了等口语道别
    case casualGoodbye
}

/// 收尾话术触发与安全判断 — 情绪落地后的自然收束，非强行结束
enum ClosingSignals {

    // MARK: - 禁忌：绝不用收尾话术

    static func mustNotClose(
        currentText: String,
        session: ConversationSession,
        ctx: TurnEmotionalContext
    ) -> Bool {
        if isHighRiskSensitive(currentText, session: session) { return true }
        if isSeekingAdvice(currentText) { return true }
        if isIntenseEmotion(currentText, session: session, ctx: ctx) { return true }
        if isStillVenting(currentText, session: session, ctx: ctx) { return true }
        return false
    }

    static func shouldUseClosing(
        currentText: String,
        session: ConversationSession,
        ctx: TurnEmotionalContext
    ) -> Bool {
        guard detectScenario(in: currentText, session: session, ctx: ctx) != nil else {
            return false
        }
        guard !mustNotClose(currentText: currentText, session: session, ctx: ctx) else {
            return false
        }
        if isExplicitEnd(currentText) || isThanksForListening(currentText) {
            return true
        }
        return conversationReadyToClose(session: session, ctx: ctx)
    }

    static func detectScenario(
        in text: String,
        session: ConversationSession,
        ctx: TurnEmotionalContext
    ) -> ClosingScenario? {
        if isExplicitEnd(text) || isThanksForListening(text) {
            return .explicitEnd
        }
        if isPositiveWrap(text, ctx: ctx) {
            return .positiveWrapped
        }
        if isNegativeSettled(text) {
            return .negativeSettled
        }
        if isNeutralDeparture(text) {
            return .neutralDeparture
        }
        return nil
    }

    static func resolveStyle(
        scenario: ClosingScenario,
        currentText: String,
        session: ConversationSession,
        ctx: TurnEmotionalContext
    ) -> ClosingStyle {
        switch scenario {
        case .explicitEnd:
            if isCasualGoodbye(currentText) {
                return .casualGoodbye
            }
            return .explicitFarewell
        case .positiveWrapped:
            return positiveStyle(for: currentText, session: session, ctx: ctx)
        case .negativeSettled:
            return negativeStyle(for: currentText, session: session, ctx: ctx)
        case .neutralDeparture:
            return neutralStyle(for: currentText)
        }
    }

    static func isThanksForListening(_ text: String) -> Bool {
        containsAny([
            "谢谢你陪", "谢谢陪我", "陪我说话", "听我说", "谢谢你陪我说话",
            "thanks for listening", "thank you for being here", "thanks for talking",
        ], in: text)
    }

    static func isVentSettled(_ text: String) -> Bool {
        containsAny([
            "说出来心里", "舒服多了", "说出来好", "就是吐槽", "越说越烦",
            "没事了就是", "你听我说就够", "feel better after talking", "just venting",
            "needed to vent",
        ], in: text)
    }

    /// 用户口语道别时，打断「引导 → 承接」链
    static func isFarewellPhrase(_ text: String) -> Bool {
        containsAny([
            "下次再聊", "先不聊了", "先去忙", "去忙了", "今天就聊到这", "聊到这吧",
            "先走了", "拜拜", "再见", "回见", "谢谢陪", "不说了", "不聊了",
            "talk later", "got to go", "gotta go", "bye", "see you", "goodbye",
        ], in: text)
    }

    // MARK: - Private · 触发识别

    private static func isExplicitEnd(_ text: String) -> Bool {
        isFarewellPhrase(text)
    }

    private static func isCasualGoodbye(_ text: String) -> Bool {
        containsAny([
            "拜拜", "再见", "回见", "不说了", "不聊了", "bye", "see you", "goodbye",
        ], in: text)
    }

    private static func isPositiveWrap(_ text: String, ctx: TurnEmotionalContext) -> Bool {
        guard ctx.effectiveTone == .positive || ctx.currentTone == .positive || ctx.effectiveIntent == .joy else {
            return false
        }
        return containsAny([
            "就是跟你分享", "分享一下", "太开心了", "再去开", "终于搞定", "没白忙活",
            "哈哈", "开心死了", "太爽了", "也算没白",
            "just sharing", "so happy", "won't keep talking", "finally done",
        ], in: text)
    }

    private static func isNegativeSettled(_ text: String) -> Bool {
        containsAny([
            "说出来心里", "舒服多了", "好多了", "算了不说", "越说越烦",
            "没事，就是吐槽", "就是吐槽一下", "你听我说就够", "发泄完了", "越说越",
            "feel better", "let it go", "forget it", "just complaining",
        ], in: text)
    }

    private static func isNeutralDeparture(_ text: String) -> Bool {
        if containsAny([
            "去写作业", "写作业了", "吃饭去", "去吃饭", "我先去", "先不聊了",
            "going to eat", "do homework", "heading out",
        ], in: text) {
            return true
        }
        if text.count <= 16 && containsAny(["天气", "挺好的", "不错呀", "nice weather", "good weather"], in: text) {
            return true
        }
        return false
    }

    // MARK: - Private · 禁忌

    private static func isHighRiskSensitive(_ text: String, session: ConversationSession) -> Bool {
        let story = session.accumulatedStory + " " + text
        if LanguageSignals.isHeavyDistressEvent(text) { return true }
        if LanguageSignals.containsAny(LanguageSignals.crisisSevereZH + LanguageSignals.crisisSevereEN, in: text) {
            return true
        }
        if LanguageSignals.containsAny(LanguageSignals.crisisHeavyZH + LanguageSignals.crisisHeavyEN, in: text)
            && !isNegativeSettled(text) {
            return true
        }
        let riskKeywords = [
            "家暴", "动手打", "打我", "霸凌", "孤立", "想死", "不想活", "自杀", "自残", "割腕",
            "domestic violence", "hit me", "bullied", "suicide", "self-harm", "want to die",
        ]
        if containsAny(riskKeywords, in: story) && !isExplicitEnd(text) {
            return true
        }
        if GameSignals.hasGachaDistress(story) && GameSignals.hasGachaDistress(text) {
            // gacha distress alone isn't high risk — skip
        }
        if story.contains("家暴") || story.contains("动手") || story.contains("霸凌") {
            if !isNegativeSettled(text) && !isExplicitEnd(text) {
                return true
            }
        }
        return false
    }

    private static func isSeekingAdvice(_ text: String) -> Bool {
        containsAny([
            "怎么办", "该怎么办", "怎么做", "该怎么做", "你觉得我应该", "我该不该",
            "有什么办法", "怎么才能", "要不要",
            "what should i", "what do i do", "how should i", "any advice",
        ], in: text)
    }

    private static func isIntenseEmotion(
        _ text: String,
        session: ConversationSession,
        ctx: TurnEmotionalContext
    ) -> Bool {
        if session.distressLevel >= .overwhelming { return true }
        if session.isVentingHard && !isNegativeSettled(text) && !isExplicitEnd(text) {
            return true
        }
        let intense = [
            "崩溃", "大哭", "哭死", "气死了", "恨死", "没用", "废物", "活不下去",
            "breaking down", "sobbing", "hate myself", "worthless",
        ]
        if containsAny(intense, in: text) && !isNegativeSettled(text) {
            return true
        }
        if ctx.currentTone == .negative && text.count > 28
            && !isNegativeSettled(text) && !isExplicitEnd(text) && !isPositiveWrap(text, ctx: ctx) {
            let detailMarkers = ["然后", "接着", "后来", "而且", "因为", "and then", "because"]
            if containsAny(detailMarkers, in: text) { return true }
        }
        return false
    }

    private static func isStillVenting(
        _ text: String,
        session: ConversationSession,
        ctx: TurnEmotionalContext
    ) -> Bool {
        if isExplicitEnd(text) || isNegativeSettled(text) || isPositiveWrap(text, ctx: ctx) {
            return false
        }
        let threshold = session.userLanguage == .english ? 72 : 36
        if text.count >= threshold {
            let closingCue = isExplicitEnd(text) || isNegativeSettled(text) || isNeutralDeparture(text)
            if !closingCue { return true }
        }
        if session.disclosureStage == .unfolding || session.disclosureStage == .droppingHints {
            if session.userTurnCount <= 2 && ctx.currentTone == .negative {
                return true
            }
        }
        return false
    }

    private static func conversationReadyToClose(session: ConversationSession, ctx: TurnEmotionalContext) -> Bool {
        session.userTurnCount >= 2
            || (session.userTurnCount >= 1 && session.messages.filter { $0.role == .assistant }.count >= 1)
    }

    // MARK: - Private · 风格

    private static func positiveStyle(
        for text: String,
        session: ConversationSession,
        ctx: TurnEmotionalContext
    ) -> ClosingStyle {
        let combined = session.accumulatedStory + " " + text
        if GameSignals.hasGamingContext(combined)
            || containsAny(["开黑", "连麦", "打游戏", "再开一把", "聚会", "火锅", "电影"], in: combined) {
            return .casualBlessing
        }
        if containsAny([
            "王者", "段位", "第一", "满分", "及格", "offer", "拿奖", "一等奖", "升职", "学会",
            "rank", "first place", "passed", "award",
        ], in: combined) {
            return .achievementEncourage
        }
        if TopicDetector.detect(in: combined) == .family
            || containsAny(["宠物", "毛孩", "暖", "同好"], in: combined) {
            return .gentleWarmth
        }
        return .achievementEncourage
    }

    private static func negativeStyle(
        for text: String,
        session: ConversationSession,
        ctx: TurnEmotionalContext
    ) -> ClosingStyle {
        let combined = session.accumulatedStory + " " + text
        if containsAny([
            "考砸", "没考好", "失利", "失败", "内耗", "没用", "划水", "加班",
            "failed", "flunked", "burnout",
        ], in: combined) {
            return .cheerSupport
        }
        if containsAny([
            "冤枉", "委屈", "吵架", "冷暴力", "排挤", "连累", "插队", "丢",
            "wronged", "unfair", "argument",
        ], in: combined) {
            return .comfortHold
        }
        if containsAny([
            "倒霉", "糟心", "堵车", "迟到", "卖完了", "饭卡", "踩雷",
            "bad luck", "annoying",
        ], in: combined) {
            return .gentleShift
        }
        return .comfortHold
    }

    private static func neutralStyle(for text: String) -> ClosingStyle {
        if containsAny(["天气", "weather"], in: text) {
            return .dailyAck
        }
        return .tripAck
    }

    private static func containsAny(_ keywords: [String], in text: String) -> Bool {
        LanguageSignals.containsAny(keywords, in: text)
    }
}

// MARK: - 收尾话术文案

enum ClosingLanguage {

    static func reply(
        style: ClosingStyle,
        lang: AppLanguage,
        seed: Int,
        usedKeys: Set<String>
    ) -> ChatReply {
        let lines = pool(for: style, lang: lang)
        let prefix = "close_\(styleKey(style))"
        let usedIndices = lines.indices.filter { usedKeys.contains("\(prefix)_\($0)") }
        let idx: Int
        if usedIndices.count < lines.count {
            idx = pickUnused(from: lines.count, used: usedIndices, seed: seed)
        } else {
            idx = seed % max(lines.count, 1)
        }
        let emojis = emojis(for: style)
        return ChatReply(
            lines[idx],
            emojis: emojis,
            replyKey: "\(prefix)_\(idx)"
        )
    }

    private static func styleKey(_ style: ClosingStyle) -> String {
        switch style {
        case .achievementEncourage: "achieve"
        case .casualBlessing: "casual"
        case .gentleWarmth: "warmth"
        case .comfortHold: "comfort"
        case .cheerSupport: "cheer"
        case .gentleShift: "shift"
        case .tripAck: "trip"
        case .dailyAck: "daily"
        case .explicitFarewell: "farewell"
        case .casualGoodbye: "goodbye"
        }
    }

    private static func pool(for style: ClosingStyle, lang: AppLanguage) -> [String] {
        switch style {
        case .achievementEncourage:
            return CompanionLanguage.pickPool(
                zh: [
                    "太棒啦，继续加油，以后肯定会越来越顺的。",
                    "你完全配得上这份开心，继续闪闪发光呀。",
                    "好嘞，期待你下次再来分享好消息。",
                ],
                en: [
                    "So proud of you — keep going, good things ahead.",
                    "You earned this joy. Keep shining.",
                    "Can't wait to hear your next good news.",
                ],
                lang: lang
            )
        case .casualBlessing:
            return CompanionLanguage.pickPool(
                zh: [
                    "好呀，祝你玩得尽兴，把把都有好运气。",
                    "快去吧，好好享受这份轻松。",
                    "吃好喝好，天天都有这样的好心情呀。",
                ],
                en: [
                    "Have fun — good luck in every match.",
                    "Go enjoy that downtime.",
                    "Eat well, play well, stay this light.",
                ],
                lang: lang
            )
        case .gentleWarmth:
            return CompanionLanguage.pickPool(
                zh: [
                    "真好呀，希望你每天都有这样的小幸运。",
                    "被好好爱着的感觉很棒吧，要一直这么开心哦。",
                ],
                en: [
                    "May little joys like this find you often.",
                    "Being cared for feels good — hold onto that warmth.",
                ],
                lang: lang
            )
        case .comfortHold:
            return CompanionLanguage.pickPool(
                zh: [
                    "别太往心里去，好好歇一歇，难受了随时再来找我。",
                    "你已经做得很好了，不用逼自己立刻好起来，慢慢来。",
                    "不开心的事说出来就过去了，剩下的时间留给自己开心。",
                ],
                en: [
                    "Don't carry it all alone — rest, and come back anytime.",
                    "You're doing enough. No rush to feel better.",
                    "You said it out loud — that's enough for now. Save some gentleness for yourself.",
                ],
                lang: lang
            )
        case .cheerSupport:
            return CompanionLanguage.pickPool(
                zh: [
                    "一次不顺而已，你本来就很厉害，加油呀。",
                    "没关系的，调整好状态再出发就好，我一直都在。",
                    "别太苛责自己，你已经在很努力地往前走了。",
                ],
                en: [
                    "One rough patch doesn't define you — you've got this.",
                    "Take your time to reset. I'm still here.",
                    "You're already trying hard — be as kind to yourself as you are to others.",
                ],
                lang: lang
            )
        case .gentleShift:
            return CompanionLanguage.pickPool(
                zh: [
                    "坏运气都用完啦，接下来全是好事。",
                    "糟心事都翻篇啦，去做点开心的事缓一缓吧。",
                ],
                en: [
                    "Maybe the bad luck quota is spent — smoother days ahead.",
                    "Let the annoyance fade — do something small that feels good.",
                ],
                lang: lang
            )
        case .tripAck:
            return CompanionLanguage.pickPool(
                zh: [
                    "好呀，快去吃饭吧，别饿坏了。",
                    "加油写，写完就能好好放松啦。",
                    "去吧，路上注意安全呀。",
                ],
                en: [
                    "Go eat — take care of yourself.",
                    "Good luck with homework — relax when you're done.",
                    "See you — stay safe out there.",
                ],
                lang: lang
            )
        case .dailyAck:
            return CompanionLanguage.pickPool(
                zh: [
                    "是呀，好天气就该配好心情。",
                    "平平淡淡的日子也很舒服呀。",
                ],
                en: [
                    "Good weather deserves a good mood.",
                    "Quiet, ordinary days have their own comfort.",
                ],
                lang: lang
            )
        case .explicitFarewell:
            return CompanionLanguage.pickPool(
                zh: [
                    "好的，忙完随时回来找我，我一直都在。",
                    "不客气呀，想说话的时候随时都可以来。",
                    "好嘞，下次有开心的、不开心的都可以再来找我。",
                ],
                en: [
                    "Anytime you're back — I'm here.",
                    "You're welcome. Talk whenever you need.",
                    "Glad to listen — joy or hard stuff, both welcome.",
                ],
                lang: lang
            )
        case .casualGoodbye:
            return CompanionLanguage.pickPool(
                zh: [
                    "拜拜，有想要分享的随时回来。",
                ],
                en: [
                    "Bye — come back anytime you want to share.",
                ],
                lang: lang
            )
        }
    }

    private static func emojis(for style: ClosingStyle) -> [String] {
        switch style {
        case .achievementEncourage: ["✨", "💪", "😊"]
        case .casualBlessing: ["🎮", "😊", "✨"]
        case .gentleWarmth: ["🌸", "💕", "✨"]
        case .comfortHold, .cheerSupport: ["🫂", "🌿"]
        case .gentleShift: ["🌿", "✨"]
        case .tripAck, .dailyAck: ["🌿", "😊"]
        case .explicitFarewell: ["🫂", "🌿", "😊"]
        case .casualGoodbye: ["👋", "🌿", "😊"]
        }
    }

    private static func pickUnused(from count: Int, used: [Int], seed: Int) -> Int {
        guard count > 0 else { return 0 }
        if used.count >= count { return seed % count }
        var idx = seed % count
        var attempts = 0
        while used.contains(idx) && attempts < count {
            idx = (idx + 1) % count
            attempts += 1
        }
        return idx
    }
}

extension CompanionLanguage {
    static func pickPool(zh: [String], en: [String], lang: AppLanguage) -> [String] {
        lang == .english ? en : zh
    }
}
