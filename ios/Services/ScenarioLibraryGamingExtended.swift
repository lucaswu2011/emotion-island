import Foundation

/// 游戏场景话术库 · 黑话 & 细分补充
extension ScenarioLibrary {

    static let gamingPositiveExtended: [Template] = [
        // 撤离类 · 顶级出货
        Template(
            id: "game_african_heart",
            keywords: ["非洲之心", "出非洲之心", "出了非洲之心", "摸到非洲之心", "非洲心"],
            tone: .positive, priority: 12,
            responses: [
                "我去！这可是三角洲天花板级别的大金啊！一趟直接少跑半个月图，摸出来的时候手都激动抖了吧。",
                "这波直接财富自由啊！非洲之心的含金量懂的都懂，全图没几个的顶级收藏品，你这运气也太离谱了。",
            ],
            followUps: ["是在哪个点位摸出来的呀？", "打算直接卖了换币还是留着收藏？"],
            emojis: ["💎", "🎮", "✨"]
        ),
        Template(
            id: "game_multi_red_loot",
            keywords: ["三个大金", "两个大红", "肥到流油", "带出三个", "多件大红", "大金两个"],
            tone: .positive, priority: 11,
            responses: [
                "这是把整张图的好东西都搜空了吧！满背包贵重品安全撤离，一趟顶别人跑十趟，直接实现哈夫币自由。",
                "也太会搜了吧，大红大金揣满兜，撤离的时候是不是都怕被人盯上，一路蹲蹲藏藏小心翼翼的。",
            ],
            followUps: ["单局最值钱的是哪个货呀？", "这把算下来赚了多少币？"],
            emojis: ["💰", "🎮", "🔥"]
        ),
        Template(
            id: "game_secret_file",
            keywords: ["机密文件", "空手跑刀", "零成本", "空手套白狼", "跑刀进去"],
            tone: .positive, priority: 10,
            responses: [
                "空手套白狼的最高境界！零成本直接血赚百万，这才是跑刀党的终极梦想。",
                "跑刀党狂喜！本来只想捡点垃圾凑个温饱，结果直接开出顶级货，这波运气简直逆天。",
            ],
            followUps: ["开局没带装备慌不慌呀？", "机密文件是在哪个房间摸的？"],
            emojis: ["💰", "🎮", "✨"]
        ),
        Template(
            id: "game_underdog_six_armor",
            keywords: ["六套大哥", "白装", "一套白装", "反杀六套", "捡了全套装备"],
            tone: .positive, priority: 11,
            responses: [
                "这波叫平民逆袭！以小博大反杀全装大佬，连装备带物资全打包带走，血赚到家。",
                "也太秀了吧！技术直接碾压装备差，对面六套大哥估计都气坏了，你这操作绝对能吹好久。",
            ],
            followUps: ["是靠偷袭还是正面刚赢的呀？", "捡的装备是不是直接毕业了？"],
            emojis: ["🔥", "🎮", "⚡"]
        ),
        Template(
            id: "game_last_second_extract",
            keywords: ["最后一秒撤离", "最后一秒冲", "差一秒就", "极限撤离", "卡最后一秒"],
            tone: .positive, priority: 10,
            responses: [
                "这心跳感直接拉满！被人追了一路，差一秒就前功尽弃，成功撤离的瞬间是不是长舒一口气。",
                "极限撤离最刺激了，背着一背包好东西被追着打，全程神经紧绷，成功撤离比吃鸡还爽。",
            ],
            followUps: ["最后有没有回头打两枪拖时间？", "背包里最值钱的是什么？"],
            emojis: ["💓", "🎮", "✨"]
        ),

        // MOBA 细化
        Template(
            id: "game_storm_dragon",
            keywords: ["风暴龙王", "抢龙王", "抢了龙王", "龙王翻盘", "守了四十分钟"],
            tone: .positive, priority: 11,
            responses: [
                "这才是 MOBA 的魅力啊！逆风守家守到绝望，一波抢龙直接逆天改命，爽感直接拉满。",
                "也太刺激了吧！四十分钟的膀胱局，最后一波定胜负，翻盘的快乐比顺风顺水赢十局还爽。",
            ],
            followUps: ["是谁抢的龙王呀？", "守家的时候是不是都觉得要输了？"],
            emojis: ["🐉", "🎮", "🔥"]
        ),
        Template(
            id: "game_carry_friend",
            keywords: ["带朋友", "带妹", "给她带上", "十连胜直接", "靠谱大腿"],
            tone: .positive, priority: 9,
            responses: [
                "妥妥的靠谱大腿！带飞全场的感觉也太有面了吧，队友全程喊 666，成就感直接拉满。",
                "实力带飞啊！一路连胜不翻车，有你这样的队友也太幸福了，躺着就能上分。",
            ],
            followUps: ["有没有哪一局赢得最惊险？", "你是不是专门练了带飞英雄？"],
            emojis: ["🫂", "🎮", "✨"]
        ),
        Template(
            id: "game_low_hp_outplay",
            keywords: ["残血被三个人", "丝血极限", "回头反杀两个", "残血反杀", "三个人追"],
            tone: .positive, priority: 10,
            responses: [
                "这操作也太秀了吧！丝血极限拉扯，对面估计都看傻了，这波绝对能上精彩集锦。",
                "心脏骤停级操作！残血不跑还反杀，心理素质和操作都拉满了，帅炸了。",
            ],
            followUps: ["用的什么英雄呀？", "反杀的时候手有没有抖？"],
            emojis: ["🔥", "🎮", "⚡"]
        ),

        // 抽卡养成细化
        Template(
            id: "game_weapon_jackpot",
            keywords: ["单抽出专武", "满精", "专武满精", "出了专武", "武器池"],
            tone: .positive, priority: 11,
            responses: [
                "这是什么阳寿抽卡！单抽满精专武，别人氪几千都不一定有，你这运气也太逆天了。",
                "欧皇请受我一拜！别人大保底都费劲，你单抽直接毕业，这概率比中彩票还低吧。",
            ],
            followUps: ["之前垫了多少抽呀？", "是不是本来没抱希望随手点的？"],
            emojis: ["✨", "🎮", "🌟"]
        ),
        Template(
            id: "game_relic_godroll",
            keywords: ["35分毕业", "双爆胚子", "全爆暴击", "阳寿圣遗物", "遗器双爆"],
            tone: .positive, priority: 10,
            responses: [
                "阳寿圣遗物啊！一次都不歪还全拉满，这可是别人刷半年都不一定出的极品，直接用到关服。",
                "也太欧了吧！强化全程不歪，每一手都长在刀刃上，这词条毕业度直接拉满。",
            ],
            followUps: ["强化的时候是不是屏住呼吸点的？", "毕业之后伤害涨了多少？"],
            emojis: ["💎", "🎮", "✨"]
        ),
        Template(
            id: "game_abyss_full",
            keywords: ["深渊满星", "混沌回忆满", "凹了三天", "满星通关", "打满了"],
            tone: .positive, priority: 10,
            responses: [
                "恭喜满星！凹了那么久的手法和配队，终于拿到满星奖励，成就感直接拉满。",
                "太不容易了！一遍一遍调整阵容、卡技能循环，最后满星的瞬间，所有努力都值了。",
            ],
            followUps: ["哪一层最难凹呀？", "用的什么主 C 打满的？"],
            emojis: ["⭐", "🎮", "🏆"]
        ),

        // 休闲竞技细化
        Template(
            id: "game_eggy_final_clutch",
            keywords: ["决赛圈被四个人", "极限反杀全部", "四个人围", "拿下第一"],
            tone: .positive, priority: 10,
            responses: [
                "这也太秀了吧！以一敌四还能稳稳夺冠，操作和心态都拉满了，凤凰蛋大佬实锤。",
                "极限反杀的爽感谁懂啊！本来以为要没了，结果逆风翻盘，这局能记好久。",
            ],
            followUps: ["最后是怎么反杀的呀？", "用的什么技能蛋？"],
            emojis: ["🥚", "🎮", "🔥"]
        ),
        Template(
            id: "game_tft_three_star_clutch",
            keywords: ["三星五费德莱文", "从第八锁血", "直接从第八", "D出三星五费"],
            tone: .positive, priority: 10,
            responses: [
                "三星五费的快乐是真的！成型之后直接碾压全场，从垫底一路杀到第一，逆袭感拉满。",
                "天胡运营啊！能 D 出三星五费太不容易了，看着对面打不动你的样子，是不是超爽。",
            ],
            followUps: ["多少阶段 D 出来的三星呀？", "中间有没有差点没血了？"],
            emojis: ["♟️", "🎮", "🏆"]
        ),

        // 快捷词条 · 暴富向
        Template(
            id: "game_chip_african_heart",
            keywords: ["我出非洲之心了", "出非洲之心了"],
            tone: .positive, priority: 12,
            responses: [
                "我去！非洲之心！三角洲顶级大金啊，摸出来的瞬间是不是激动得叫出声？",
                "这也太欧了吧！非洲之心一出，这趟直接顶别人跑半个月。",
            ],
            followUps: ["在哪个图摸到的呀？", "打算卖还是留着？"],
            emojis: ["💎", "🎮", "✨"]
        ),
        Template(
            id: "game_chip_million_extract",
            keywords: ["单局百万撤离", "百万撤离"],
            tone: .positive, priority: 10,
            responses: [
                "单局百万！这撤离也太肥了，背包是不是都装不下？",
                "一趟百万撤离，跑刀党 / 搜刮党的终极梦想达成了呀！",
            ],
            followUps: ["最值钱的货是什么？", "是零成本跑刀还是全装进的？"],
            emojis: ["💰", "🎮", "✨"]
        ),
        Template(
            id: "game_chip_big_red",
            keywords: ["摸出大红大金", "摸出大红", "大红大金"],
            tone: .positive, priority: 11,
            responses: [
                "大红大金到手！这爆率今天也太高了吧，欧气爆棚。",
                "摸出大红的感觉谁懂啊！搜箱子搜到手软，撤离一路都怕被人盯上吧。",
            ],
            followUps: ["是在哪个点位出的？", "这把赚了多少？"],
            emojis: ["💎", "🎮", "🔥"]
        ),
    ]

    static let gamingNegativeExtended: [Template] = [
        // 撤离类破防
        Template(
            id: "game_loot_lost_extract",
            keywords: ["非洲之心去撤离", "背着非洲之心", "大金被蹲", "被蹲点的打死", "大金被蹲掉了"],
            tone: .negative, priority: 12,
            responses: [
                "啊我的天！这也太心疼了吧，好不容易摸出来的顶级大金，最后一步没了，换谁都得气到摔鼠标。",
                "最痛的莫过于此！辛辛苦苦搜一整局，最后被老六蹲了血本无归，半天努力全白费。",
            ],
            followUps: ["有没有看到对面蹲在哪呀？", "是不是后悔没先清一下撤离点？"],
            emojis: ["😔", "🫂", "🎮"]
        ),
        Template(
            id: "game_trash_loot_run",
            keywords: ["全是垃圾", "连个小金都没有", "搜了十几个箱子", "零收益", "爆率被调低"],
            tone: .negative, priority: 9,
            responses: [
                "这也太非了吧，跑图跑半天全是破烂，时间精力全搭进去，一点收益都没有，越想越亏。",
                "非酋时刻太煎熬了，别人把把出大金，自己搜完整图连个像样的东西都没有，差距也太大了。",
            ],
            followUps: ["你搜的是哪张图呀？", "是不是感觉今天爆率被调低了？"],
            emojis: ["😔", "🫂", "🎮"]
        ),
        Template(
            id: "game_broke_run",
            keywords: ["跑刀破产", "连续三把跑刀", "钱全赔光", "回到解放前", "越打越穷"],
            tone: .negative, priority: 10,
            responses: [
                "跑刀破产最难受了，本来想赚点小钱，结果连本金都赔进去，越打越穷，直接回到解放前。",
                "抱抱你，连败的时候真的像被系统针对了，怎么打怎么亏，越想翻盘越输得惨。",
            ],
            followUps: ["还剩多少钱能启动呀？", "要不要先打打简单图缓一缓？"],
            emojis: ["🫂", "💙", "🎮"]
        ),
        Template(
            id: "game_teammate_betray",
            keywords: ["队友抢", "帮我拿一下大金", "自己撤离了", "背刺", "抢物资", "抢东西跑路"],
            tone: .negative, priority: 10,
            responses: [
                "这也太恶心了吧！本来是并肩作战的队友，结果背地里抢东西跑路，人品也太差了。",
                "被队友背刺最寒心了，本来还想着一起分收益，结果被人卖了还帮着数钱，换谁都气炸。",
            ],
            followUps: ["之前跟这个队友一起玩过吗？", "有没有办法举报他呀？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_cheat_wall_spawn",
            keywords: ["穿墙打死", "刚进图没两分钟", "科技哥", "进图就遇到挂"],
            tone: .negative, priority: 10,
            responses: [
                "开挂的真的太毁游戏体验了，好好的一局直接被毁，辛辛苦苦攒的装备说没就没，太憋屈了。",
                "最烦这种科技哥了，一点游戏公平都没有，正常玩家根本没法玩，举报都解不了气。",
            ],
            followUps: ["有没有保存录像举报呀？", "掉的装备心疼不心疼？"],
            emojis: ["😤", "🫂", "🎮"]
        ),

        // MOBA 破防细化
        Template(
            id: "game_penta_loss",
            keywords: ["五杀还是输", "拿了五杀还是", "五杀都救不了", "个人操作拉满"],
            tone: .negative, priority: 11,
            responses: [
                "这也太憋屈了吧！个人操作拉满都带不动，五杀都救不了猪队友，努力全白费。",
                "最惨的莫过于五杀背景板，明明自己秀翻天，奈何队友全拉胯，赢不了真的无力回天。",
            ],
            followUps: ["最后是怎么输的呀？", "队友是不是全程在送？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_camped",
            keywords: ["打野住线上", "三分钟来一次", "被针对", "反复抓单", "根本没法玩"],
            tone: .negative, priority: 9,
            responses: [
                "被针对到死也太难受了，对线本来就难，还要时刻防着打野，整局都提心吊胆的。",
                "对面也太损了，就盯着你一个人抓，游戏体验直接为零，换谁都得打一肚子气。",
            ],
            followUps: ["你家打野没来帮过你吗？", "最后有没有发育起来？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_buff_stolen",
            keywords: ["蓝被抢", "打了半天的蓝", "龙王被抢", "惩击抢了", "抢 buff", "抢龙"],
            tone: .negative, priority: 9,
            responses: [
                "辛辛苦苦打半天，结果被队友随手抢了，换谁都得气到血压飙升，这队友是对面派来的卧底吧。",
                "抢龙抢 buff 真的很搞心态，本来稳稳的节奏直接被打乱，有时候一个失误就葬送整局。",
            ],
            followUps: ["抢了之后你有没有说他？", "最后是不是因为这个输的？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_long_defeat",
            keywords: ["守了半个小时", "守家守半小时", "三路高地全破", "膀胱局", "功亏一篑"],
            tone: .negative, priority: 9,
            responses: [
                "膀胱局打到最后还是输，最消磨人了，手都打酸了，神经绷了半天，结果还是功亏一篑。",
                "太可惜了，守了那么久差一点就能翻盘，最后还是没顶住，失落感肯定特别强吧。",
            ],
            followUps: ["最后一波是怎么被推的呀？", "有没有哪波觉得能翻？"],
            emojis: ["🫂", "😔", "🎮"]
        ),

        // 抽卡养成破防细化
        Template(
            id: "game_weapon_pity_wrong",
            keywords: ["武器池定轨", "定轨了", "大保底还歪", "专武没拿到", "武器池歪"],
            tone: .negative, priority: 11,
            responses: [
                "武器池歪了最坑了，原石砸进去一大堆，想要的专武没拿到，还得再抽一轮，血亏。",
                "太心疼了，攒了那么久的原石全砸进去，结果竹篮打水一场空，换谁都得缓好几天。",
            ],
            followUps: ["歪到哪把武器了呀？", "接下来还打算接着抽吗？"],
            emojis: ["😔", "🫂", "💙"]
        ),
        Template(
            id: "game_abyss_almost",
            keywords: ["差十秒满星", "差一点点满星", "凹了一晚上深渊", "每次都差", "差一星满星"],
            tone: .negative, priority: 10,
            responses: [
                "差一点点的遗憾最磨人了，一遍一遍打，每次都差一点，越打越急，越急越失误。",
                "我懂这种无力感，明明已经很努力了，就差那一点点，怎么凹都差口气，特别挫败。",
            ],
            followUps: ["是哪一间差一点呀？", "要不要换个阵容试试？"],
            emojis: ["🫂", "😔", "🎮"]
        ),
        Template(
            id: "game_enhance_zero",
            keywords: ["增幅 14", "冲 15 连碎", "几千万金币全没", "单车变废铁", "直接归零"],
            tone: .negative, priority: 10,
            responses: [
                "强化增幅就是个无底洞，辛辛苦苦攒的资源说没就没，一下子回到解放前，太上头了。",
                "连碎也太搞心态了，本来想着搏一搏，结果单车直接变废铁，越想越心疼。",
            ],
            followUps: ["还剩多少资源呀？", "要不要先停手缓一缓？"],
            emojis: ["😔", "🫂", "🎮"]
        ),

        // 休闲竞技破防
        Template(
            id: "game_eggy_drop_rank",
            keywords: ["掉了两个段", "从恐龙蛋掉", "掉回鹅蛋", "巅峰赛连续掉"],
            tone: .negative, priority: 10,
            responses: [
                "连掉段最搞心态了，明明自己没失误，总遇到坑队友和离谱对手，越打越掉分。",
                "抱抱你，掉分的时候真的像被系统针对了，怎么打怎么输，一下午努力全白费。",
            ],
            followUps: ["是队友坑还是自己状态不好呀？", "有没有哪局输得最冤？"],
            emojis: ["🫂", "🎮", "💙"]
        ),
        Template(
            id: "game_tft_card_stolen",
            keywords: ["差一张三星五费", "被对面 D 走", "被卡走了", "第八出局", "截胡"],
            tone: .negative, priority: 10,
            responses: [
                "差一张的遗憾最难受了，辛辛苦苦攒了半天，最后被人截胡，功亏一篑，太憋屈了。",
                "发牌员也太针对了吧，就差临门一脚，结果直接给你掐灭希望，换谁都得郁闷好久。",
            ],
            followUps: ["对面是不是故意卡你的牌呀？", "最后有没有追出来？"],
            emojis: ["😔", "🫂", "🎮"]
        ),

        // 快捷词条 · 破防 / 吐槽向
        Template(
            id: "game_chip_loot_lost",
            keywords: ["大金被蹲掉了", "被蹲掉了"],
            tone: .negative, priority: 11,
            responses: [
                "大金被蹲真的太搞心态了，搜了一整局最后一步全没了，换谁都得破防。",
                "啊…临门一脚被蹲，这亏吃得也太疼了，先别硬打，缓一缓。",
            ],
            followUps: ["是在撤离点被蹲的吗？", "掉的是大红还是非洲之心？"],
            emojis: ["😔", "🫂", "🎮"]
        ),
        Template(
            id: "game_chip_camped",
            keywords: ["被老六阴了", "老六阴了"],
            tone: .negative, priority: 10,
            responses: [
                "被老六阴最气了，搜得好好的突然没反应过来，装备全搭进去，亏到姥姥家。",
                "老六这种玩法真的搞心态，明明没犯错，却被蹲到血本无归。",
            ],
            followUps: ["是在哪个点位被阴的？", "掉的装备心疼不心疼？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
        Template(
            id: "game_chip_cheat_rage",
            keywords: ["遇到外挂了", "遇到挂了"],
            tone: .negative, priority: 10,
            responses: [
                "遇到外挂真的能把人气炸，好好一局全被毁了，举报都解不了气。",
                "开挂的太恶心了，正常玩家根本没法玩，你这次亏大了吗？",
            ],
            followUps: ["是穿墙还是锁头呀？", "有没有录屏举报？"],
            emojis: ["😤", "🫂", "🎮"]
        ),
    ]
}
