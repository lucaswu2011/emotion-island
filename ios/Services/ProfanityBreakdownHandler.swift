import Foundation

/// 情绪崩溃 / 辱骂场景分级 — 先接情绪，温和有界（仅本地 AI）
enum ProfanityBreakdownHandler {

    enum Tier: Sendable {
        case none
        /// 一级：吐槽事件带脏字，非针对助手
        case accompanying
        /// 二级：迁怒助手
        case redirected
        /// 三级：持续人身攻击
        case sustainedAttack
        /// 高敏感：家暴 / 霸凌等，完全接纳
        case highSensitiveAcceptance
    }

    /// 本地 AI：当前句含脏话 / 迁怒时，不走正常场景匹配
    static func shouldBypassScenarioMatch(for text: String) -> Bool {
        containsProfanity(text)
    }

    // MARK: - 关键词

    private static let profanityMarkersZH = [
        "tmd", "TMD", "tm", "TM", "他妈", "妈的", "卧槽", "我操", "我草", "草", "靠",
        "傻逼", "傻b", "傻B", "SB", "sb", "nmsl", "NM", "nm", "去你的", "狗东西",
        "脑残", "废物", "贱", "艹", "操", "屁", "屎", "滚蛋", "妈的逼", "他妈的",
        "狗逼", "畜生", "混蛋", "王八", "贱人", "烂人", "尼玛", "你妹", "cnm", "wcnm",
        "气死", "恶心死了", "真他妈", "真tm", "破事", "破班", "我靠", "去死",
    ]

    private static let profanityMarkersEN = [
        "fuck", "fucking", "shit", "damn", "asshole", "bitch", "bullshit", "wtf", "stfu",
        "garbage", "useless", "idiot", "stupid ai",
    ]

    private static let assistantDirectedZH = [
        "你懂个屁", "懂个屁", "你懂什么", "你懂啥", "懂个啥",
        "什么垃圾东西", "什么垃圾", "垃圾东西", "说的全是废话", "全是废话", "废话",
        "要你有什么用", "要你何用", "有什么用", "有屁用", "屁用没有", "一点用没有",
        "关你屁事", "关你什么事", "你谁啊", "少废话", "没用东西", "废物助手",
        "闭嘴", "你闭嘴", "闭嘴吧你", "滚", "你滚", "别说了", "不想听你说", "不想听你",
        "破助手", "傻助手", "人工智障", "智障", "没用", "说的什么玩意", "什么玩意",
        "你烦", "烦死了你", "别烦我",
    ]

    private static let assistantDirectedEN = [
        "you know nothing", "useless bot", "shut up", "stupid bot", "garbage ai",
        "what's the point of you", "total waste", "you're useless", "dumb ai",
    ]

    private static let highSensitiveKeywordsZH = [
        "家暴", "打我", "被打", "动手打", "一巴掌", "扇我", "霸凌", "孤立", "排挤", "欺负",
        "不想活了", "不想活", "自残", "自杀", "割腕", "想死", "被强奸", "被侵犯", "猥亵",
        "重大挫折", "被辞", "开除", "裁员", "分手", "出轨", "背叛", "流产", "去世", "死了",
        "撑不住", "受不了", "绝望", "崩溃",
    ]

    private static let highSensitiveKeywordsEN = [
        "domestic violence", "hit me", "abuse", "bullied", "bullying", "sexual assault",
        "want to die", "kill myself", "self-harm", "suicide",
    ]

    private static let eventContextZH = [
        "班", "上班", "同事", "老板", "领导", "队友", "同学", "老师", "父母", "妈", "爸",
        "朋友", "考试", "考", "分手", "工作", "游戏", "连跪", "对象", "家里", "学校",
        "公司", "宿舍", "客户", "项目", "事", "事情", "破事", "今天", "刚才", "昨天",
        "老公", "老婆", "渣男", "渣女", "那人", "他们", "这人", "局", "匹配",
    ]

    // MARK: - 话术池

    private static let tier1ZH = [
        "遇上这种事真的太气人了，换谁都得憋一肚子火",
        "确实太离谱了，换我我也得骂两句解气",
        "憋坏了吧，想骂就骂出来，不用憋着，我听着",
        "光听着都觉得火大，也难怪你会这么生气",
    ]

    private static let tier1EN = [
        "That would make anyone furious — no wonder you're this angry.",
        "Yeah, that's genuinely outrageous. I'd need to vent too.",
        "Don't hold it in if cursing helps — I'm here listening.",
        "Even hearing about it makes me heated. Of course you're mad.",
    ]

    private static let tier2ZH = [
        "听起来你现在真的又气又急，才会这么说。是遇到什么不顺心的事了吗？",
        "我知道你现在心里特别难受，要是骂两句能舒服点也没关系。不过也可以跟我说说到底怎么了。",
        "是不是我刚才说的话让你不舒服了？对不起呀，你可以跟我说说是哪里不对。",
        "我懂，人在气头上就是忍不住想说点重话。没事，你先消消气，慢慢说。",
    ]

    private static let tier2EN = [
        "You sound really upset and on edge — did something go wrong?",
        "I get that you're hurting. Vent if you need to — but I'm also here to hear what happened.",
        "Did something I say land wrong? Sorry — tell me what felt off.",
        "People say harsh things when they're flooded. It's okay — take your time.",
    ]

    private static let tier3ZH = [
        "我知道你现在情绪特别差，心里堵得慌。但一直说这样的话，其实也没法真的解气，还会让你更难受。如果有什么委屈，你慢慢说，我会认认真真听的。",
        "我能感受到你现在特别愤怒，但这样的表达真的很伤人。你如果是遇到了什么糟心事，不妨跟我讲讲，我们一起捋捋。",
        "如果你只是想骂人的话，我没办法一直陪着你哦。但等你平复下来，想说说到底发生了什么的时候，我还在这里。",
    ]

    private static let tier3EN = [
        "I can tell you're really overwhelmed. Keeping at this usually doesn't actually release the pain — it just deepens it. If something hurt you, I'm listening for real.",
        "I feel how angry you are, but words like this cut deep. If something bad happened, we can walk through it together.",
        "If you only want to lash out, I can't stay in that loop with you. When you're ready to talk about what happened, I'll still be here.",
    ]

    private static let highSensitiveReplyZH = [
        "我知道你心里太苦太委屈了，想骂就大声骂出来吧，不用忍着，我陪着你",
        "憋了这么久肯定难受坏了，不用顾及什么，都发泄出来就好了",
        "我在呢，你怎么舒服怎么来，骂累了就歇会儿，我一直听着",
    ]

    private static let highSensitiveReplyEN = [
        "You're carrying so much pain — curse it out if you need to. I'm not going anywhere.",
        "You've been holding this in way too long. Let it out however you need.",
        "I'm here. However you need to release this is okay — rest when you're tired, I'm still listening.",
    ]

    private static let calmGuidanceZH = [
        "现在有没有好一点？可以跟我说说到底发生什么了吗？",
        "气消些了吗？要是愿意，跟我讲讲具体是怎么一回事？",
        "慢慢说就好，到底遇到什么让你这么难受？",
    ]

    private static let calmGuidanceEN = [
        "Feeling any better? Want to tell me what actually happened?",
        "Cooled down a little? I'm here if you want to walk me through it.",
        "Take your time — what set this off?",
    ]

    // MARK: - 检测

    static func containsProfanity(_ text: String) -> Bool {
        LanguageSignals.containsAny(profanityMarkersZH + profanityMarkersEN, in: text)
            || isAttackAtAssistant(text)
    }

    static func isAttackAtAssistant(_ text: String) -> Bool {
        if LanguageSignals.containsAny(assistantDirectedZH + assistantDirectedEN, in: text) {
            return true
        }
        let lower = text.lowercased()
        if (lower.contains("你") || lower.contains("you")),
           LanguageSignals.containsAny(profanityMarkersZH + profanityMarkersEN, in: text),
           text.count <= 48 {
            return true
        }
        return false
    }

    static func isHighSensitiveContext(_ text: String, accumulated: String) -> Bool {
        let story = accumulated + " " + text
        return LanguageSignals.containsAny(highSensitiveKeywordsZH + highSensitiveKeywordsEN, in: story)
            || LanguageSignals.containsAny(CompanionRules.highRiskKeywordsZH, in: story)
    }

    static func hasSubstantiveEvent(in text: String) -> Bool {
        if text.count >= 18 { return true }
        return LanguageSignals.containsAny(eventContextZH, in: text)
    }

    static func classify(
        currentText: String,
        accumulated: String,
        attackStreak: Int
    ) -> Tier {
        guard containsProfanity(currentText) else { return .none }

        if isHighSensitiveContext(currentText, accumulated: accumulated) {
            return .highSensitiveAcceptance
        }

        let atAssistant = isAttackAtAssistant(currentText)
        let substantive = hasSubstantiveEvent(in: currentText)

        // 三级：连续人身攻击，无具体事件倾诉
        if atAssistant, attackStreak >= 2, !substantive {
            return .sustainedAttack
        }
        // 二级：迁怒助手（首次或仍带事件上下文）
        if atAssistant {
            return .redirected
        }
        // 一级：吐槽事件带脏字，非针对助手
        return .accompanying
    }

    static func shouldOfferCalmGuidance(
        currentText: String,
        awaitingCalmCheck: Bool
    ) -> Bool {
        guard awaitingCalmCheck else { return false }
        return !containsProfanity(currentText)
            && !LanguageSignals.isThanks(currentText)
            && !ClosingSignals.isFarewellPhrase(currentText)
    }

    // MARK: - 回复

    static func reply(
        tier: Tier,
        boundaryStep: Int,
        lang: AppLanguage,
        seed: Int,
        usedKeys: Set<String>,
        turnCount: Int
    ) -> ChatReply {
        switch tier {
        case .none:
            return ChatReply("", replyKey: "prof_none")
        case .accompanying:
            return pick(from: tier1ZH, en: tier1EN, prefix: "prof_t1", lang: lang, seed: seed, usedKeys: usedKeys)
        case .redirected:
            return pick(from: tier2ZH, en: tier2EN, prefix: "prof_t2", lang: lang, seed: seed, usedKeys: usedKeys)
        case .sustainedAttack:
            let step = min(max(boundaryStep, 0), tier3ZH.count - 1)
            let pool = lang == .english ? tier3EN : tier3ZH
            let key = "prof_t3_b\(step)"
            if !isKeyUsed(key, in: usedKeys) {
                return ChatReply(pool[step], emojis: ["🫂", "💙"], replyKey: key)
            }
            return ChatReply(pool[step], emojis: ["🫂", "💙"], replyKey: "\(key)_t\(turnCount)")
        case .highSensitiveAcceptance:
            return pick(from: highSensitiveReplyZH, en: highSensitiveReplyEN, prefix: "prof_hs", lang: lang, seed: seed, usedKeys: usedKeys)
        }
    }

    static func calmDownGuidanceReply(
        lang: AppLanguage,
        seed: Int,
        usedKeys: Set<String>,
        turnCount: Int
    ) -> ChatReply {
        let pool = lang == .english ? calmGuidanceEN : calmGuidanceZH
        let used = pool.indices.filter { isKeyUsed("prof_calm_\($0)", in: usedKeys) }
        let idx = pickIndex(from: pool.count, used: used, seed: seed)
        let key = used.count < pool.count ? "prof_calm_\(idx)" : "prof_calm_\(idx)_t\(turnCount)"
        return ChatReply(pool[idx], emojis: ["🫂", "🌿"], replyKey: key)
    }

    static func isProfanityReplyKey(_ key: String) -> Bool {
        key.hasPrefix("prof_")
    }

    static func isTier3ReplyKey(_ key: String) -> Bool {
        key.hasPrefix("prof_t3_b")
    }

    static func isCalmGuidanceKey(_ key: String) -> Bool {
        key.hasPrefix("prof_calm")
    }

    // MARK: - Helpers

    private static func pick(
        from zh: [String],
        en: [String],
        prefix: String,
        lang: AppLanguage,
        seed: Int,
        usedKeys: Set<String>
    ) -> ChatReply {
        let pool = lang == .english ? en : zh
        let used = pool.indices.filter { isKeyUsed("\(prefix)_\($0)", in: usedKeys) }
        let idx = pickIndex(from: pool.count, used: used, seed: seed)
        return ChatReply(pool[idx], emojis: ["🫂", "💙"], replyKey: "\(prefix)_\(idx)")
    }

    private static func pickIndex(from count: Int, used: [Int], seed: Int) -> Int {
        let available = (0..<count).filter { !used.contains($0) }
        guard !available.isEmpty else { return seed % max(count, 1) }
        return available[seed % available.count]
    }

    private static func isKeyUsed(_ key: String, in usedKeys: Set<String>) -> Bool {
        usedKeys.contains(key) || usedKeys.contains { $0.hasPrefix(key + "_") }
    }
}
