import Foundation

/// 聊天引导词条 — 降低倾诉门槛，点击即可填入或发送
enum ChatPromptChips {

    struct Chip: Identifiable, Hashable, Sendable {
        let id: String
        let label: String
        let message: String
        let category: Category

        enum Category: Sendable {
            case mood
            case gamingHappy
            case gamingSad
            case gamingNeutral
            case lifeHappy
            case lifeSad
        }
    }

    static func mood(for language: AppLanguage) -> [Chip] {
        switch language {
        case .english:
            return [
                Chip(id: "m_ok", label: "I'm okay", message: "I'm okay today", category: .mood),
                Chip(id: "m_sad", label: "A little sad", message: "I'm a little sad", category: .mood),
                Chip(id: "m_happy", label: "Happy today", message: "I'm happy today", category: .mood),
                Chip(id: "m_angry", label: "A bit angry", message: "I'm a bit angry", category: .mood),
                Chip(id: "m_wronged", label: "Wronged", message: "I feel so wronged", category: .mood),
                Chip(id: "m_tired", label: "So tired", message: "I'm so tired", category: .mood),
                Chip(id: "m_anxious", label: "Anxious", message: "I'm feeling anxious", category: .mood),
            ]
        case .chinese:
            return moodChinese
        }
    }

    static let moodChinese: [Chip] = [
        Chip(id: "m_ok", label: "今天还好", message: "今天还好", category: .mood),
        Chip(id: "m_sad", label: "我有点难过", message: "我有点难过", category: .mood),
        Chip(id: "m_happy", label: "今天很开心", message: "今天很开心", category: .mood),
        Chip(id: "m_angry", label: "有点生气", message: "有点生气", category: .mood),
        Chip(id: "m_wronged", label: "好委屈", message: "好委屈", category: .mood),
        Chip(id: "m_tired", label: "好累啊", message: "好累啊", category: .mood),
        Chip(id: "m_anxious", label: "有点焦虑", message: "有点焦虑", category: .mood),
    ]

    static let gamingHappy: [Chip] = [
        Chip(id: "g_hi", label: "分享今日游戏高光", message: "今天打游戏有个超高光时刻，太爽了！", category: .gamingHappy),
        Chip(id: "g_rank", label: "晒晒我的新段位", message: "终于升段了，想晒晒我的新段位！", category: .gamingHappy),
        Chip(id: "g_gold", label: "我抽到金了", message: "我抽到金了！太激动了！", category: .gamingHappy),
        Chip(id: "g_heart", label: "我出非洲之心了", message: "我出非洲之心了！太激动了！", category: .gamingHappy),
        Chip(id: "g_million", label: "单局百万撤离", message: "单局百万撤离，肥得流油！", category: .gamingHappy),
        Chip(id: "g_val_ace", label: "瓦罗兰特 1v5 ACE", message: "守包 1v5 直接 ACE，太刺激了！", category: .gamingHappy),
        Chip(id: "g_idv_kite", label: "第五人格溜鬼四跑", message: "溜监管溜了五台机，最后四跑太爽了！", category: .gamingHappy),
        Chip(id: "g_party", label: "和同学连麦开黑", message: "周末和好朋友开黑打了一下午，好久没这么放松了", category: .gamingHappy),
        Chip(id: "g_skin", label: "抽到限定皮肤了", message: "单抽出了限定皮肤，全班就我有，太有面了", category: .gamingHappy),
    ]

    static let gamingSad: [Chip] = [
        Chip(id: "g_lose", label: "排位连跪破防了", message: "排位连跪破防了，心态崩了", category: .gamingSad),
        Chip(id: "g_actor", label: "遇到演员气死了", message: "遇到演员气死了，太搞心态", category: .gamingSad),
        Chip(id: "g_pity", label: "抽卡沉船好难受", message: "抽卡沉船好难受，大保底还歪了", category: .gamingSad),
        Chip(id: "g_lost_loot", label: "大金被蹲掉了", message: "大金被蹲掉了，血本无归", category: .gamingSad),
        Chip(id: "g_cheat", label: "遇到外挂了", message: "遇到外挂了，装备全掉了", category: .gamingSad),
        Chip(id: "g_val_lose", label: "瓦罗兰特连跪掉段", message: "瓦罗兰特连跪掉段了，心态崩了", category: .gamingSad),
        Chip(id: "g_idv_throw", label: "第五人格队友秒倒", message: "第五人格队友开局秒倒，根本没法打", category: .gamingSad),
        Chip(id: "g_kid", label: "被队友骂小学生", message: "打游戏没打好，队友一直骂我小学生，气死我了", category: .gamingSad),
        Chip(id: "g_phone_guilt", label: "玩手机耽误作业", message: "本来想玩十分钟手机就写作业，结果一抬头半夜了，作业还没动", category: .gamingSad),
        Chip(id: "g_confiscate", label: "手机被没收了", message: "刚拿起手机玩了两分钟，我妈就进来了，直接把手机抢走，还骂了我半小时", category: .gamingSad),
        Chip(id: "g_account_gone", label: "游戏号被毁了", message: "我爸把我玩了两年的游戏号注销了，里面充的钱、打的段位全没了", category: .gamingSad),
    ]

    static let gamingNeutral: [Chip] = [
        Chip(id: "g_gtired", label: "今天打游戏好累", message: "今天打游戏好累，肝了一整天", category: .gamingNeutral),
        Chip(id: "g_rec", label: "有没有好玩的游戏推荐", message: "有没有好玩的游戏推荐呀？", category: .gamingNeutral),
        Chip(id: "g_chat", label: "想聊聊游戏日常", message: "想聊聊游戏日常", category: .gamingNeutral),
    ]

    static func lifeHappy(for language: AppLanguage) -> [Chip] {
        switch language {
        case .english:
            return [
                Chip(id: "l_reconcile", label: "Made peace with family", message: "I finally talked things through with my dad and cleared years of misunderstanding", category: .lifeHappy),
                Chip(id: "l_ldr", label: "Long-distance reunion", message: "After three months apart, I finally saw my partner today!", category: .lifeHappy),
                Chip(id: "l_checkup", label: "Health scare over", message: "My follow-up results came back normal — what a relief", category: .lifeHappy),
                Chip(id: "l_catch", label: "Caught the train", message: "I sprinted and got on the train right before the doors closed", category: .lifeHappy),
                Chip(id: "l_concert", label: "Got concert tickets", message: "I got tickets to my favorite singer's concert — my hands were shaking!", category: .lifeHappy),
                Chip(id: "l_cook", label: "Nailed a new recipe", message: "I followed a tutorial and my braised pork tasted just like a restaurant!", category: .lifeHappy),
                Chip(id: "l_clean", label: "Deep cleaned my place", message: "Spent the whole day deep cleaning — my home feels so fresh now", category: .lifeHappy),
                Chip(id: "l_offer", label: "Got a job offer", message: "After so many interviews, I finally got an offer!", category: .lifeHappy),
                Chip(id: "l_sleep", label: "Slept really well", message: "I finally slept through the night — feel so refreshed", category: .lifeHappy),
                Chip(id: "l_dorm", label: "Late dorm heart-to-heart", message: "My roommates and I talked until late last night — we feel so much closer now", category: .lifeHappy),
                Chip(id: "l_pe", label: "Passed fitness test", message: "I finally passed the 800m run after two weeks of practice!", category: .lifeHappy),
            ]
        case .chinese:
            return lifeHappyChinese
        }
    }

    static let lifeHappyChinese: [Chip] = [
        Chip(id: "l_reconcile", label: "和家人和解了", message: "今天和我爸把话说开了，这么多年的误会终于解开了", category: .lifeHappy),
        Chip(id: "l_ldr", label: "异地终于见面", message: "和对象异地三个月，今天终于见到了！", category: .lifeHappy),
        Chip(id: "l_checkup", label: "体检虚惊一场", message: "之前体检有指标异常，复查终于正常了，吓死我了", category: .lifeHappy),
        Chip(id: "l_catch", label: "卡点赶上高铁", message: "一路狂奔，高铁关门的前一秒冲上去了", category: .lifeHappy),
        Chip(id: "l_concert", label: "抢到演唱会票了", message: "抢到喜欢了八年的歌手的演唱会门票！手都抖了", category: .lifeHappy),
        Chip(id: "l_cook", label: "做菜大成功", message: "跟着教程做的红烧肉，居然和饭店味道一模一样！", category: .lifeHappy),
        Chip(id: "l_clean", label: "大扫除超解压", message: "花了一整天全屋大扫除，看着干干净净的家，心情都变好了", category: .lifeHappy),
        Chip(id: "l_offer", label: "拿到offer了", message: "投了那么多简历，终于拿到offer了！", category: .lifeHappy),
        Chip(id: "l_sleep", label: "睡了个好觉", message: "终于睡了个好觉，一觉到天亮", category: .lifeHappy),
        Chip(id: "l_dorm", label: "宿舍卧谈超治愈", message: "昨晚和室友卧谈到凌晨，聊了好多心里话，感觉大家一下子亲近了好多", category: .lifeHappy),
        Chip(id: "l_pe", label: "体测终于及格", message: "八百米体测终于及格了！练了半个月没白跑", category: .lifeHappy),
    ]

    static func lifeSad(for language: AppLanguage) -> [Chip] {
        switch language {
        case .english:
            return [
                Chip(id: "l_cold", label: "Cold shoulder", message: "After our fight they stopped replying — silent treatment for days", category: .lifeSad),
                Chip(id: "l_pressure", label: "Wedding pressure", message: "Dinner with family was all marriage pressure, couldn't even eat", category: .lifeSad),
                Chip(id: "l_shop", label: "Bad online buy", message: "What I ordered looks nothing like the photos, quality is awful", category: .lifeSad),
                Chip(id: "l_pet_lost", label: "Pet ran away", message: "The cat got out and I searched all night but couldn't find them", category: .lifeSad),
                Chip(id: "l_missed", label: "Missed train/flight", message: "I was two minutes late and the train left — ticket gone", category: .lifeSad),
                Chip(id: "l_apathy", label: "Nothing feels worth it", message: "Nothing seems interesting anymore, I can't get motivated", category: .lifeSad),
                Chip(id: "l_fired", label: "Got fired", message: "Goddamn, I got fired by my boss", category: .lifeSad),
                Chip(id: "l_blue", label: "Lost unsaved work", message: "My computer blue-screened and I lost a whole afternoon of work", category: .lifeSad),
                Chip(id: "l_rent", label: "Rent hike / forced move", message: "My landlord suddenly raised rent — I have to move next month", category: .lifeSad),
                Chip(id: "l_show", label: "Show cancelled / sold out", message: "The concert I waited months for got cancelled — I'm crushed", category: .lifeSad),
                Chip(id: "l_overtime", label: "Overtime burnout", message: "I've been working overtime every day — I'm completely drained", category: .lifeSad),
                Chip(id: "l_ghost", label: "Got ghosted", message: "We were chatting fine and then they just stopped replying", category: .lifeSad),
                Chip(id: "l_insomnia", label: "Can't sleep", message: "I've been lying awake until 3am — can't sleep at all", category: .lifeSad),
                Chip(id: "l_dv_hit", label: "Partner hit me", message: "He hit me during a fight yesterday and is begging forgiveness today — I'm so confused", category: .lifeSad),
                Chip(id: "l_dv_pua", label: "Constantly put down", message: "He says I'm useless and nobody else would want me — I'm starting to believe it", category: .lifeSad),
                Chip(id: "l_fv_parent", label: "Parents hit me again", message: "My dad hit me again — I'm an adult and I still can't get away", category: .lifeSad),
                Chip(id: "l_dorm_noise", label: "Roommate keeps me up", message: "My roommate games with mic on until 2am — I can't sleep at all", category: .lifeSad),
                Chip(id: "l_group", label: "Solo group project", message: "I'm doing the whole group project alone while everyone else slacks off", category: .lifeSad),
            ]
        case .chinese:
            return lifeSadChinese
        }
    }

    static let lifeSadChinese: [Chip] = [
        Chip(id: "l_cold", label: "被冷暴力了", message: "吵架之后他就不回消息了，冷暴力我好几天", category: .lifeSad),
        Chip(id: "l_pressure", label: "回家被催婚", message: "回家吃顿饭全程被催婚，饭都没吃好", category: .lifeSad),
        Chip(id: "l_shop", label: "网购踩雷了", message: "网上买的衣服和图片完全不一样，质量差到离谱", category: .lifeSad),
        Chip(id: "l_pet_lost", label: "宠物跑丢了", message: "门没关好，猫跑出去了，找了一晚上都没找到", category: .lifeSad),
        Chip(id: "l_missed", label: "误了高铁/飞机", message: "还是晚了两分钟，高铁开走了，票也退不了", category: .lifeSad),
        Chip(id: "l_apathy", label: "对什么都提不起劲", message: "好像什么都没意思，对什么都提不起劲", category: .lifeSad),
        Chip(id: "l_fired", label: "被老板炒了", message: "烦死了，被老板炒鱿鱼了", category: .lifeSad),
        Chip(id: "l_blue", label: "电脑蓝屏白干了", message: "做了一下午的方案，电脑突然蓝屏，没保存全没了，心态崩了", category: .lifeSad),
        Chip(id: "l_rent", label: "房东涨租要搬家", message: "房东突然说下个月涨五百房租，接受不了只能搬家", category: .lifeSad),
        Chip(id: "l_show", label: "演出取消/没抢到", message: "期待了好久的演唱会，临时宣布取消了，太难过了", category: .lifeSad),
        Chip(id: "l_overtime", label: "连续加班快崩了", message: "最近连续加班，整个人快撑不住了", category: .lifeSad),
        Chip(id: "l_ghost", label: "被ghost了", message: "聊得好好的，对方突然就不回消息了", category: .lifeSad),
        Chip(id: "l_insomnia", label: "失眠好难受", message: "最近一直失眠，翻来覆去睡不着", category: .lifeSad),
        Chip(id: "l_dv_hit", label: "他动手打了我", message: "昨天吵架他动手打了我一巴掌，今天跪着求我原谅，我心里好乱", category: .lifeSad),
        Chip(id: "l_dv_pua", label: "总被贬低打压", message: "他总说我什么都做不好，离开他没人会要我，慢慢我也觉得自己真的很差劲", category: .lifeSad),
        Chip(id: "l_fv_parent", label: "父母又动手了", message: "刚才我爸又动手打我了，我都二十多了，还是躲不开", category: .lifeSad),
        Chip(id: "l_dorm_noise", label: "室友熬夜太吵", message: "室友天天熬夜打游戏开麦，吵到一两点，我根本睡不着", category: .lifeSad),
        Chip(id: "l_group", label: "小组全是我干活", message: "小组作业又是我一个人扛，队友全程划水，气死我了", category: .lifeSad),
    ]

    static let exhaustionTiredChinese: [Chip] = [
        Chip(id: "e_move", label: "搬家累散架", message: "搬了一天家，浑身都散架了，连抬手喝水的力气都没有", category: .lifeSad),
        Chip(id: "e_clean", label: "大扫除累断腰", message: "打扫了一整天卫生，擦窗户拖地板，现在腰都快断了", category: .lifeSad),
        Chip(id: "e_walk", label: "暴走一万五千步", message: "景区暴走了一万五千步，现在腿软得像踩棉花", category: .lifeSad),
        Chip(id: "e_errand", label: "跑腿事没办成", message: "跑了三个部门办证明，来回折腾了一整天，事还没办成，又累又气", category: .lifeSad),
        Chip(id: "e_hospital", label: "陪诊跑一天", message: "陪我妈去医院，排队、挂号、做检查，跑上跑下折腾了一整天，累到不想说话", category: .lifeSad),
        Chip(id: "e_meeting", label: "开会开一天", message: "从早开到晚的会，全程要集中注意力，下班脑子一片空白，话都不想说", category: .lifeSad),
        Chip(id: "e_social", label: "应酬社交耗神", message: "今天参加了个全是陌生人的局，全程陪着笑找话题，累到回家直接葛优瘫", category: .lifeSad),
        Chip(id: "e_commute", label: "通勤四小时", message: "每天通勤来回四个小时，早出晚归，到家什么都不想干，太累了", category: .lifeSad),
        Chip(id: "e_child", label: "带娃一天", message: "帮我姐带了一天孩子，追着跑了一整天，嗓子都喊哑了，累到快散架", category: .lifeSad),
        Chip(id: "e_trip", label: "长途十二小时", message: "坐了十二个小时火车回家，浑身僵硬，累到话都不想说", category: .lifeSad),
    ]

    static func exhaustionTired(for language: AppLanguage) -> [Chip] {
        language == .english ? [] : exhaustionTiredChinese
    }

    static let okayMoodChinese: [Chip] = [
        Chip(id: "o_daily", label: "普普通通一天", message: "今天就普普通通的，没什么特别的事发生", category: .mood),
        Chip(id: "o_result", label: "成绩马马虎虎", message: "考试成绩出来了，还行吧，不好也不差", category: .mood),
        Chip(id: "o_idle", label: "闲晃一天", message: "今天没什么安排，闲了一天，就还行吧", category: .mood),
        Chip(id: "o_flat", label: "心情平平的", message: "心情就那样吧，不好不坏，没什么大起伏", category: .mood),
        Chip(id: "o_casual", label: "就那样呗", message: "害，就那样呗，还能怎么样", category: .mood),
        Chip(id: "o_bump", label: "小插曲还行", message: "今天出了点小岔子，但最后都解决了，整体还行吧", category: .mood),
    ]

    static func okayMood(for language: AppLanguage) -> [Chip] {
        language == .english ? [] : okayMoodChinese
    }

    /// 心情选择页：情绪 + 游戏词条
    static var moodSelection: [Chip] {
        moodChinese + gamingHappy + gamingSad + gamingNeutral
    }

    /// 聊天页：根据当前对话倾向推荐词条
    static func chatSuggestions(for session: ConversationSession) -> [Chip] {
        let lastUser = session.messages.last(where: { $0.role == .user })?.text ?? ""
        let tone = ContextualResponder.detectToneStatic(in: lastUser)
        let lang = session.userLanguage
        let moodChips = mood(for: lang)

        var pool: [Chip]
        switch tone {
        case .positive:
            pool = lifeHappy(for: lang) + gamingHappy + gamingNeutral + moodChips.filter { $0.id == "m_happy" }
        case .negative:
            pool = lifeSad(for: lang) + gamingSad + moodChips.filter { ["m_sad", "m_angry", "m_wronged", "m_tired"].contains($0.id) }
        case .neutral:
            pool = gamingNeutral + Array(lifeHappy(for: lang).prefix(1)) + Array(lifeSad(for: lang).prefix(1)) + Array(gamingHappy.prefix(1)) + moodChips
        }

        let topic = TopicDetector.detect(in: lastUser)
        if LanguageSignals.expressesExhaustion(lastUser) || LanguageSignals.hasExhaustionCause(lastUser) {
            pool = exhaustionTired(for: lang) + pool
        }
        if OkayMoodSignals.isOkayMood(lastUser, language: lang) {
            pool = okayMood(for: lang) + pool
        }
        if session.discussedTopics.contains(.gaming) || topic == .gaming {
            pool = gamingHappy + gamingSad + gamingNeutral + pool
        }
        let lifeTopics: Set<ConversationTopic> = [.family, .pet, .travel, .consumption, .health]
        if session.discussedTopics.contains(where: lifeTopics.contains) || lifeTopics.contains(topic) {
            pool = lifeHappy(for: lang) + lifeSad(for: lang) + pool
        }

        var seen = Set<String>()
        return pool.filter { seen.insert($0.id).inserted }.prefix(10).map { $0 }
    }
}
