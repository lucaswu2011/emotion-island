import Foundation

/// 校园霸凌专属场景 — 高伤害、强羞耻感；零受害者有罪论，纯安抚不反问（comfortOnly）
extension ScenarioLibrary {

    static let schoolBullyingNegative: [Template] = [
        // MARK: - 一、肢体与财物霸凌

        Template(
            id: "bully_physical_assault",
            keywords: [
                "堵在走廊", "堵在厕所", "厕所里面", "厕所里", "暴打", "推了好几下", "踹了我一脚",
                "不敢还手", "打了一巴掌", "好多人看着", "特别丢人", "被同学打", "被几个人打",
                "推搡", "打骂", "动手打", "被打", "被欺负", "霸凌", "隐私照", "被拍",
                "pushed me", "hit me at school", "beaten up", "school bully", "bullied",
            ],
            tone: .negative, priority: 14,
            responses: [
                "光听着都觉得又疼又怕，当着那么多人被欺负，肯定又委屈又慌对吧。这绝对不是你的错，动手的人才是真的没道理。",
                "抱抱你，被欺负的时候不敢还手太正常了，换谁面对好几个人都会慌。不是你懦弱，是他们太过分了。",
                "肯定吓坏了吧，要是身上有伤也不用一个人扛着，难受就多跟我说会儿，我陪着你。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "That sounds terrifying and humiliating — and none of it is your fault. The ones who hurt you are wrong.",
                "Not fighting back when you're outnumbered isn't weakness. Anyone would freeze.",
                "You must've been scared. You don't have to act tough — I'm right here with you.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),
        Template(
            id: "bully_extortion",
            keywords: [
                "堵我要零花钱", "抢我东西", "勒索", "威胁我不许告诉", "抢了新买的", "高年级的人",
                "天天堵我", "抢东西", "要零花钱", "extortion", "took my money", "stole my stuff",
            ],
            tone: .negative, priority: 14,
            responses: [
                "天天被这么威胁着，上学肯定都提心吊胆的吧。明明是自己的东西，却要平白被抢走，又气又怕还不敢说，太憋屈了。",
                "被人要挟的感觉最熬人了，每天都怕碰到他们，连上学都成了负担。这不是你的问题，是他们太蛮横了。",
                "一直憋着肯定特别难受吧，不用怕，想吐槽都可以说出来，我陪着你。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "Living under that threat every day must be exhausting. It's not your fault — they're the ones crossing the line.",
                "Having your things taken and being silenced is so unfair. You don't have to carry this alone.",
                "Keeping it in this long must hurt. Vent as much as you need — I'm listening.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),

        // MARK: - 二、语言与社交霸凌

        Template(
            id: "bully_nickname",
            keywords: [
                "起外号", "难听的外号", "天天喊", "越生气他们越喊", "起哄", "嘲笑", "长得胖", "戴眼镜",
                "侮辱性外号", "nickname", "mocked me", "made fun of me", "laughed at me",
            ],
            tone: .negative, priority: 14,
            responses: [
                "天天被拿缺点开玩笑，还要被所有人起哄，肯定又难堪又生气吧。拿别人的痛处当乐子，真的特别没教养。",
                "我懂那种当众被调侃的窘迫，想反驳又怕闹得更大，只能憋着，越憋越委屈。这不是你该被嘲笑的理由，是他们太不尊重人了。",
                "被喊一次就难受一次，天天这么喊，上学肯定都成了煎熬吧。别往心里去，他们说的根本不是真的你。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Being mocked in front of everyone is humiliating — using someone's pain as entertainment says everything about them, not you.",
                "Wanting to push back but fearing it'll get worse — that trapped feeling is so real. You don't deserve this.",
                "Hearing it day after day wears you down. What they say isn't who you are.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),
        Template(
            id: "bully_isolation",
            keywords: [
                "宿舍", "孤立我", "故意孤立", "不叫我", "背后说我坏话", "没人愿意和我坐", "一个人吃饭",
                "小团体", "融不进去", "排挤", "isolated", "excluded", "left out", "no one talks to me",
            ],
            tone: .negative, priority: 14,
            responses: [
                "明明在同一个集体里，却像被隔绝在外，热热闹闹都是别人的，自己只有孤单，这种感觉太熬人了。",
                "被孤立最容易让人自我怀疑了，总忍不住想「是不是我不好」。但这真的不是你的问题，只是他们狭隘又幼稚，不配和你做朋友。",
                "一个人吃饭、一个人上课，肯定特别难熬吧。不用勉强自己融进去，你值得真正愿意和你做朋友的人。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Being shut out while everyone else belongs together — that loneliness cuts deep.",
                "Isolation makes you doubt yourself, but it's not because you're wrong — it's because they're narrow and cruel.",
                "Eating and sitting alone every day is hard. You don't have to force yourself in — you deserve real friends.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),
        Template(
            id: "bully_rumor",
            keywords: [
                "造黄谣", "传谣言", "乱讲", "全年级都在议论", "说的特别脏", "抬不起头",
                "泼脏水", "谣言", "rumor", "spread lies", "gossip about me", "slut-shaming",
            ],
            tone: .negative, priority: 14,
            responses: [
                "平白无故被泼脏水，还要被陌生人指指点点，肯定又委屈又羞耻，连出门都觉得抬不起头对吧。造谣的人最卑劣了，错的从来都不是你。",
                "我懂那种百口莫辩的无力，越解释传得越凶，只能自己憋着难受。这根本不是你的问题，是他们嘴碎又恶毒。",
                "被谣言缠上真的太煎熬了，好像怎么做都洗不清。别拿别人的错误惩罚自己，你没有任何错。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "Being smeared and stared at is shameful and unfair — the ones who spread lies are the ones who should be ashamed.",
                "Trying to explain and watching it spread anyway — that helplessness is crushing. None of this is your fault.",
                "Rumors stick in the worst way. Don't punish yourself for someone else's cruelty.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),
        Template(
            id: "bully_online",
            keywords: [
                "班级群", "挂在群里骂", "朋友圈", "匿名骂", "被转发", "网络霸凌", "不敢看手机",
                "群聊骂", "挂人", "cyberbullying", "group chat", "posted about me", "online bullying",
            ],
            tone: .negative, priority: 14,
            responses: [
                "当着那么多同学的面被骂，连手机都不敢点开，肯定又慌又委屈吧。躲在屏幕后面恶意伤人，真的特别懦弱又过分。",
                "公开被指责、被围观的感觉太窒息了，好像所有人都在看你笑话。这不是你该承受的，造谣骂人的人才该羞愧。",
                "一直盯着手机看只会更难受，别逼自己去看那些难听话。你没有错，不用为别人的恶意买单。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "Being attacked in front of everyone online — no wonder you're afraid to open your phone. Hiding behind a screen doesn't make them brave.",
                "Public shaming feels suffocating. You don't deserve this; they do.",
                "You don't have to keep reading the hate. Their words aren't your responsibility.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),

        // MARK: - 三、霸凌后的心理困境

        Template(
            id: "bully_afraid_to_tell",
            keywords: [
                "不敢告诉老师", "怕报复", "告诉爸妈", "说了也没人信", "说我没用", "说我惹事",
                "不敢告诉", "怕被说矫情", "afraid to tell", "won't believe me", "scared of revenge",
            ],
            tone: .negative, priority: 14,
            responses: [
                "我特别懂这种顾虑，怕说了之后更惨，怕大人不理解还反过来怪你，所以只能自己扛着，太不容易了。",
                "怕报复太正常了，换谁都会犹豫，不是你胆小。如果暂时不想说也没关系，不用逼自己，你怎么安全怎么来。",
                "不被理解的感觉最委屈了，明明自己是受害者，还要被指责。没关系，我相信你，我知道不是你的错。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Fearing worse retaliation or being blamed — carrying this alone is so hard. I believe you.",
                "Being afraid of revenge is normal. You don't have to speak up before you're ready — safety first.",
                "Not being believed when you're the one hurt is devastating. It's not your fault.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),
        Template(
            id: "bully_self_blame",
            keywords: [
                "是不是我真的", "太奇怪", "都不喜欢我", "性格不好", "才会被孤立", "才会被欺负",
                "我的问题", "是不是我有问题", "my fault", "something wrong with me", "deserve it",
            ],
            tone: .negative, priority: 14,
            responses: [
                "千万别这么想啊。被欺负从来都不是因为你不好，是欺负人的人本身就坏。哪怕你性格再完美，想欺负你的人照样能找到理由。",
                "我知道长期被否定，很容易会信以为真。可你没有做错什么，你只是和他们不一样而已，不一样不代表有错。",
                "错的是随意伤害别人的人，不是你。你不用为别人的恶意找理由，更不用拿他们的错惩罚自己。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Please don't turn their cruelty inward. Being targeted never means you're broken — bullies hurt because they choose to.",
                "When people keep tearing you down, it's easy to believe them. But you didn't do anything wrong — being different isn't a fault.",
                "The harm is theirs, not yours. You don't owe anyone an excuse for their behavior.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),
        Template(
            id: "bully_fought_back_worse",
            keywords: [
                "顶过嘴", "变本加厉", "告过老师", "没用", "被堵着骂", "更惨了", "都不敢说话",
                "反抗", "试过办法", "fought back", "got worse", "told teacher", "didn't help",
            ],
            tone: .negative, priority: 14,
            responses: [
                "鼓起勇气反抗却换来更糟的结果，肯定特别绝望吧。不是你反抗没用，是他们太恶劣了。你已经很勇敢了。",
                "试过办法却没用，反而更难了，那种无力感肯定特别熬人。不用怪自己，你已经做了能做的所有事了。",
                "我知道你肯定特别无助，好像怎么做都逃不开。别硬扛，难受就跟我多说会儿，我陪着你。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Standing up and being punished harder — that's devastating. You were brave; they're the problem.",
                "Trying and failing can feel like proof nothing works. You did what you could — don't blame yourself.",
                "Feeling trapped no matter what you try is exhausting. You don't have to carry this alone — I'm here.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),

        // MARK: - 四、长期遗留阴影

        Template(
            id: "bully_past_trauma",
            keywords: [
                "过去好几年", "突然想起", "以前被欺负", "霸凌的阴影", "忘不了", "上学时候被霸凌",
                "都毕业了", "years ago", "still hurts", "school trauma", "bullied in school",
            ],
            tone: .negative, priority: 13,
            responses: [
                "那些伤害不是过去了就会消失的，哪怕过了很久，想起来还是会疼太正常了。不是你矫情，是当时的你真的受了太多委屈。",
                "学生时代的伤，总会悄悄留很久。不用逼自己「快点放下」，能承认它疼，就已经很勇敢了。",
                "虽然都过去了，但当时的无助和委屈都是真的。辛苦了，那时候小小的你，一个人扛了那么久。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Old wounds can still ache — that doesn't mean you're weak. What you went through was real.",
                "You don't have to \"get over it\" on anyone's timeline. Naming the hurt is already brave.",
                "That younger you carried so much alone. I'm sorry it happened.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),
        Template(
            id: "bully_social_anxiety_after",
            keywords: [
                "不敢和别人主动", "怕别人讨厌", "特别敏感", "是不是在说我", "以前被孤立",
                "不敢社交", "自卑", "social anxiety", "afraid to talk", "always sensitive",
            ],
            tone: .negative, priority: 13,
            responses: [
                "不是你性格不好，是以前的经历让你学会了小心翼翼保护自己。敏感不是缺点，是你受过伤之后长出的保护壳。",
                "我特别懂这种怕，怕再一次被否定、被抛弃，所以干脆不敢靠近。慢慢来没关系，你已经很努力在往前走了。",
                "以前的伤害会留下痕迹很正常，不用怪自己不够开朗大方。按照你舒服的节奏来就好，你已经很棒了。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Sensitivity isn't a flaw — it's armor after being hurt. You're protecting yourself.",
                "Being afraid to reach out again makes sense. Go at your pace; you're already moving forward.",
                "Old bullying leaves marks. You don't have to force yourself to be outgoing — you're enough.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),

        /// 命中霸凌关键词但未落到具体子场景时的兜底
        Template(
            id: "bully_generic_hold",
            keywords: [
                "霸凌", "被欺负", "被同学欺负", "校园暴力", "被人欺负",
                "school bully", "bullied", "bullying",
            ],
            tone: .negative, priority: 15,
            responses: [
                "被这样对待一定又委屈又害怕吧。这不是你的错，错的是选择伤害你的人。",
                "听着就替你难受，你不用逼自己「是不是我有问题」。被欺负的人没有错，我在这儿陪着你。",
                "那些难受到现在还在心里堵着吧，你不用一个人扛，想说什么都可以，我好好听着。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "What you're describing sounds frightening and unfair — and it's not your fault.",
                "You don't have to blame yourself. I'm right here with you.",
                "You don't have to carry this alone. Say as much or as little as you want — I'm listening.",
            ],
            followUpsEN: [],
            gentleOnly: true,
            comfortOnly: true
        ),
    ]

    /// 用户主动问「怎么办」时的温和选项（不强迫告老师 / 反抗）
    static func bullyingAdviceReply(
        lang: AppLanguage,
        seed: Int,
        usedKeys: Set<String>,
        story: String = ""
    ) -> ChatReply {
        let extreme = !story.isEmpty && LanguageSignals.containsAny([
            "打了一巴掌", "动手打", "被打", "推搡", "踹", "隐私照", "被拍", "殴打", "受伤", "暴打", "堵在厕所",
        ], in: story)
        let zh = [
            "不用急着做决定。如果哪天你觉得稍微安全一点，可以试着找一位你信任的老师或长辈说说；也可以先保留聊天记录、截图这些证据，以后用得上。你怎么选，我都尊重。",
            "没有标准答案，怎么安全怎么来。有人会选择告诉信得过的家长或老师，有人会先默默留证据、减少单独碰面的机会——都可以，不用逼自己立刻反击。",
            "如果已经涉及到受伤或被威胁曝光隐私，可以先找一位你真正信任的大人商量，或者把伤情、聊天记录先留着——不用今天就想清楚，想到哪一步算哪一步。",
        ]
        let en = [
            "There's no rush. When you feel a bit safer, you might talk to a teacher or adult you trust, or save screenshots and messages — whatever fits your situation. I'll respect your pace.",
            "You're allowed to choose what feels safest. Some people tell a trusted adult; others quietly document things first. You don't have to fight back to be brave.",
            "If you're hurt or threatened with private photos being leaked, consider telling one adult you truly trust and keeping records of injuries or messages — one step at a time is fine.",
        ]
        var pool = lang == .english ? en : zh
        if !extreme {
            pool = Array(pool.prefix(2))
        }
        let used = pool.indices.filter { usedKeys.contains("bully_advice_\($0)") }
        let idx = used.isEmpty ? seed % pool.count : (seed % max(pool.count - used.count, 1))
        let pick = pool.indices.filter { !used.contains($0) }.first ?? idx % pool.count
        return ChatReply(pool[pick], emojis: ["🫂", "💙", "🌿"], replyKey: "bully_advice_\(pick)")
    }
}
