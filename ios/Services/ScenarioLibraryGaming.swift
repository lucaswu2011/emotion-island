import Foundation

/// 游戏场景话术库
extension ScenarioLibrary {

    static let gamingPositive: [Template] = [
        // MOBA
        Template(
            id: "game_rank_up",
            keywords: ["打上王者", "上王者", "渡劫局", "上星耀", "升大段", "冲段", "从钻石", "三连胜", "上战神"],
            tone: .positive, priority: 10,
            responses: [
                "太不容易了！渡劫局的心跳感我懂，每一波团战都捏着汗打，这下终于可以松口气了，你完全配得上这个段位。",
                "恭喜渡劫成功！那些连跪的夜晚、掉星的憋屈，在晋级成功的瞬间全都值了，这波必须给自己记大功。",
            ],
            followUps: ["渡劫局有没有遇到特别坑的队友？", "上王者之后第一件事想干嘛？"],
            emojis: ["🏆", "🎮", "✨"]
        ),
        Template(
            id: "game_penta_kill",
            keywords: ["五杀", "超神", "杀了二十", "扣6", "带飞", "carry", "带队友躺赢"],
            tone: .positive, priority: 10,
            responses: [
                "也太帅了吧！五杀的瞬间是不是手都在抖？全场焦点就是你，这波操作能吹一个星期。",
                "天呐这就是 carry 的感觉吗？队友全程跟着你躺赢，输出拉满的爽感简直无可替代。",
            ],
            followUps: ["用的哪个英雄拿的五杀呀？", "最后一个人头是不是极限收割？"],
            emojis: ["🔥", "🎮", "⚡"]
        ),
        Template(
            id: "game_win_streak",
            keywords: ["八连胜", "连胜上分", "连赢五把", "手气太顺", "巅峰赛连赢", "涨了两百分", "排位八连胜"],
            tone: .positive, priority: 9,
            responses: [
                "这是什么神仙手感！一路连胜上分的感觉也太爽了，系统都拦不住你往上冲。",
                "连胜 buff 加持的你简直无敌，是不是打每一局都特别顺，思路清晰操作丝滑。",
            ],
            followUps: ["连胜秘诀是什么呀？", "有没有哪一局赢得最惊险？"],
            emojis: ["🎮", "✨", "🔥"]
        ),
        Template(
            id: "game_mvp_perfect",
            keywords: ["16.0", "满评", "金牌 MVP", "金牌MVP", "把把金牌", "系统都给我点赞"],
            tone: .positive, priority: 9,
            responses: [
                "满评也太离谱了吧！操作、意识、参团率全拉满，你就是峡谷里的六边形战士。",
                "把把金牌 MVP，这实力简直降维打击，队友排到你简直是上辈子修来的福气。",
            ],
            followUps: ["你觉得自己哪波操作最亮眼？", "平时都是怎么练技术的？"],
            emojis: ["⭐", "🎮", "🏆"]
        ),

        // 战术射击
        Template(
            id: "game_chicken",
            keywords: ["吃鸡", "决赛圈", "反杀吃鸡", "满编吃鸡", "最后一滴血"],
            tone: .positive, priority: 10,
            responses: [
                "决赛圈的紧张感直接拉满，最后反杀的瞬间是不是心脏都要跳出来了？这局鸡吃得含金量拉满。",
                "满编吃鸡也太爽了！队友配合默契、战术到位，从头到尾都是稳稳的掌控感。",
            ],
            followUps: ["决赛圈最后是怎么打赢的呀？", "有没有遇到特别惊险的瞬间？"],
            emojis: ["🐔", "🎮", "🔥"]
        ),
        Template(
            id: "game_ace_rank",
            keywords: ["上王牌", "无敌战神", "超级王牌", "进无敌战神", "一个赛季"],
            tone: .positive, priority: 10,
            responses: [
                "战神门槛有多高大家都知道，每天全服只刷新前 500 名，能挤进去的都是真大佬，你也太厉害了。",
                "恭喜解锁最高荣誉！那些熬夜掉分、落地成盒的日子都没白熬，这就是对你技术最好的证明。",
            ],
            followUps: ["上战神路上最煎熬的是哪段？", "你 KD 维持在多少呀？"],
            emojis: ["🏆", "🎮", "✨"]
        ),
        Template(
            id: "game_delta_loot",
            keywords: ["摸到大红", "百万撤离", "跑刀", "满载而归", "肥得流油", "赚了三百万", "三角洲", "哈夫币"],
            tone: .positive, priority: 9,
            responses: [
                "这波血赚啊！开出大红的瞬间是不是激动得叫出声？一趟顶别人跑十趟，欧气爆棚。",
                "跑刀都能满载而归，你这搜物资的眼光和撤离的意识也太绝了，妥妥的致富小能手。",
            ],
            followUps: ["大红是在哪个点位摸出来的？", "打算用这些哈夫币干嘛？"],
            emojis: ["💰", "🎮", "✨"]
        ),
        Template(
            id: "game_clutch",
            keywords: ["1v4", "灭队", "残局", "队友全倒了", "狙杀四个", "拿下赛点"],
            tone: .positive, priority: 10,
            responses: [
                "1v4 灭队也太帅了吧！队友都观战看傻了，这波操作绝对能上精彩集锦。",
                "残局最考验心态和枪法，你居然能稳得住还反杀全队，这心理素质和技术都是顶尖的。",
            ],
            followUps: ["当时紧张到手抖了吗？", "你最擅长用什么枪打残局？"],
            emojis: ["🔥", "🎮", "⚡"]
        ),

        // 休闲竞技
        Template(
            id: "game_eggy_rank",
            keywords: ["凤凰蛋", "恐龙蛋", "蛋仔", "渡劫成功", "鹅蛋冲", "巅峰赛连胜"],
            tone: .positive, priority: 9,
            responses: [
                "恭喜渡劫成功！巅峰赛冲分的内卷程度谁懂啊，能打上凤凰绝对是实力与运气并存。",
                "一路往上冲的感觉也太爽了，那些被撞下去、被道具砸的憋屈，在升段的瞬间全都烟消云散。",
            ],
            followUps: ["你最擅长什么类型的地图呀？", "渡劫局有没有遇到特别离谱的对手？"],
            emojis: ["🥚", "🎮", "✨"]
        ),
        Template(
            id: "game_tft_win",
            keywords: ["满血吃鸡", "金铲铲", "三星五费", "完美羁绊", "阵容成型", "锁血吃鸡"],
            tone: .positive, priority: 9,
            responses: [
                "满血吃鸡也太胡了吧！运营和运气全都拉满，这局简直是你的天胡局。",
                "三星五费的快乐谁懂啊！看着自己的阵容越战越勇，最后稳稳吃鸡，成就感直接拉满。",
            ],
            followUps: ["这把玩的是什么阵容呀？", "三星五费是第多少阶段 D 出来的？"],
            emojis: ["♟️", "🎮", "🏆"]
        ),
        Template(
            id: "game_map_clear",
            keywords: ["通关了", "全服前一百", "竞速图", "乐园地图", "练了一下午", "难图"],
            tone: .positive, priority: 8,
            responses: [
                "反复摔、反复试，最后通关的瞬间成就感直接爆棚，你的耐心和技术都超棒。",
                "全服前一百也太厉害了吧！每一个跳跃、每一次加速都卡得刚刚好，这就是实力的证明。",
            ],
            followUps: ["这张图最难的地方是哪一段？", "练了多少次才通关的？"],
            emojis: ["🎮", "✨", "🏆"]
        ),

        // 抽卡养成
        Template(
            id: "game_gacha_win",
            keywords: ["单抽出", "双黄", "十连双黄", "出金", "限定金", "原地起飞", "抽到金"],
            tone: .positive, priority: 10,
            responses: [
                "这是什么欧皇附体！单抽出金的概率有多低啊，你这运气简直离谱，快去买彩票吧。",
                "双黄蛋也太爽了吧！本来还担心要吃大保底，结果直接毕业，今天绝对是你的幸运日。",
            ],
            followUps: ["攒了多少抽才出的呀？", "抽到的是不是你最想要的角色？"],
            emojis: ["✨", "🎮", "🌟"]
        ),
        Template(
            id: "game_artifact_perfect",
            keywords: ["双爆", "满分圣遗物", "毕业词条", "强化一次没歪", "圣遗物毕业", "完美毕业"],
            tone: .positive, priority: 9,
            responses: [
                "完美毕业圣遗物有多难刷大家都懂，强化还全程不歪，这欧气简直羡煞旁人。",
                "恭喜彻底毕业！以后再也不用蹲副本坐牢了，伤害直接飙升一个档次。",
            ],
            followUps: ["强化的时候有没有屏住呼吸？", "毕业之后伤害涨了多少？"],
            emojis: ["💎", "🎮", "✨"]
        ),
        Template(
            id: "game_max_constellation",
            keywords: ["满命", "本命角色", "武器强化上", "高强成功", "抽满命"],
            tone: .positive, priority: 9,
            responses: [
                "满命的快乐是真的！本命角色完全体，接下来可以尽情享受乱杀的快感了。",
                "高强成功的瞬间太刺激了！前面失败了那么多次，这次终于成了，悬着的心总算落地。",
            ],
            followUps: ["为了满命花了多少资源呀？", "接下来打算去打什么副本爽一下？"],
            emojis: ["🌟", "🎮", "✨"]
        ),

        // 词条快捷触发 · 开心向
        Template(
            id: "game_highlight_share",
            keywords: ["游戏高光", "今日高光", "分享今日游戏", "打游戏太爽了", "超高光"],
            tone: .positive, priority: 8,
            responses: [
                "高光时刻必须好好庆祝！快说说，今天哪一局最让你上头？",
                "听着就带劲！这种打得顺、手感爆棚的局，值得专门记一笔。",
            ],
            followUps: ["是排位还是休闲模式呀？", "用的什么英雄 / 角色？"],
            emojis: ["🎮", "✨", "🔥"]
        ),
        Template(
            id: "game_show_rank",
            keywords: ["晒晒段位", "新段位", "我的段位", "看看我的段位"],
            tone: .positive, priority: 8,
            responses: [
                "新段位到手的感觉太爽了吧！快说说你现在是多少段 / 多少星？",
                "段位涨上去那一刻最有成就感了，你这次冲了多久才上去的？",
            ],
            followUps: ["上这个段位最难的是哪一把？", "接下来还想冲更高吗？"],
            emojis: ["🏆", "🎮", "✨"]
        ),
        Template(
            id: "game_rank_grind_time",
            keywords: [
                "冲了一天", "冲了两天", "冲了三天", "冲了四天", "冲了五天", "冲了一周", "冲了两周",
                "冲了两", "冲了三", "冲了四", "打了一天", "打了两天", "打了三天", "练了两天", "练了三天",
                "熬了两天", "熬了三天", "肝了两天", "花了两天", "整整两天", "整整一天", "一个周末",
                "整个周末", "一下午", "一整晚", "一宿", "差不多两天", "大概两天",
            ],
            tone: .positive, priority: 12,
            responses: [
                "两天！这也太不容易了，每一颗星都是一点点熬出来的，这份坚持真的值得被看见。",
                "连冲两天，精力和心态都得扛住不少压力吧？能升上去说明你该得的，真的超棒！",
                "哇，两天高强度冲分啊——这背后得打多少把、扛多少波，听着就替你骄傲。",
            ],
            followUps: ["冲分过程中有没有特别险的一把？", "升到新段位之后，最想先做的一件事是什么？"],
            emojis: ["🏆", "💪", "✨"],
            responsesEN: [
                "Two whole days! That's real grind — every rank point was earned. You absolutely deserve this.",
                "Two days of pushing rank takes stamina and nerves. Making it up there? That's all you.",
                "Two days of hard climbing — I can hear how much you put in. So proud of you for this.",
            ],
            followUpsEN: [
                "Was there one match that almost slipped away?",
                "What's the first thing you want to do now that you've ranked up?",
            ]
        ),
    ]

    static let gamingNegative: [Template] = [
        // 排位机制
        Template(
            id: "game_loss_streak",
            keywords: ["连跪", "掉段", "掉星", "从王者掉", "一个大段", "越打越气", "心态崩了"],
            tone: .negative, priority: 10,
            responses: [
                "连跪最搞心态了，明明自己没坑，却被带着一路掉星，越打越憋屈，换谁都得破防。",
                "抱抱你，连跪的时候真的像被系统针对了一样，怎么打都赢不了。别硬撑了，先退游戏缓一缓吧。",
            ],
            followUps: ["连跪是因为队友坑还是自己状态不好呀？", "有没有哪一局输得最可惜？"],
            emojis: ["🫂", "🎮", "💙"]
        ),
        Template(
            id: "game_promo_fail",
            keywords: ["晋级赛", "渡劫局失败", "第三次失败", "差一颗星", "遇到演员", "渡劫局连续"],
            tone: .negative, priority: 10,
            responses: [
                "差一步就能上去，结果反复卡在晋级赛，这种临门一脚踢不进去的感觉最折磨人了。",
                "也太倒霉了吧，渡劫局本来就紧张，还遇上坑队友，努力半天全白费，换谁都得气到摔手机。",
            ],
            followUps: ["每次都是因为什么原因输的呀？", "你现在还想接着打吗？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_black_room",
            keywords: ["黑屋", "进黑屋", "六套大哥", "进去就被秒", "排半天进不去"],
            tone: .negative, priority: 9,
            responses: [
                "黑屋局真的像坐牢一样，要么全是大佬要么爆率奇低，明明没开挂却被针对，太憋屈了。",
                "系统也太不讲理了，打得好就要被扔进黑屋挨揍，辛辛苦苦攒的装备一把全亏没，换谁都心疼。",
            ],
            followUps: ["你觉得是因为什么进的黑屋呀？", "亏了多少装备 / 分？"],
            emojis: ["🫂", "🎮", "💙"]
        ),
        Template(
            id: "game_elo_stuck",
            keywords: ["一颗星没涨", "赢一把输一把", "原地踏步", "纯纯坐牢", "不想让我上分", "一下午"],
            tone: .negative, priority: 9,
            responses: [
                "原地踏步最消磨人了，打了半天等于白玩，时间精力全搭进去，一点成就感都没有。",
                "我懂这种无力感，明明每局都认真打，系统却非要给你匹配猪队友拉平衡，根本没法靠自己上分。",
            ],
            followUps: ["一下午打了多少局呀？", "有没有试过换个模式换换运气？"],
            emojis: ["🫂", "🎮", "😔"]
        ),

        // 队友 / 对手
        Template(
            id: "game_afk_actor",
            keywords: ["挂机", "送人头", "演员", "四打五", "摆烂", "举报还不成功", "开局三分钟"],
            tone: .negative, priority: 10,
            responses: [
                "遇到演员和挂机的真的能气到血压飙升，自己认认真真打，别人随便摆烂，努力全白费。",
                "太气人了！凭什么别人摆烂要让你掉星买单，这种人就该直接封号，太影响游戏体验了。",
            ],
            followUps: ["最后举报成功了吗？", "这局你是不是输出拉满了？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_toxic_team",
            keywords: ["秒选", "不给就送", "互骂", "抢位置", "乱玩", "没法好好打"],
            tone: .negative, priority: 9,
            responses: [
                "本来好好的游戏，被不讲理的队友搞得一团糟，开局就没了好心情，玩着都累。",
                "遇到这种自私的队友真的倒霉，只顾自己爽，完全不管团队输赢，根本不配赢。",
            ],
            followUps: ["你有没有跟他们吵起来呀？", "最后这局赢了还是输了？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_cheat_smurf",
            keywords: ["炸鱼", "开外挂", "开挂", "锁头", "穿墙", "毫无游戏体验", "被虐得"],
            tone: .negative, priority: 9,
            responses: [
                "炸鱼的真的很破坏环境，本来是休闲娱乐，结果被追着锤，全程被压着打，一点游戏乐趣都没有。",
                "开挂的太恶心了，好好的竞技游戏被搞得乌烟瘴气，凭实力打不过就开科技，赢了也不光彩。",
            ],
            followUps: ["你是怎么看出来是挂 / 炸鱼的呀？", "官方有没有处理？"],
            emojis: ["😤", "🫂", "🎮"]
        ),

        // 抽卡养成糟心
        Template(
            id: "game_gacha_fail",
            keywords: ["大保底歪", "保底歪", "原石全没", "攒了半年", "歪了常驻", "沉船", "抽卡沉船"],
            tone: .negative, priority: 10,
            responses: [
                "大保底歪了最难受了，攒了那么久的资源，满怀期待结果落空，换谁都得缓好久。",
                "太心疼了，辛辛苦苦攒的抽数全打水漂，想要的角色没拿到，还得再等下一个卡池，太煎熬了。",
            ],
            followUps: ["歪到哪个角色了呀？", "接下来还打算接着抽吗？"],
            emojis: ["🫂", "💙", "😔"]
        ),
        Template(
            id: "game_enhance_fail",
            keywords: ["强化全歪", "连碎", "胚子强化", "白高兴", "几百万金币", "双爆胚子"],
            tone: .negative, priority: 9,
            responses: [
                "满怀期待点强化，结果一次比一次歪，那种从天堂跌到地狱的落差感，真的能气到卸载游戏。",
                "连碎也太离谱了吧，辛辛苦苦攒的资源说没就没，这概率简直是在针对人。",
            ],
            followUps: ["这个胚子你刷了多久才出的呀？", "现在还有资源接着强化吗？"],
            emojis: ["😔", "🫂", "🎮"]
        ),
        Template(
            id: "game_farm_grind",
            keywords: ["刷了一个月", "副本坐牢", "不出货", "打团本", "永远不掉", "免费打工", "圣遗物都没出"],
            tone: .negative, priority: 9,
            responses: [
                "副本坐牢最磨人了，日复一日刷同样的图，却永远不出货，付出和回报完全不成正比。",
                "太煎熬了，每天花那么多时间打本，结果全是没用的垃圾，感觉自己像个免费打工的。",
            ],
            followUps: ["你刷的是哪个副本呀？", "有没有考虑过先摆烂一阵子？"],
            emojis: ["🫂", "💙", "😔"]
        ),

        // 对局体验
        Template(
            id: "game_instant_death",
            keywords: ["落地成盒", "开局秒", "白排十分钟", "老六", "装备全掉", "连枪都没捡"],
            tone: .negative, priority: 9,
            responses: [
                "排队十分钟，游戏十秒钟，刚开局就结束，这体验也太差了，白瞎了期待半天的心情。",
                "被老六阴最气了，辛辛苦苦带的装备全掉了，连反应的机会都没有，亏到姥姥家。",
            ],
            followUps: ["是跳的人太多了还是遇到老六了？", "掉的装备心疼不心疼？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_lag",
            keywords: ["460", "卡顿", "掉帧", "卡成", "网络", "关键团", "PPT"],
            tone: .negative, priority: 9,
            responses: [
                "关键时刻掉链子最搞心态了，明明能赢的局，输在网络上，比输在技术上还憋屈。",
                "也太倒霉了吧，操作都准备好了，结果卡成 PPT，有力使不出的感觉真的太难受了。",
            ],
            followUps: ["是 wifi 还是流量呀？", "这种情况经常出现吗？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_sniped",
            keywords: ["偷背身", "被狙秒", "背后偷", "一枪被秒", "没反应过来", "人在哪都没看到"],
            tone: .negative, priority: 8,
            responses: [
                "死得不明不白最气了，都没搞清楚状况就没了，憋屈得不行。",
                "被远处的狙秒掉真的很无力，连还手的机会都没有，好好的一局游戏直接提前结束。",
            ],
            followUps: ["当时你在搜哪个点位呀？", "有没有看清对方在哪？"],
            emojis: ["😤", "🫂", "🎮"]
        ),

        // 账号规则
        Template(
            id: "game_false_ban",
            keywords: ["误举报", "信誉分", "禁赛", "被举报还成功", "莫名其妙被禁"],
            tone: .negative, priority: 9,
            responses: [
                "被误判真的太冤了，认认真真打游戏，结果平白无故被扣信誉分，连说理的地方都没有。",
                "也太离谱了吧，什么都没做就被禁赛，好好的游戏心情全被毁了。",
            ],
            followUps: ["你找客服申诉了吗？", "被扣了多少信誉分呀？"],
            emojis: ["🫂", "😤", "🎮"]
        ),
        Template(
            id: "game_account_stolen",
            keywords: ["号被盗", "账号被盗", "道具全被", "皮肤不见了", "被用光了"],
            tone: .negative, priority: 10,
            responses: [
                "太心疼了，辛辛苦苦攒的东西、花了钱的皮肤，说没就没了，换谁都得急坏。",
                "账号安全真的太重要了，自己一点点养起来的号，被盗号的霍霍了，真的又气又难受。",
            ],
            followUps: ["有没有找客服找回呀？", "损失最严重的是什么东西？"],
            emojis: ["🫂", "💙", "😔"]
        ),

        // 词条快捷触发 · 糟心向
        Template(
            id: "game_rank_rage",
            keywords: ["排位连跪破防", "连跪破防", "排位破防"],
            tone: .negative, priority: 10,
            responses: [
                "连跪破防真的太正常了，系统一搞心态谁顶得住。先别硬打，歇一歇再说。",
                "抱抱你，排位连跪那种越打越气的感觉我懂，退出来缓一缓，别跟星星较劲。",
            ],
            followUps: ["连跪了几把呀？", "有没有哪一把特别搞心态？"],
            emojis: ["🫂", "🎮", "💙"]
        ),
        Template(
            id: "game_actor_rage",
            keywords: ["遇到演员气死", "演员气死了", "被演员"],
            tone: .negative, priority: 10,
            responses: [
                "遇到演员真的能把人气炸，明明认真打，别人却故意送，太搞心态了。",
                "太气人了！演员这种玩家最破坏体验，你这次是被坑掉分了吗？",
            ],
            followUps: ["是排位还是巅峰赛遇到的？", "举报了吗？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
    ]

    static let gamingNeutral: [Template] = [
        Template(
            id: "game_tired",
            keywords: ["打游戏好累", "游戏打累了", "打了一整天游戏", "肝了一整天", "游戏肝"],
            tone: .neutral, priority: 6,
            responses: [
                "打游戏也是个体力活，肝久了确实会累。歇一歇，眼睛和手都需要放松。",
            ],
            followUps: ["今天打了多久呀？", "是排位还是刷本累着的？"],
            emojis: ["🎮", "💤", "🌿"]
        ),
        Template(
            id: "game_recommend",
            keywords: ["游戏推荐", "好玩的游戏", "有什么游戏", "推荐游戏", "玩什么游戏"],
            tone: .neutral, priority: 6,
            responses: [
                "想换换口味了呀！你平时更喜欢竞技类、休闲类，还是剧情向的？",
            ],
            followUps: ["最近常玩的是哪款？", "是一个人玩还是跟朋友一起？"],
            emojis: ["🎮", "👂", "✨"]
        ),
        Template(
            id: "game_daily",
            keywords: ["游戏日常", "聊聊游戏", "想聊聊游戏", "游戏生活"],
            tone: .neutral, priority: 6,
            responses: [
                "好呀，游戏日常也能聊很多呢。今天上线都干了些什么？",
            ],
            followUps: ["最近主要在玩哪款？", "有没有发生什么有趣的事？"],
            emojis: ["🎮", "👂", "🌿"]
        ),
    ]
}
