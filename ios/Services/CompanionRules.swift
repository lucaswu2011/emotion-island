import Foundation

/// 情绪岛小助手角色与回复铁则 — 倾听、共情、引导倾诉；不说教、不瞎编
enum CompanionRules {

    // MARK: - 正向游戏黑话（识别对应喜悦）

    static let positiveGameSlangZH = [
        "非洲之心", "非洲心", "大红", "大金", "百万撤离", "五杀", "ACE", "三星五费",
        "单抽出金", "凤凰蛋", "无敌战神", "超神", "吃鸡", "满血吃鸡", "双黄", "出金",
    ]

    // MARK: - 负向游戏黑话（识别对应挫败）

    static let negativeGameSlangZH = [
        "连跪", "黑屋局", "黑屋", "炸鱼", "演员", "大保底歪", "大保底歪了", "落地成盒",
        "460", "掉段", "渡劫失败", "沉船", "挂机", "送人头",
    ]

    // MARK: - 高风险敏感词

    static let highRiskKeywordsZH = [
        "家暴", "打我", "被打", "动手打", "霸凌", "被欺负", "被孤立", "起外号", "造黄谣",
        "孤立", "不想活了", "不想活", "自残", "自杀", "割腕", "想死",
    ]

    // MARK: - 禁止出现在回复中的说教 / 否定句式

    static let forbiddenReplyPatternsZH = [
        "你应该", "你要", "你必须", "这点小事", "别玻璃心", "忍一忍", "一家人别计较",
        "别计较", "想开点就好了", "没什么大不了", "这有什么好生气",
        // 辱骂场景绝对禁忌 — 说教 / 回怼 / 冷漠 / 上纲上线 / 转移话题
        "请你文明", "文明一点", "怎么能骂人", "很没素质", "没素质",
        "你凭什么骂我", "我又没惹你", "你有病吧", "关你什么事",
        "随便你", "你爱怎么说", "哦，", "骂人是不对的", "很不尊重人",
        "我们不说这个了", "聊点别的吧", "别骂了",
        // 霸凌 / 家暴 — 受害者有罪论、强迫求助绝对禁止
        "为什么只欺负你", "你也有问题", "为什么不欺负别人", "是不是你得罪",
        "你是不是得罪", "你要告老师", "你要反抗", "你必须告诉",
    ]

    // MARK: - 兜底话术（完全听不懂时专用，禁止瞎编）

    static func fallbackListenReply(lang: AppLanguage) -> String {
        lang == .english
            ? "Sounds like a lot is going on — can you tell me more about what happened? I'm listening."
            : "听起来你现在心情好像挺复杂的，可以多跟我说说具体发生了什么吗？我好好听着。"
    }

    /// 劳累场景库接不住时，轻量转向开心事
    static func exhaustionPivotReply(lang: AppLanguage) -> String {
        lang == .english
            ? "I hear you — is there anything happy you'd like to share?"
            : "我理解了，那有没有什么开心的事情分享一下呢。"
    }

    /// 劳累相关但场景库无匹配时，使用转向话术
    static func shouldUseExhaustionPivot(
        currentText: String,
        accumulated: String,
        ctx: TurnEmotionalContext,
        scenarioMatched: Bool
    ) -> Bool {
        guard !scenarioMatched else { return false }

        let isExhaustionRelated = LanguageSignals.expressesExhaustion(currentText)
            || ctx.effectiveIntent == .exhaustion
            || LanguageSignals.hasExhaustionCause(currentText)
            || LanguageSignals.expressesExhaustion(accumulated)
        guard isExhaustionRelated else { return false }

        return ScenarioLibrary.matchExhaustion(in: accumulated, current: currentText) == nil
    }

    /// 是否应使用兜底倾听话术（意图不明、无场景匹配、未识别专有名词）
    static func shouldUseFallbackListen(
        currentText: String,
        ctx: TurnEmotionalContext,
        lang: AppLanguage,
        scenarioMatched: Bool
    ) -> Bool {
        guard !scenarioMatched else { return false }

        let text = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        let minLen = lang == .english ? 12 : 6
        guard text.count >= minLen else { return false }

        if ctx.effectiveIntent != .unknown { return false }

        if GameSignals.mentionsSpecificGame(in: text) { return false }
        if LanguageSignals.detectSentimentTone(in: text) == .positive
            && containsAny(positiveGameSlangZH, in: text) {
            return false
        }
        if containsAny(negativeGameSlangZH, in: text) { return false }
        if containsAny(highRiskKeywordsZH, in: text) { return false }

        if let touch = CompanionLanguage.lightTouch(on: text, lang: lang), touch.count >= 4 {
            return false
        }

        if GameSignals.hasGamingContext(text) && !GameSignals.mentionsSpecificGame(in: text) {
            return false
        }

        return true
    }

    /// 回复文案是否含禁止说教句式（生成后自检用）
    static func containsForbiddenPattern(_ reply: String) -> Bool {
        containsAny(forbiddenReplyPatternsZH, in: reply)
    }

    private static func containsAny(_ keywords: [String], in text: String) -> Bool {
        LanguageSignals.containsAny(keywords, in: text)
    }
}
