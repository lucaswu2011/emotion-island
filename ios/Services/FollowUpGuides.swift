import Foundation

/// 通用引导词 + 二级承接话术（按正向 / 负向 / 中性分池，高敏感场景仍用模板自带引导）
enum FollowUpGuides {

    // MARK: - 通用引导词池

    private static let guidesPositiveZH = [
        "当时是不是超有成就感 / 超爽的？",
        "整个过程是不是还挺顺利的？",
        "接下来打算怎么庆祝 / 接着冲点什么？",
    ]
    private static let guidesPositiveEN = [
        "Did that feel amazing in the moment?",
        "Did the whole thing go pretty smoothly?",
        "How are you planning to celebrate — or what’s next?",
    ]

    private static let guidesNegativeZH = [
        "是不是越想越憋屈 / 越想越气？",
        "最让你难受的是哪部分呀？",
        "想多吐槽一会儿还是先缓缓？",
    ]
    private static let guidesNegativeEN = [
        "Does it feel worse the more you think about it?",
        "Which part hits you the hardest?",
        "Want to vent a bit more, or take a breather first?",
    ]

    private static let guidesNeutralZH = [
        "那这会儿在干嘛呢？",
        "今天有没有什么稍微有点意思的小事？",
        "就想随便聊聊还是想找点话题？",
    ]
    private static let guidesNeutralEN = [
        "What are you up to right now?",
        "Anything slightly interesting happen today?",
        "Just chatting, or want me to throw out a topic?",
    ]

    // MARK: - 二级承接话术池

    private static let repliesPositiveZH = [
        "原来是这样！难怪这么开心，换我我也得乐半天",
        "哈哈哈我就知道！这种快乐真的能持续好久",
        "也太厉害了吧，这波完全是你应得的",
        "真好呀，接下来可以好好放松一下了",
    ]
    private static let repliesPositiveEN = [
        "Oh, that makes sense — no wonder you're so happy. I'd be grinning too.",
        "Ha, I knew it! That kind of joy really sticks around.",
        "That's seriously impressive — you totally earned this.",
        "Love that. You can really let yourself relax now.",
    ]

    private static let repliesNegativeZH = [
        "确实，换谁遇上这种事都得难受半天",
        "没事，想吐槽就多吐槽会儿，我听着呢",
        "害，都已经过去了，别太往心里去",
        "不说这个啦，要不要聊点别的开心的？",
    ]
    private static let repliesNegativeEN = [
        "Yeah — anyone in your shoes would feel awful for a while.",
        "It's okay. Vent as much as you need — I'm here.",
        "Hey, it's in the past. Don't carry it too hard.",
        "Let's switch gears — want to talk about something lighter?",
    ]

    private static let repliesNeutralZH = [
        "哈哈听起来还挺舒服的",
        "这样也挺好的，安安稳稳的",
        "要不要我陪你聊点别的？",
    ]
    private static let repliesNeutralEN = [
        "Ha, that actually sounds pretty chill.",
        "That's nice — steady and calm has its own charm.",
        "Want me to keep you company with something else?",
    ]

    private static let ultimateFallbackZH = [
        "原来是这样啊",
        "哈哈还挺有意思的",
        "确实，换谁都这样",
    ]
    private static let ultimateFallbackEN = [
        "Oh, I see.",
        "Ha, that's kind of interesting actually.",
        "Yeah — anyone would feel that way.",
    ]

    // MARK: - Public API

    /// 从通用池抽一条引导词；高敏感场景在 `ScenarioLibrary.reply` 里走模板 followUp
    static func universalGuide(
        for tone: SentimentTone,
        lang: AppLanguage,
        seed: Int,
        usedKeys: Set<String>
    ) -> (text: String, key: String)? {
        let pool = guidePool(for: tone, lang: lang)
        guard !pool.isEmpty else { return nil }
        let toneTag = toneTag(for: tone)
        let used = pool.indices.filter { usedKeys.contains("ufg_\(toneTag)_\($0)") }
        let idx = pickUnused(from: pool.count, used: used, seed: seed)
        return (pool[idx], "ufg_\(toneTag)_\(idx)")
    }

    /// 用户回答引导词后的二级承接（不再做场景匹配）
    static func followUpReply(
        for tone: SentimentTone,
        lang: AppLanguage,
        seed: Int,
        usedKeys: Set<String>
    ) -> ChatReply {
        let pool = replyPool(for: tone, lang: lang)
        let toneTag = toneTag(for: tone)
        let prefix = "ufr_\(toneTag)"
        let used = pool.indices.filter { usedKeys.contains("\(prefix)_\($0)") }

        if used.count < pool.count {
            let idx = pickUnused(from: pool.count, used: used, seed: seed)
            return ChatReply(
                pool[idx],
                emojis: emojis(for: tone),
                replyKey: "\(prefix)_\(idx)"
            )
        }

        let fallback = ultimateFallback(lang: lang)
        let fUsed = fallback.indices.filter { usedKeys.contains("ufr_fb_\($0)") }
        let fIdx = pickUnused(from: fallback.count, used: fUsed, seed: seed + 3)
        return ChatReply(
            fallback[fIdx],
            emojis: emojis(for: tone),
            replyKey: "ufr_fb_\(fIdx)"
        )
    }

    /// 从上一轮 replyKey 解析「待承接」情绪（仅通用引导 ufg_）
    static func universalPendingTone(from replyKey: String) -> SentimentTone? {
        for part in replyKey.split(separator: "|") {
            let key = String(part)
            if key.hasPrefix("ufg_pos") { return .positive }
            if key.hasPrefix("ufg_neg") { return .negative }
            if key.hasPrefix("ufg_neu") { return .neutral }
        }
        return nil
    }

    /// 含通用或高敏感引导（cfg_）— 仅用于调试 / 扩展
    static func pendingTone(from replyKey: String) -> SentimentTone? {
        for part in replyKey.split(separator: "|") {
            let key = String(part)
            if key.hasPrefix("ufg_pos") || key.hasPrefix("cfg_pos") { return .positive }
            if key.hasPrefix("ufg_neg") || key.hasPrefix("cfg_neg") { return .negative }
            if key.hasPrefix("ufg_neu") || key.hasPrefix("cfg_neu") { return .neutral }
        }
        return nil
    }

    static func isFollowUpReply(_ replyKey: String) -> Bool {
        replyKey.split(separator: "|").contains { $0.hasPrefix("ufr_") }
    }

    /// 高敏感场景专用引导 key（仍走模板 followUp 文案）
    static func customGuideKey(tone: SentimentTone, index: Int) -> String {
        "cfg_\(toneTag(for: tone))_\(index)"
    }

    // MARK: - Helpers

    private static func guidePool(for tone: SentimentTone, lang: AppLanguage) -> [String] {
        switch (tone, lang) {
        case (.positive, .english): return guidesPositiveEN
        case (.negative, .english): return guidesNegativeEN
        case (.neutral, .english): return guidesNeutralEN
        case (.positive, _): return guidesPositiveZH
        case (.negative, _): return guidesNegativeZH
        case (.neutral, _): return guidesNeutralZH
        }
    }

    private static func replyPool(for tone: SentimentTone, lang: AppLanguage) -> [String] {
        switch (tone, lang) {
        case (.positive, .english): return repliesPositiveEN
        case (.negative, .english): return repliesNegativeEN
        case (.neutral, .english): return repliesNeutralEN
        case (.positive, _): return repliesPositiveZH
        case (.negative, _): return repliesNegativeZH
        case (.neutral, _): return repliesNeutralZH
        }
    }

    private static func ultimateFallback(lang: AppLanguage) -> [String] {
        lang == .english ? ultimateFallbackEN : ultimateFallbackZH
    }

    private static func toneTag(for tone: SentimentTone) -> String {
        switch tone {
        case .positive: return "pos"
        case .negative: return "neg"
        case .neutral: return "neu"
        }
    }

    private static func emojis(for tone: SentimentTone) -> [String] {
        switch tone {
        case .positive: return ["😊", "✨"]
        case .negative: return ["🫂", "💙"]
        case .neutral: return ["🌿", "👂"]
        }
    }

    private static func pickUnused(from count: Int, used: [Int], seed: Int) -> Int {
        let available = (0..<count).filter { !used.contains($0) }
        guard !available.isEmpty else { return seed % max(count, 1) }
        return available[seed % available.count]
    }
}
