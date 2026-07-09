import Foundation

/// 多轮对话回复库 — 语气轻柔，像坐在旁边 quietly 陪着
enum ConversationResponses {

    // MARK: - 深度倾听

    static let deepListening: [ChatReply] = [
        ChatReply("嗯，我在。你不用把话说漂亮，就这样慢慢讲给我听就好。", emojis: ["🫂", "👂"], replyKey: "listen_1"),
        ChatReply("这些压在心上很久了吧…不急着停下来，我哪儿也不去。", emojis: ["🫂", "🌿"], replyKey: "listen_2"),
        ChatReply("你愿意一直跟我说，本身就很珍贵了。我会好好听。", emojis: ["🫂", "💙"], replyKey: "listen_3"),
        ChatReply("说多少都可以，我不会嫌烦，也不会催你快好起来。", emojis: ["🫂", "🥺"], replyKey: "listen_4"),
        ChatReply("一点一点讲出来，也许会轻一些。我陪着你。", emojis: ["🫂", "🌙"], replyKey: "listen_5"),
        ChatReply("情绪不用先收好再来。就这样倒给我，也可以的。", emojis: ["🫂", "🍵"], replyKey: "listen_6"),
    ]

    // MARK: - 持续崩溃

    static let overwhelming: [ChatReply] = [
        ChatReply("听起来，你真的已经撑到极限了…先别逼自己「想开」，你已经很努力了。", emojis: ["🫂", "💙", "🌿"], replyKey: "over_1"),
        ChatReply("崩溃的时候，整个世界都会变重。这不是你脆弱，是你承受太多了。", emojis: ["🫂", "🥺"], replyKey: "over_2"),
        ChatReply("如果现在什么都做不了，也没关系。就先待在这一刻，我陪着你。", emojis: ["🫂", "🌙", "💙"], replyKey: "over_3"),
        ChatReply("你不需要马上好起来。乱一点、痛一点，都是被允许的。", emojis: ["🫂", "🌿"], replyKey: "over_4"),
        ChatReply("能一句一句讲出来，已经很勇敢了。不管多乱，我都在。", emojis: ["🫂", "👂", "💙"], replyKey: "over_5"),
    ]

    // MARK: - 反复说「还是难受」

    static let stillHurting: [ChatReply] = [
        ChatReply("嗯，我知道…有些感受不会一下子消失，这很正常。", emojis: ["🫂", "🌿"], replyKey: "still_1"),
        ChatReply("还是难受，对吗？没关系，不用急着好起来，我在这儿。", emojis: ["🫂", "💙"], replyKey: "still_2"),
        ChatReply("你已经讲了很多，还是痛…说明那件事真的伤到了你。", emojis: ["🫂", "🥺"], replyKey: "still_3"),
        ChatReply("我们可以就这样待着。不急着解决问题，只是陪着。", emojis: ["🫂", "🌙"], replyKey: "still_4"),
    ]

    // MARK: - 按情绪轮换

    static func intentPool(_ intent: EmotionIntent) -> [ChatReply] {
        switch intent {
        case .sadness, .maskedLoneliness:
            return [
                ChatReply("难过的时候，能讲出来就已经很了不起了。", emojis: ["🫂", "🥺"], replyKey: "sad_1"),
                ChatReply("眼泪也好，沉默也好，都算数，不需要谁批准。", emojis: ["🫂", "💙"], replyKey: "sad_2"),
                ChatReply("有些痛不是一句话能说完的…我陪你慢慢讲。", emojis: ["🫂", "🌿"], replyKey: "sad_3"),
                ChatReply("今天很难，但至少这一刻，你不用一个人扛着。", emojis: ["🫂", "🌙"], replyKey: "sad_4"),
            ]
        case .frustration:
            return [
                ChatReply("憋屈和委屈都是真实的，不需要先「消化掉」才成立。", emojis: ["🫂", "🥺"], replyKey: "fru_1"),
                ChatReply("被误解、被忽视的感觉，真的会让人喘不过气…", emojis: ["🫂", "💙"], replyKey: "fru_2"),
                ChatReply("你的委屈成立，不需要任何人来盖章。", emojis: ["🫂", "🌿"], replyKey: "fru_3"),
            ]
        case .anger:
            return [
                ChatReply("生气不代表你不够好，只是说明你在乎。", emojis: ["🫂", "💙"], replyKey: "ang_1"),
                ChatReply("边界被跨过时的愤怒，完全合理。", emojis: ["🫂", "🛡️"], replyKey: "ang_2"),
                ChatReply("你不需要马上原谅谁，先让情绪被听见。", emojis: ["🫂", "🌿"], replyKey: "ang_3"),
            ]
        case .anxiety, .fear:
            return [
                ChatReply("担心的时候，身体往往比脑子先反应过来…慢慢来。", emojis: ["🤗", "🫂"], replyKey: "fear_1"),
                ChatReply("害怕的时候不用一个人扛，我们可以慢慢理。", emojis: ["🫂", "🌿"], replyKey: "fear_2"),
                ChatReply("未来还没来，此刻你先安全地待在这里。", emojis: ["🫂", "💙"], replyKey: "fear_3"),
            ]
        case .exhaustion:
            return [
                ChatReply("累了就歇一歇，今天已经够辛苦了。", emojis: ["🫂", "🍵"], replyKey: "ex_1"),
                ChatReply("撑了这么久，允许自己软下来一会儿。", emojis: ["🫂", "🌙"], replyKey: "ex_2"),
            ]
        case .disappointment:
            return [
                ChatReply("期待落空了，失望是真实的。", emojis: ["🫂", "🌧️"], replyKey: "dis_1"),
                ChatReply("不是你要求太多，只是今天比较难。", emojis: ["🫂", "🌈"], replyKey: "dis_2"),
            ]
        case .confusion:
            return [
                ChatReply("不知道怎么办的时候，先讲出来就已经很好了。", emojis: ["🌿", "🫂"], replyKey: "con_1"),
                ChatReply("不必马上想清楚，混乱也是过程的一部分。", emojis: ["🫂", "💙"], replyKey: "con_2"),
            ]
        default:
            return [
                ChatReply("谢谢你愿意告诉我…被听见本身就有意义。", emojis: ["🫂", "💙"], replyKey: "gen_1"),
                ChatReply("有些感受不用说完美，讲出来就已经够了。", emojis: ["🫂", "🌿"], replyKey: "gen_2"),
            ]
        }
    }

    // MARK: - 话题安慰

    static func topicReply(_ topic: ConversationTopic, text: String) -> ChatReply? {
        switch topic {
        case .exam:
            if text.contains("真实水平") || text.contains("没发挥") || text.contains("发挥") {
                return ChatReply(
                    "一次失利算不了什么，真实水平不会因此被抹掉。你已经很努力了，继续走下去，一定可以的。",
                    emojis: ["🫂", "💪", "✨"],
                    replyKey: "exam_perf"
                )
            }
            return ChatReply(
                "考试的事确实让人心里不好受…一次结果，代表不了你的全部。",
                emojis: ["🫂", "📚", "💙"],
                replyKey: "exam_gen"
            )
        case .relationship:
            if text.contains("冤枉") || text.contains("委屈") {
                return ChatReply(
                    "被冤枉、被误解…真的很难受。你的委屈是成立的。",
                    emojis: ["🫂", "🥺", "💙"],
                    replyKey: "rel_wrong"
                )
            }
            return ChatReply(
                "人际的事往往最磨人…你能讲出来，本身就很勇敢。",
                emojis: ["🫂", "💙"],
                replyKey: "rel_gen"
            )
        case .family:
            return ChatReply(
                "家里的事，有时候最说不出口，也最难消化…我在这儿，慢慢听你说。",
                emojis: ["🫂", "🏠", "💙"],
                replyKey: "family"
            )
        case .boundaryViolation:
            return ChatReply(
                "东西被擅自拿走，生气是完全合理的。你的边界，值得被尊重。",
                emojis: ["🫂", "🛡️", "💙"],
                replyKey: "boundary"
            )
        case .loneliness:
            return ChatReply(
                "孤独的时候，有人愿意听…本身就是一种温暖。",
                emojis: ["🫂", "🌙", "💙"],
                replyKey: "lonely"
            )
        case .selfBlame:
            return ChatReply(
                "别急着怪自己…你已经很努力了，这件事不全是你的错。",
                emojis: ["🫂", "🌿", "💙"],
                replyKey: "self_blame"
            )
        default:
            return nil
        }
    }

    static let gratitude: [ChatReply] = [
        ChatReply("能陪你一会儿，我也很开心。如果还想聊，我会一直在。", emojis: ["🫂", "😊"], replyKey: "thanks_1"),
        ChatReply("不用谢…你的感受，永远值得被认真对待。", emojis: ["🫂", "🌸"], replyKey: "thanks_2"),
    ]

    static let gentleCheckIn: [ChatReply] = [
        ChatReply("如果还想多说一点，我在这儿。或者就这样待一会儿，也可以。", emojis: ["🫂", "👂"], replyKey: "check_1"),
        ChatReply("心里还有话，就慢慢讲…时间有的是。", emojis: ["🫂", "🌿"], replyKey: "check_2"),
    ]

    // MARK: - 分段倾诉：轻柔接住，再轻轻邀请

    static let partialInvite: [ChatReply] = [
        ChatReply("嗯，我听到了…心里乱也没关系，想到哪就说到哪吧。", emojis: ["👂", "🫂"], replyKey: "part_1"),
        ChatReply("我在这儿…如果愿意的话，可以接着慢慢讲。", emojis: ["👂", "🥺"], replyKey: "part_2"),
        ChatReply("不用把话组织得很完整，卡在哪，就从哪开始。", emojis: ["🫂", "🌿"], replyKey: "part_3"),
        ChatReply("你刚才讲的，我都记住了…要是还有想说的，我听着。", emojis: ["👂", "💙"], replyKey: "part_4"),
        ChatReply("不用急着讲成完整的故事…一句一句来，我陪你。", emojis: ["🫂", "👂"], replyKey: "part_5"),
    ]

    static func fragmentEcho(text: String, topic: ConversationTopic) -> ChatReply? {
        let snippet = String(text.prefix(16))

        switch topic {
        case .exam:
            return ChatReply(
                "嗯，\(snippet)…考试的事，确实容易压在心里。后来…还发生了什么吗？",
                emojis: ["👂", "📚"],
                replyKey: "echo_exam"
            )
        case .relationship:
            return ChatReply(
                "「\(snippet)」…人际的事，往往最说不出口。如果愿意，可以慢慢讲给我听。",
                emojis: ["👂", "🥺"],
                replyKey: "echo_rel"
            )
        case .family:
            return ChatReply(
                "家里的事，\(snippet)…慢慢讲，我在这儿听着。",
                emojis: ["👂", "🏠"],
                replyKey: "echo_family"
            )
        case .work:
            return ChatReply(
                "「\(snippet)」…工作上的事，确实磨人。后来呢…？",
                emojis: ["👂", "☕️"],
                replyKey: "echo_work"
            )
        case .boundaryViolation:
            return ChatReply(
                "听到了…\(snippet)。如果不太难讲，可以多告诉我一些吗？",
                emojis: ["👂", "🛡️"],
                replyKey: "echo_boundary"
            )
        default:
            return nil
        }
    }

    static func contextualFollowUp(
        text: String,
        accumulated: String,
        topic: ConversationTopic,
        usedKeys: Set<String>
    ) -> ChatReply? {
        switch topic {
        case .exam:
            return examFollowUp(text: text, accumulated: accumulated, usedKeys: usedKeys)
        case .relationship:
            return relationshipFollowUp(accumulated: accumulated, usedKeys: usedKeys)
        case .family:
            return familyFollowUp(accumulated: accumulated, usedKeys: usedKeys)
        case .work:
            return workFollowUp(accumulated: accumulated, usedKeys: usedKeys)
        default:
            return nil
        }
    }

    private static func examFollowUp(text: String, accumulated: String, usedKeys: Set<String>) -> ChatReply? {
        let hasExamPain = ["考试", "题目", "没做出来", "没做出", "没发挥", "不会做", "写不出", "空着", "没写完"]
            .contains { accumulated.contains($0) }

        guard hasExamPain else { return nil }

        if !mentionsExamSubject(accumulated), !usedKeys.contains("ask_exam_subject") {
            if text.contains("明明") || text.contains("会做的") || text.contains("没做出来") {
                return ChatReply(
                    "明明会做的题却没做出来…一定特别憋屈吧。如果不太难说，是哪一科的事呢？",
                    emojis: ["👂", "🥺"],
                    replyKey: "ask_exam_subject"
                )
            }
            return ChatReply(
                "听起来，心里一定不好受…如果方便的话，能跟我讲讲是哪一科吗？",
                emojis: ["👂", "📚"],
                replyKey: "ask_exam_subject"
            )
        }

        if mentionsExamSubject(accumulated), !mentionsExamCause(accumulated), !usedKeys.contains("ask_exam_cause") {
            return ChatReply(
                "嗯，\(examSubjectSnippet(from: accumulated))…那时候，是什么让你没做出来呢？",
                emojis: ["👂", "🫂"],
                replyKey: "ask_exam_cause"
            )
        }

        if !usedKeys.contains("ask_exam_feeling"), accumulated.count < 55 {
            return ChatReply(
                "考场上出这种岔子，心里一定很难受…当时，你是什么感觉？",
                emojis: ["👂", "🥺"],
                replyKey: "ask_exam_feeling"
            )
        }

        return nil
    }

    private static func relationshipFollowUp(accumulated: String, usedKeys: Set<String>) -> ChatReply? {
        if !mentionsPerson(accumulated), !usedKeys.contains("ask_who") {
            return ChatReply(
                "如果不太难讲…是谁的事呢？",
                emojis: ["👂", "🥺"],
                replyKey: "ask_who"
            )
        }
        if mentionsPerson(accumulated), !usedKeys.contains("ask_what_happened") {
            return ChatReply(
                "后来…发生了什么？慢慢讲，我听着。",
                emojis: ["👂", "🫂"],
                replyKey: "ask_what_happened"
            )
        }
        return nil
    }

    private static func familyFollowUp(accumulated: String, usedKeys: Set<String>) -> ChatReply? {
        if !usedKeys.contains("ask_family_detail") {
            return ChatReply(
                "家里的事，往往最难说出口…如果愿意，可以慢慢讲给我听。",
                emojis: ["👂", "🏠"],
                replyKey: "ask_family_detail"
            )
        }
        return nil
    }

    private static func workFollowUp(accumulated: String, usedKeys: Set<String>) -> ChatReply? {
        if !usedKeys.contains("ask_work_detail") {
            return ChatReply(
                "工作上的事，确实磨人…是哪方面，让你心里这么堵呢？",
                emojis: ["👂", "☕️"],
                replyKey: "ask_work_detail"
            )
        }
        return nil
    }

    private static func mentionsExamSubject(_ text: String) -> Bool {
        let subjects = [
            "数学", "语文", "英语", "物理", "化学", "生物", "历史", "地理", "政治",
            "理科", "文科", "科目", "期中", "期末", "月考"
        ]
        return subjects.contains { text.contains($0) }
    }

    private static func mentionsExamCause(_ text: String) -> Bool {
        let causes = [
            "因为", "紧张", "太紧张", "时间", "来不及", "不够", "忘了", "脑子空白",
            "手抖", "压力", "慌", "粗心", "看错题", "涂错"
        ]
        return causes.contains { text.contains($0) }
    }

    private static func examSubjectSnippet(from text: String) -> String {
        let subjects = ["数学", "语文", "英语", "物理", "化学", "生物", "历史", "地理", "政治"]
        if let subject = subjects.first(where: { text.contains($0) }) {
            return "\(subject)那场考试"
        }
        return "那场考试"
    }

    private static func mentionsPerson(_ text: String) -> Bool {
        let people = ["朋友", "同学", "老师", "他", "她", "他们", "某人", "室友", "闺蜜", "男朋友", "女朋友"]
        return people.contains { text.contains($0) }
    }

    static func emotionEcho(_ text: String, intent: EmotionIntent) -> ChatReply {
        switch intent {
        case .frustration, .sadness:
            return ChatReply(
                "「\(text)」…听到了。今天…是发生什么事了吗？",
                emojis: ["🥺", "👂"],
                replyKey: "echo_emotion_sad"
            )
        case .anger:
            return ChatReply(
                "「\(text)」…生气，一定是有原因的。如果愿意，可以慢慢讲给我听。",
                emojis: ["👂", "💙"],
                replyKey: "echo_emotion_ang"
            )
        case .anxiety, .fear:
            return ChatReply(
                "「\(text)」…担心的事，可以慢慢讲。先从最压在你心里的那件说起，好吗？",
                emojis: ["🤗", "👂"],
                replyKey: "echo_emotion_fear"
            )
        default:
            return ChatReply(
                "「\(text)」…我在这儿。不用急，想到什么就先轻轻放下一句。",
                emojis: ["🫂", "👂"],
                replyKey: "echo_emotion_gen"
            )
        }
    }
}
