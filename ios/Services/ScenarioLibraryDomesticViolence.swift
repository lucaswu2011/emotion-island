import Foundation

/// 家庭暴力场景 — 亲密关系与原生家庭（高优先级、先共情、重安全）
extension ScenarioLibrary {

    static let domesticViolenceNegative: [Template] = [
        // MARK: - 亲密关系 · 肢体暴力

        Template(
            id: "dv_first_hit_apology",
            keywords: [
                "动手打", "打了我", "一巴掌", "扇我", "第一次动手", "跪着求", "下跪求", "一时冲动再也不会",
                "hit me", "slapped me", "first time he hit", "begging forgiveness",
            ],
            tone: .negative, priority: 13,
            responses: [
                "抱抱你，脸上的疼、心里的慌肯定缠在一起吧。明明是最该护着你的人，却亲手伤害你，这种落差和恐惧，换谁都会乱了分寸。但你一定要记住：不管吵得多凶，动手都是绝对的错，从来都不是你「活该」。",
                "我知道你心里肯定还有舍不得，也愿意相信他这一次是真心后悔。但暴力从来都不是「一时冲动」，是底线的失守。别着急做决定，先保证自己安全，别单独和他待在封闭的地方。",
            ],
            followUps: ["他之前有过类似推搡、摔东西的苗头吗？", "你现在身边有信任的人陪着吗？"],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "I'm so sorry — the sting on your face and the fear in your chest can tangle together. Whoever should protect you hurt you instead. No argument makes hitting okay. It is never your fault.",
                "Wanting to believe him doesn't make you weak. Violence isn't a one-time slip — it's a line crossed. Don't decide under pressure. Stay safe, and avoid being alone with him in a closed space.",
            ],
            followUpsEN: [
                "Has he pushed you or smashed things before?",
                "Is someone you trust with you right now?",
            ],
            gentleOnly: true
        ),
        Template(
            id: "dv_repeated_abuse",
            keywords: [
                "不是第一次", "每次打完都道歉", "又动手", "反复打", "习惯了", "这辈子都这样",
                "not the first time", "keeps hitting", "hits me again", "cycle of abuse",
            ],
            tone: .negative, priority: 13,
            responses: [
                "一次次失望、一次次原谅，到最后连愤怒都磨没了，只剩下麻木和无力对不对？你不是懦弱，是被反复的伤害耗光了勇气。但你心里还在盼着不一样的生活，这就说明你还没放弃自己。",
                "反复道歉又反复动手，本质就是吃定了你会心软。你不用逼自己立刻做什么大决定，先悄悄攒点钱、收好重要证件，慢慢给自己留好退路，好不好？",
            ],
            followUps: ["最严重的一次是什么样的呀？", "你有没有悄悄存过证据？"],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "Hope, forgive, hurt again — until anger goes numb. That isn't weakness; it's exhaustion. Wanting a different life means you haven't given up on yourself.",
                "Sorry, then repeat — that's counting on your softness. You don't have to decide everything today. Quietly save what you can, keep ID documents safe, and build an exit bit by bit.",
            ],
            followUpsEN: [
                "What was the worst time?",
                "Have you been able to keep any records?",
            ],
            gentleOnly: true
        ),
        Template(
            id: "dv_self_blame",
            keywords: [
                "是不是我顶嘴", "我不顶嘴就不会", "是我话说太重", "可能真的是我不对", "是你逼我的",
                "my fault he hit", "if I hadn't talked back", "I provoked him",
            ],
            tone: .negative, priority: 12,
            responses: [
                "千万别这么想，这绝对不是你的错。再激烈的争吵、再难听的话，都不是动手伤害人的理由。解决矛盾有一百种方式，唯独动手是踩破了底线。错的是伤害你的人，不是你。",
                "他是不是事后也总说「是你逼我的」？这都是为自己开脱的借口。把责任推给你，他就能心安理得地原谅自己。别掉进这个陷阱里，你没有任何错。",
            ],
            followUps: ["他每次打完都会说是你的问题吗？", "你以前也会这样怪自己吗？"],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "Please don't carry this — it is not your fault. Harsh words never justify being hit. There are many ways to fight; violence isn't one. The person who hurt you is wrong, not you.",
                "Does he say \"you made me do it\" afterward? That's blame-shifting so he can feel innocent. Don't fall into that trap — you did nothing to deserve this.",
            ],
            followUpsEN: [
                "Does he always say it's your fault after?",
                "Have you blamed yourself like this before?",
            ]
        ),

        // MARK: - 亲密关系 · 精神暴力

        Template(
            id: "dv_pua_degrade",
            keywords: [
                "什么都做不好", "离开他没人要", "一无是处", "贬低我", "PUA", "配不上", "说我很差劲",
                "nobody would want me", "worthless", "puts me down", "gaslighting",
            ],
            tone: .negative, priority: 12,
            responses: [
                "天天被最亲近的人否定，听久了难免会信以为真。但这不是事实，是他故意给你套的枷锁 —— 把你说得越差，你就越不敢离开，他就能牢牢控制住你。你本身一点都不差，差的是他的尊重和人品。",
                "这种看不见的暴力，比挨打还磨人。它一点点吃掉你的自信，让你困在「我不配」的感觉里。可你想想，没认识他之前，你也是个好好的人啊，怎么会突然就一无是处了呢？",
            ],
            followUps: ["他最常贬低你哪方面呀？", "你有没有跟朋友聊过这些事？"],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Hearing you're \"nothing\" from someone close can feel true over time — but it's a cage, not fact. The less worthy you feel, the easier you are to control. You're not the problem; his respect is.",
                "Invisible abuse grinds down confidence. Before him, you were already a whole person — you didn't suddenly become worthless.",
            ],
            followUpsEN: [
                "What does he attack most often?",
                "Have you told anyone you trust?",
            ]
        ),
        Template(
            id: "dv_cold_violence_long",
            keywords: [
                "冷战十几天", "十几天不说话", "长期冷暴力", "不管我怎么说都不理", "消失失联",
                "silent treatment for days", "won't speak for weeks", "ghosting me after fight",
            ],
            tone: .negative, priority: 12,
            responses: [
                "冷暴力也是暴力啊。他用沉默当武器惩罚你，把所有情绪压力都丢给你一个人扛，让你反复自我怀疑、主动低头。这种看不见的折磨，比吵一架还耗人。",
                "你是不是总在反思「是不是我哪里做错了」？其实不是你的问题，是他不愿意面对问题，用逃避和冷处理逼你妥协。你不用为他的懦弱买单。",
            ],
            followUps: ["每次冷战最后都是你先低头吗？", "这种状态持续多久了？"],
            emojis: ["🫂", "💙", "💔"],
            responsesEN: [
                "Silent treatment is violence too — punishment without words, all the weight on you until you doubt yourself and apologize first.",
                "If you're asking \"what did I do wrong,\" that's the trap. He won't face conflict and makes you pay for it. That's on him, not you.",
            ],
            followUpsEN: [
                "Do you usually break the silence first?",
                "How long has this pattern lasted?",
            ]
        ),
        Template(
            id: "dv_economic_control",
            keywords: [
                "不让我上班", "只给一点生活费", "报账", "手里一点钱都没有", "经济控制", "管钱",
                "won't let me work", "controls the money", "financial abuse", "no money of my own",
            ],
            tone: .negative, priority: 12,
            responses: [
                "手里没钱、没收入，就像被捆住了翅膀，想走都走不了，肯定特别无助吧。经济控制也是家暴的一种，他就是想用这种方式把你拴在身边，让你不得不依赖他。",
                "我知道现在很难，但可以悄悄攒一点属于自己的钱，哪怕一点点也好。有了钱，就多了一分选择的底气。",
            ],
            followUps: ["你有多久没自己赚过钱了呀？", "有没有想过找点能在家做的事？"],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "No money, no job — wings clipped. Financial control is abuse; it keeps you trapped and dependent.",
                "Even tiny savings in secret can buy options later. A little independence is a little freedom.",
            ],
            followUpsEN: [
                "How long since you earned your own?",
                "Any way to earn quietly from home?",
            ]
        ),

        // MARK: - 亲密关系 · 抉择与恐惧

        Template(
            id: "dv_fear_leaving",
            keywords: [
                "敢走就", "找我爸妈麻烦", "不敢跑", "怕被报复", "威胁我", "找家人麻烦",
                "if I leave he'll", "threaten my family", "afraid to leave", "retaliation",
            ],
            tone: .negative, priority: 13,
            responses: [
                "被威胁的感觉肯定像被掐住了喉咙，连逃跑的勇气都被攥在别人手里。别硬来，也别一个人扛，可以先悄悄联系信任的家人朋友，或者找妇联、社区求助，总会有办法保护你和家人的。",
                "我懂这种投鼠忌器的害怕，你不是胆小，是心里有牵挂。但越是这样，越不能硬碰硬，先稳住他，悄悄规划好退路，等准备充分了再走，好不好？",
            ],
            followUps: ["身边有没有能帮你的亲戚朋友呀？", "你知道当地的妇联求助电话吗？"],
            emojis: ["🫂", "💙", "🛡️"],
            responsesEN: [
                "Threats can freeze you — that's not cowardice. Don't confront alone; reach trusted family, friends, or local women's support / community services. There are ways to protect you and yours.",
                "You're not weak for being afraid when people you love are used against you. Don't rush a head-on break — plan quietly, then leave when you're safer.",
            ],
            followUpsEN: [
                "Anyone nearby you can trust?",
                "Do you know local crisis or family-violence hotlines?",
            ],
            gentleOnly: true
        ),
        Template(
            id: "dv_stay_for_child",
            keywords: [
                "为了孩子", "要不是为了孩子", "孩子在这种环境", "忍着不走", "怕孩子阴影",
                "staying for the kids", "children see the fighting", "can't leave because of child",
            ],
            tone: .negative, priority: 12,
            responses: [
                "夹在「忍」和「走」中间，肯定每天都在煎熬吧。你已经在尽全力保护孩子了，但其实孩子比我们想的敏感，家里的紧张和伤害，他们都能感受到。有时候，不完整但安全的环境，比完整但充满暴力的家更能养好孩子。",
                "我知道你最怕的就是对不起孩子。可你也是别人的宝贝啊，你也值得不用担惊受怕的生活。你先保护好自己，才能更好地保护孩子。",
            ],
            followUps: ["孩子多大了呀？", "孩子有没有见过他发脾气的样子？"],
            emojis: ["🫂", "💙", "🏠"],
            responsesEN: [
                "Stuck between stay and go — that's daily agony. Kids feel tension even when you shield them. Sometimes safety matters more than keeping the picture \"complete.\"",
                "You're afraid of failing your child — but you matter too. Caring for yourself is part of caring for them.",
            ],
            followUpsEN: [
                "How old is your child?",
                "Have they seen him lose control?",
            ]
        ),

        // MARK: - 原生家庭 · 当下伤害

        Template(
            id: "fv_adult_hit",
            keywords: [
                "爸又动手", "妈又打", "父母动手打", "二十多了还打", "成年后还打", "躲不开",
                "dad hit me again", "parents still hit me", "adult but they beat me",
            ],
            tone: .negative, priority: 13,
            responses: [
                "都已经长这么大了，还要承受这些，肯定又委屈又屈辱吧。不管你多大，父母都没有权利动手伤害你。这不是你没用，是他们没守住做父母的底线。",
                "从小打到大，你肯定早就习惯了害怕，哪怕长大了，那种本能的恐惧还在。这不怪你，你已经在很努力地扛了。如果实在待不下去，就先出去躲一躲，别硬扛。",
            ],
            followUps: ["是因为什么事突然动手的呀？", "你现在有没有在安全的地方？"],
            emojis: ["🫂", "💙", "🏠"],
            responsesEN: [
                "Being hit as an adult is humiliating and unfair — parents don't get a pass to hurt you. This isn't you being weak; it's them crossing a line.",
                "Years of fear leave reflexes behind — that's not your fault. If home isn't safe right now, stepping out is okay.",
            ],
            followUpsEN: [
                "What triggered it this time?",
                "Are you somewhere safe now?",
            ],
            gentleOnly: true
        ),
        Template(
            id: "fv_parent_verbal_abuse",
            keywords: [
                "说我没用", "丢人", "没夸过我", "语言羞辱", "贬损", "从小到大骂",
                "parents say I'm useless", "never praised", "verbal abuse", "humiliate me",
            ],
            tone: .negative, priority: 11,
            responses: [
                "最亲的人说出来的话，伤人最疼。听了十几年的否定，你难免会信以为真。但那不是真相，是他们自己不会好好说话，把情绪和挫败都发泄在了你身上。",
                "不是你不够好，是他们没学会怎么当合格的父母。他们的评价从来都不是标准答案，你是什么样的人，该由你自己说了算。",
            ],
            followUps: ["他们最常说的难听话是什么呀？", "有没有人跟你说过你其实很好？"],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Words from parents cut deepest. Years of \"you're nothing\" aren't truth — it's their failure to speak with care.",
                "You're not what they say. Their voice isn't the final word on who you are.",
            ],
            followUpsEN: [
                "What do they say most often?",
                "Has anyone told you you're good enough?",
            ]
        ),

        // MARK: - 原生家庭 · 遗留创伤

        Template(
            id: "fv_childhood_trauma",
            keywords: [
                "小时候总被", "童年", "一提高声音就发抖", "阴影", "被我妈打", "被爸打",
                "childhood abuse", "flinch when yelled", "trauma from parents", "still scared of loud voices",
            ],
            tone: .negative, priority: 11,
            responses: [
                "童年的伤害不会随着长大自动消失，它会悄悄藏在你的本能反应里。这不是你胆小，是当年那个小小的你，受了太多惊吓，没被好好保护过。你已经长大了，现在的你，可以保护自己了。",
                "那些挨打的记忆，就像埋在心里的小刺，平时看不见，一碰到就疼。不用逼自己「快点走出来」，能看见它、承认它，就已经很勇敢了。",
            ],
            followUps: ["什么时候最容易想起以前的事呀？", "现在和家里的关系怎么样？"],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Childhood harm doesn't vanish at eighteen — flinching isn't cowardice; it's an old wound. Adult-you can offer the protection little-you needed.",
                "Those memories are splinters — hidden until touched. No rush to \"get over it\"; naming the pain is already brave.",
            ],
            followUpsEN: [
                "When does it come back most?",
                "How are things with family now?",
            ]
        ),
        Template(
            id: "fv_afraid_intimacy",
            keywords: [
                "不敢谈恋爱", "怕别人也会打", "不敢靠近", "原生家庭", "怕亲密关系", "不敢进入",
                "afraid to date", "scared of relationships", "family trauma intimacy", "can't trust partner",
            ],
            tone: .negative, priority: 11,
            responses: [
                "见过了糟糕的亲密关系，会害怕太正常了。不是你不会爱人，是你怕再受伤害，这是你的自我保护，不是缺点。",
                "不用逼自己必须去谈恋爱、必须和解。先好好爱自己，等你觉得安全了、准备好了，再慢慢靠近别人也不迟。你值得被好好对待，这一点永远都没错。",
            ],
            followUps: ["有没有遇到过让你觉得有点安心的人呀？", "你心里理想的相处是什么样的？"],
            emojis: ["🫂", "💙", "🌸"],
            responsesEN: [
                "After bad love at home, fearing closeness makes sense — that's protection, not a flaw.",
                "You don't owe anyone instant trust. Heal at your pace. You still deserve kindness.",
            ],
            followUpsEN: [
                "Anyone who ever felt a little safe?",
                "What would healthy feel like to you?",
            ]
        ),
    ]
}
