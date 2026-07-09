import Foundation

/// 日常细碎情绪 — 物品得失、出行、陌生人、习惯、饮食、身体感官、兴趣期待
extension ScenarioLibrary {

    static let dailyMoodsPositive: [Template] = [
        // MARK: - 一、物品与得失 · 正向

        Template(
            id: "daily_item_found",
            keywords: [
                "丢了很久", "翻到了", "以为丢了", "找到了", "失而复得", "还能用", "口袋里找到",
                "lost for months", "found my", "thought I lost",
            ],
            tone: .positive, priority: 8,
            responses: [
                "失而复得也太惊喜了！本来都以为再也找不到了，突然冒出来的感觉，像捡回了宝贝一样。",
                "这种惊喜比买新的还开心！毕竟用久了的东西都有感情，找回来的瞬间心都落定了。",
                "也太幸运了吧！丢了那么久还能找回来，今天运气直接拉满。",
            ],
            followUps: ["当时是不是以为肯定找不回来了？", "找回来之后是不是特意放好了？"],
            emojis: ["✨", "😊", "🎁"]
        ),
        Template(
            id: "daily_money_found",
            keywords: [
                "口袋里翻出", "意外之财", "白捡", "翻出两百", "翻出几十", "零钱", "外套口袋",
                "found money", "money in pocket", "forgotten cash",
            ],
            tone: .positive, priority: 8,
            responses: [
                "白捡的快乐谁懂啊！完全没印象的钱，突然冒出来，比发工资还开心。",
                "这是什么天降小惊喜！凭空多出一笔零花钱，今天的快乐成本直接为零。",
                "哈哈这种快乐最实在了，相当于白捡的奶茶钱，必须拿去买点好吃的奖励自己。",
            ],
            followUps: ["翻出来多少钱呀？", "打算拿去买点啥？"],
            emojis: ["😊", "✨", "💰"]
        ),
        Template(
            id: "daily_bargain_win",
            keywords: [
                "比大牌还好用", "质量好到离谱", "超出预期", "挖到宝", "性价比", "平价", "几十块钱",
                "better than expected", "great bargain", "worth every penny",
            ],
            tone: .positive, priority: 7,
            responses: [
                "挖到宝的感觉也太爽了！没抱期待的东西反而超出预期，性价比直接拉满。",
                "这种意外的满意最让人开心了，花小钱办大事，感觉自己特别会买。",
                "也太会挑了吧！平价又好用的东西最难得，感觉以后会一直回购。",
            ],
            followUps: ["是在哪挖到的宝藏呀？", "有没有超出预期的小细节？"],
            emojis: ["✨", "😊", "👍"]
        ),

        // MARK: - 二、日常出行 · 正向

        Template(
            id: "daily_rain_umbrella",
            keywords: [
                "幸好带伞", "带了伞", "撑伞走", "突然下大雨", "不用躲雨",
                "brought umbrella", "glad I had umbrella", "rain but prepared",
            ],
            tone: .positive, priority: 7,
            responses: [
                "这种「幸好我带了」的安全感也太足了！看着别人慌慌张张躲雨，自己稳稳当当的，莫名有种小得意。",
                "也太有先见之明了！雨天带伞真的是顶级安全感，不用狼狈躲雨，连下雨都变得舒服了。",
                "今天的幸运值直接拉满！就这一个小细节，一整天的心情都变好了。",
            ],
            followUps: ["是不是平时就习惯带伞呀？", "雨下得大不大？"],
            emojis: ["☂️", "😊", "✨"]
        ),
        Template(
            id: "daily_smooth_commute",
            keywords: [
                "电梯门就开了", "刚好赶上", "一路绿灯", "不用等", "一路顺畅", "连红灯都没",
                "elevator opened", "all green lights", "perfect timing",
            ],
            tone: .positive, priority: 7,
            responses: [
                "这种一路顺畅的感觉也太舒服了！不用等、不用赶，顺顺利利的，连赶路都变轻松了。",
                "也太丝滑了吧！刚好赶上的快乐，虽然是小事，但能开心一早上。",
                "今日份欧气从出门就开始了！连红绿灯都在帮你节省时间，开局就很顺。",
            ],
            followUps: ["是不是出门时间掐得刚刚好？", "一路顺畅是不是心情都变好了？"],
            emojis: ["✨", "😊", "🚦"]
        ),
        Template(
            id: "daily_early_delivery",
            keywords: [
                "提前送到", "二十分钟就送到", "比预计早", "今天就到", "还热乎", "物流提前",
                "delivered early", "arrived sooner", "ahead of schedule",
            ],
            tone: .positive, priority: 7,
            responses: [
                "提前收到的快乐翻倍！本来还在等，结果惊喜提前到，连等待的煎熬都省了。",
                "也太高效了吧！不用饿着肚子等外卖，不用天天刷物流，这种超出预期的顺畅最舒服了。",
                "幸福感直接提前到账！热乎乎的外卖 / 期待的快递早早来，今天的快乐也提前了。",
            ],
            followUps: ["是不是比预计早了好多？", "拿到的时候是不是超惊喜？"],
            emojis: ["😊", "✨", "📦"]
        ),

        // MARK: - 三、陌生人社交 · 正向

        Template(
            id: "daily_stranger_kindness",
            keywords: [
                "帮我扶着门", "帮我捡", "换零钱", "陌生", "帮我刷", "随手善意", "伸手帮",
                "stranger helped", "held the door", "kind stranger",
            ],
            tone: .positive, priority: 8,
            responses: [
                "陌生人的善意最戳人了，只是随手一个小动作，却能暖好久，感觉整个世界都温柔了一点。",
                "也太暖心了吧！素不相识的人愿意伸手帮一把，这种不经意的温柔，最容易记好久。",
                "被陌生人善待的感觉真好，一点点小善意，就能让一整天都变得软软的。",
            ],
            followUps: ["当时是不是心里一下就暖了？", "你有没有跟对方好好道谢？"],
            emojis: ["🫂", "✨", "💕"]
        ),
        Template(
            id: "daily_stranger_compliment",
            keywords: [
                "夸我裙子", "夸发型", "夸好看", "小姐姐夸", "店员说我", "陌生人夸", "被夸",
                "complimented me", "stranger said I look", "nice outfit",
            ],
            tone: .positive, priority: 8,
            responses: [
                "被陌生人夸奖也太快乐了！毫无预期的赞美，比熟人夸还让人开心，一整天都美滋滋的。",
                "这种来自陌生人的肯定最真实了，没有客套没有人情，就是单纯的欣赏，想想都嘴角上扬。",
                "也太幸福了吧！一句不经意的夸奖，能让自信心直接爆棚，走路都带风。",
            ],
            followUps: ["是不是开心了好久？", "对方夸完你是不是有点不好意思？"],
            emojis: ["😊", "✨", "💕"]
        ),

        // MARK: - 四、习惯与自我管理 · 正向

        Template(
            id: "daily_habit_streak",
            keywords: [
                "连续打卡", "一百天", "坚持了一个月", "坚持运动", "背单词", "雷打不动", "满周期",
                "streak", "100 days", "kept going for a month",
            ],
            tone: .positive, priority: 8,
            responses: [
                "也太有毅力了吧！一天两天容易，坚持一百天真的超难，你也太厉害了。",
                "坚持的意义真的会慢慢显现，看着自己从断断续续到雷打不动，这种掌控感太棒了。",
                "恭喜你解锁新成就！日复一日的小坚持，最后都会变成大大的收获，你超棒的。",
            ],
            followUps: ["中间有没有想放弃的时候？", "坚持下来最大的变化是什么？"],
            emojis: ["💪", "✨", "🎉"]
        ),
        Template(
            id: "daily_bad_habit_quit",
            keywords: [
                "改掉熬夜", "早睡早起", "戒掉奶茶", "改掉", "戒掉了", "一个月没喝", "摆脱坏习惯",
                "quit", "broke the habit", "stopped staying up late",
            ],
            tone: .positive, priority: 8,
            responses: [
                "也太厉害了吧！改掉一个坏习惯可比养成新习惯难多了，你这自控力直接拉满。",
                "摆脱坏习惯的感觉也太爽了，整个人都变得更清爽更有活力，状态都不一样了。",
                "能和旧习惯说再见真的很不容易，你已经赢过好多人了，继续保持呀。",
            ],
            followUps: ["最难熬的是哪段时间？", "改掉之后是不是感觉特别好？"],
            emojis: ["💪", "✨", "🌿"]
        ),

        // MARK: - 五、饮食味觉 · 正向

        Template(
            id: "daily_homestyle_food",
            keywords: [
                "老家的味道", "家乡菜", "一口就想家", "童年", "小时候常吃", "想念很久的味道",
                "taste of home", "childhood flavor", "missed this taste",
            ],
            tone: .positive, priority: 8,
            responses: [
                "味道是有记忆的吧，一口下去，所有想家的情绪、童年的回忆都涌上来了，又暖又感慨。",
                "这种熟悉的味道最治愈了，不管走多远，吃到熟悉的味道，就像回到了最安心的时候。",
                "也太幸福了吧！想念了那么久的味道，终于吃到嘴里的瞬间，所有思念都落地了。",
            ],
            followUps: ["是不是一口就吃出了以前的感觉？", "多久没吃到这个味道了？"],
            emojis: ["🍜", "✨", "🏠"]
        ),
        Template(
            id: "daily_cooking_surprise",
            keywords: [
                "随便炒", "意外的好吃", "被自己惊艳", "第一次做", "没翻车", "瞎炒", "厨艺天赋",
                "accidentally delicious", "cooked surprisingly well", "first try turned out great",
            ],
            tone: .positive, priority: 7,
            responses: [
                "这种意外的好吃最惊喜了！本来没抱希望，结果味道超棒，瞬间觉得自己有厨艺天赋。",
                "也太厉害了吧！随便做做都好吃，这是什么隐藏厨艺天赋，以后可以多尝试。",
                "自己做的饭，好吃程度直接翻倍，尤其是没抱期待的时候，幸福感直接拉满。",
            ],
            followUps: ["是做的什么菜呀？", "是不是比预想的好吃好多？"],
            emojis: ["😋", "✨", "👨‍🍳"]
        ),

        // MARK: - 六、身体感官 · 正向

        Template(
            id: "daily_good_sleep",
            keywords: [
                "一觉睡到天亮", "连梦都没做", "神清气爽", "睡了个好觉", "活过来了", "无梦",
                "slept through", "woke up refreshed", "great sleep",
            ],
            tone: .positive, priority: 8,
            responses: [
                "睡一个饱饱的整觉也太治愈了！醒来浑身轻松，连心情都跟着变透亮了。",
                "这种睡醒不疲惫的感觉太珍贵了，神清气爽的，感觉今天干什么都有精力。",
                "恭喜睡个好觉！高质量的睡眠比什么都补，今天一天都会很舒服。",
            ],
            followUps: ["是不是很久没睡这么好了？", "醒来是不是觉得特别轻松？"],
            emojis: ["🌙", "✨", "😊"]
        ),
        Template(
            id: "daily_bath_bed",
            keywords: [
                "洗完澡", "刚晒过的被窝", "钻进被窝", "浑身清爽", "洗了头洗了澡", "香香的",
                "fresh sheets", "after shower", "clean and cozy",
            ],
            tone: .positive, priority: 7,
            responses: [
                "这简直是顶级治愈时刻！暖乎乎干干净净的，所有疲惫都跟着洗掉了，只剩舒服和放松。",
                "这种清爽感太解压了，从头发丝到脚指头都干干净净的，连心情都跟着变干净了。",
                "想想都觉得舒服，裹着软乎乎的被子，浑身香香的，一天的疲惫都没了。",
            ],
            followUps: ["是不是躺进去就不想起来了？", "有没有晒过的阳光味道？"],
            emojis: ["🛁", "✨", "🌙"]
        ),

        // MARK: - 七、兴趣与期待 · 正向

        Template(
            id: "daily_plant_bloom",
            keywords: [
                "终于发芽", "开花了", "多肉开花", "种子发芽", "养了", "冒小芽",
                "finally bloomed", "sprouted", "my plant flowered",
            ],
            tone: .positive, priority: 7,
            responses: [
                "也太有成就感了！一天天浇水等着，终于冒出小芽 / 开出花，像看着自己的小宝贝长大了一样。",
                "养植物的快乐就在这呀，耐心等待之后的惊喜，满满的生命力，看着就觉得治愈。",
                "恭喜呀！你的用心照顾终于有回报了，接下来肯定会长得越来越好。",
            ],
            followUps: ["是不是每天都要看好几遍？", "刚发芽的时候是不是特别激动？"],
            emojis: ["🌱", "✨", "🌸"]
        ),
        Template(
            id: "daily_update_dropped",
            keywords: [
                "终于更新了", "等了一周", "今晚有的熬", "作者更新了", "追更", "番更新了",
                "new episode", "finally updated", "chapter dropped",
            ],
            tone: .positive, priority: 7,
            responses: [
                "等更新的日子太难熬了，终于等到的瞬间，快乐直接拉满，连干活都有动力了。",
                "追更的快乐谁懂啊！攒了一周的期待，终于可以一口气看完，太满足了。",
                "哈哈是不是已经准备好零食，准备通宵看了？追更的日子虽然难熬，但更新的时候最快乐。",
            ],
            followUps: ["是不是攒着舍不得看？", "有没有猜到接下来的剧情？"],
            emojis: ["🎉", "✨", "📺"]
        ),
    ]

    static let dailyMoodsNegative: [Template] = [
        // MARK: - 一、物品与得失 · 负向

        Template(
            id: "daily_item_lost_memento",
            keywords: [
                "生日礼物弄丢", "手链不见了", "纪念意义", "心里空落落", "陪了自己很久", "弄丢了",
                "lost gift", "lost bracelet", "sentimental item",
            ],
            tone: .negative, priority: 8,
            responses: [
                "肯定特别难受吧，东西不贵重，但承载的回忆和心意是代替不了的，丢了就像少了点什么。",
                "我懂这种空落落的感觉，陪了自己那么久的东西，突然就不见了，连带着回忆都像缺了一块。",
                "别太自责了，说不定哪天它就自己冒出来了。但就算找不到，那些回忆也一直在的。",
            ],
            followUps: ["是在哪里弄丢的还有印象吗？", "是不是朋友送的特别有意义？"],
            emojis: ["🫂", "💙", "🌿"]
        ),
        Template(
            id: "daily_price_drop_broken",
            keywords: [
                "刚买完就降价", "亏了好几十", "用了一次就坏了", "白花钱", "刚买就坏", "降价了",
                "price dropped", "broke right away", "just bought and",
            ],
            tone: .negative, priority: 8,
            responses: [
                "也太亏了吧！刚买完就降价，感觉自己像个冤大头，换谁都得郁闷半天。",
                "新东西没用就坏了最闹心，期待了半天结果全是失望，还要折腾退换，浪费时间又闹心。",
                "这是什么倒霉运气，刚到手的新鲜劲还没过，就直接浇冷水，太影响心情了。",
            ],
            followUps: ["差了多少钱呀？", "能不能退换或者补差价？"],
            emojis: ["😔", "🫂", "💙"]
        ),
        Template(
            id: "daily_discontinued",
            keywords: [
                "停产了", "下架了", "再也买不到", "囤的用完", "零食下架", "找不到替代",
                "discontinued", "no longer sold", "can't buy anymore",
            ],
            tone: .negative, priority: 8,
            responses: [
                "这种「再也没有了」的失落感最难受了，习惯了的东西突然消失，连带着日常的小快乐都少了一块。",
                "我懂这种遗憾，不是买不起更好的，是再也找不到一模一样的感觉了，心里空落落的。",
                "也太可惜了，自己钟爱的小东西说没就没了，连个替代的都找不到。剩下的囤货都舍不得用了对吧。",
            ],
            followUps: ["是不是用了特别久了？", "有没有找过类似的替代品？"],
            emojis: ["🫂", "💙", "🌿"]
        ),

        // MARK: - 二、日常出行 · 负向

        Template(
            id: "daily_forgot_essential",
            keywords: [
                "忘带钥匙", "忘带充电宝", "忘带伞", "门吹关了", "进不去家", "手机快没电", "进退两难",
                "forgot keys", "locked out", "forgot charger", "no umbrella",
            ],
            tone: .negative, priority: 8,
            responses: [
                "也太窘迫了吧！进也不是退也不是，站在门口手足无措的，又急又无奈。",
                "忘带东西最磨人了，尤其是手机没电、没钥匙这种，直接打乱所有计划，干着急。",
                "这种低级失误最让人郁闷了，明明出门前还想着，结果转头就忘，只能自己折腾解决。",
            ],
            followUps: ["最后是怎么解决的呀？", "是不是出门太急了？"],
            emojis: ["😔", "🫂", "💙"]
        ),
        Template(
            id: "daily_clothes_stained",
            keywords: [
                "白 T 恤", "溅了油", "白裤子", "撒了一身", "奶茶没拿稳", "白衣服", "洗不掉",
                "stained white", "spilled on", "ruined my shirt",
            ],
            tone: .negative, priority: 8,
            responses: [
                "白衣服沾脏东西最心疼了！尤其是刚穿的新衣服，一块印子特别明显，看着就闹心。",
                "也太倒霉了，好好的衣服一下子就毁了，擦也擦不掉，洗也洗不干净，越看越郁闷。",
                "我懂这种心梗的感觉，刚穿上的干净衣服，瞬间就脏了，一整天的好心情都打折扣。",
            ],
            followUps: ["能不能洗掉呀？", "是不是刚买的新衣服？"],
            emojis: ["😔", "🫂", "💙"]
        ),
        Template(
            id: "daily_package_stuck",
            keywords: [
                "卡在中转站", "一动不动", "等了一天", "物流不动", "三天了", "派送", "急死人",
                "stuck in transit", "tracking not moving", "waiting for delivery",
            ],
            tone: .negative, priority: 7,
            responses: [
                "等快递最熬人了，尤其是卡在半路不动，刷一百遍物流都不更新，越等越着急。",
                "明明近在咫尺却拿不到，这种吊着的感觉最难受了，期待感都被磨没了。",
                "物流不动真的很搞心态，盼了好久的东西，一直卡在那，连个准信都没有。",
            ],
            followUps: ["买的什么东西这么急着要？", "有没有问过客服怎么回事？"],
            emojis: ["😔", "🫂", "📦"]
        ),

        // MARK: - 三、陌生人社交 · 负向

        Template(
            id: "daily_privacy_intrusion",
            keywords: [
                "追问工资", "问对象", "问年龄", "没边界感", "不熟的亲戚", "打探", "烦都烦死",
                "asked my salary", "too personal", "no boundaries",
            ],
            tone: .negative, priority: 8,
            responses: [
                "最烦这种没边界感的人了，什么隐私都敢问，不回答又显得没礼貌，回答了又憋屈。",
                "关起门来过自己的日子，非要打探别人的生活，这种过度的关心，只会让人觉得不舒服。",
                "遇上这种人真的很无语，说也不是不说也不是，好好的聚会心情都被搅乱了。",
            ],
            followUps: ["你当时是怎么应付过去的？", "是不是经常被问这种问题？"],
            emojis: ["😤", "🫂", "💙"]
        ),
        Template(
            id: "daily_help_misunderstood",
            keywords: [
                "好心没好报", "被说是不是我", "被嫌买错了", "顺手帮", "反而被责怪", "被冤枉",
                "tried to help", "misunderstood", "ungrateful", "blamed me for helping",
            ],
            tone: .negative, priority: 8,
            responses: [
                "也太憋屈了吧！好心好意伸手帮忙，反而被冤枉、被挑剔，换谁都得寒心。",
                "好心没好报最让人难受了，本来是出于善意，结果落一身埋怨，以后都不敢随便帮人了。",
                "这也太冤枉了，明明是做好事，反而被误解，满腔善意直接被浇冷水。",
            ],
            followUps: ["最后你有没有解释清楚？", "是不是特别后悔帮这个忙？"],
            emojis: ["😤", "🫂", "💙"]
        ),

        // MARK: - 四、习惯与自我管理 · 负向

        Template(
            id: "daily_streak_broken",
            keywords: [
                "打卡断了", "忘了断了", "连续打卡", "前功尽弃", "停了一天", "断卡", "五十天",
                "broke my streak", "missed a day", "lost my streak",
            ],
            tone: .negative, priority: 8,
            responses: [
                "断卡的瞬间肯定特别失落吧，感觉之前的努力都白费了，心里空落落的。",
                "我懂这种功亏一篑的挫败感，本来好好的节奏，一下子就断了，连继续的动力都没了。",
                "其实断一天也没关系呀，不用追求完美，能坚持那么久已经很厉害了，明天重新开始就好。",
            ],
            followUps: ["是因为什么事打断了呀？", "会不会觉得特别可惜？"],
            emojis: ["🫂", "💙", "🌿"]
        ),
        Template(
            id: "daily_flag_failed",
            keywords: [
                "flag倒了", "又吃了夜宵", "又玩了一天", "发誓", "恨死自己", "破戒", "反复打脸",
                "broke my promise", "failed my goal", "couldn't resist",
            ],
            tone: .negative, priority: 8,
            responses: [
                "别这么苛责自己呀，flag 立了又倒太正常了，谁不是反反复复的，又不是你一个人这样。",
                "我懂这种事后的愧疚感，吃的时候爽，吃完就后悔，反复拉扯特别内耗。其实不用逼自己那么紧，慢慢来就好。",
                "人性本来就是这样的，不是你意志力差。不用因为一次破戒就全盘否定自己，下次再努力就好。",
            ],
            followUps: ["是不是每次破戒都特别后悔？", "有没有想过稍微降低一点要求？"],
            emojis: ["🫂", "🌿", "💙"]
        ),

        // MARK: - 五、饮食味觉 · 负向

        Template(
            id: "daily_restaurant_disappoint",
            keywords: [
                "特意去吃的店", "关门了", "白跑一趟", "味道特别一般", "网红店", "排了好久队", "大失所望",
                "restaurant closed", "not worth the hype", "disappointing food",
            ],
            tone: .negative, priority: 8,
            responses: [
                "期待了那么久，结果扑了个空 / 踩了雷，落差感也太大了，白跑一趟还坏心情。",
                "乘兴而来败兴而归的感觉最难受了，攒了好久的期待，一下子就落空了。",
                "也太亏了吧，花了时间花了钱，结果完全不是想象中的样子，越想越不值。",
            ],
            followUps: ["排了多久的队 / 跑了多远呀？", "是不是网上吹得太厉害了？"],
            emojis: ["😔", "🫂", "💙"]
        ),
        Template(
            id: "daily_food_foreign_object",
            keywords: [
                "吃到头发", "喝出虫子", "没胃口", "恶心死了", "异物", "膈应",
                "hair in food", "bug in", "found something gross",
            ],
            tone: .negative, priority: 9,
            responses: [
                "想想都觉得膈应，吃得好好的突然看到，瞬间食欲全无，半天缓不过来。",
                "也太恶心了吧！本来开开心心吃饭，结果遇上这种事，好心情直接全毁了。",
                "这种体验真的太糟了，不仅吃不下饭，以后想起这家店都有阴影。",
            ],
            followUps: ["最后商家给你处理了吗？", "是不是直接就不吃了？"],
            emojis: ["😔", "🫂", "💙"]
        ),

        // MARK: - 六、身体感官 · 负向

        Template(
            id: "daily_insomnia",
            keywords: [
                "躺到三点", "越想睡越清醒", "失眠一整夜", "睁着眼到天亮", "快崩溃了", "睡不着",
                "insomnia", "couldn't sleep", "awake until dawn", "tossing all night",
            ],
            tone: .negative, priority: 8,
            responses: [
                "失眠最熬人了，越急着睡越清醒，躺着翻来覆去，看着天一点点亮，又焦虑又疲惫。",
                "我懂这种无力感，明明困得不行，脑子却停不下来，眼睁睁耗到天亮，第二天整个人都飘着。",
                "别逼自己一定要睡着，越逼越焦虑。躺着闭目养神也是休息，慢慢就会困的。",
            ],
            followUps: ["是因为想事情睡不着吗？", "白天是不是睡多了？"],
            emojis: ["🫂", "🌙", "💙"]
        ),
        Template(
            id: "daily_minor_pain",
            keywords: [
                "口腔溃疡", "牙疼", "落枕", "吃饭说话都疼", "脖子动不了", "小病小痛", "磨人",
                "mouth ulcer", "toothache", "stiff neck", "minor pain",
            ],
            tone: .negative, priority: 7,
            responses: [
                "这种小病小痛最磨人了，不是什么大病，但时时刻刻都在疼，干什么都受影响，烦都烦死了。",
                "我懂这种憋屈，疼得不厉害，但一直缠着你，吃饭睡觉都受影响，整个人都烦躁。",
                "小毛病才最熬人，连发脾气都觉得小题大做，但就是实实在在难受。",
            ],
            followUps: ["是不是连吃饭都受影响？", "有没有涂点药缓解一下？"],
            emojis: ["🫂", "💙", "🌿"]
        ),

        // MARK: - 七、兴趣与期待 · 负向

        Template(
            id: "daily_bad_ending",
            keywords: [
                "烂尾", "结局烂", "白追了", "气死我了", "浪费感情", "毁在最后", "离谱结局",
                "bad ending", "ruined ending", "wasted my time watching",
            ],
            tone: .negative, priority: 8,
            responses: [
                "真情实感追了那么久，结果结局敷衍了事，感觉自己的时间和感情全被浪费了，越想越气。",
                "烂尾真的比没看过还难受，前面有多上头，结局就有多心梗，好好的作品毁在最后。",
                "也太遗憾了，攒了那么久的期待，就等来个烂结局，换谁都得郁闷好久。",
            ],
            followUps: ["最让你接受不了的是什么情节？", "你心里理想的结局是什么样的？"],
            emojis: ["😤", "🫂", "💙"]
        ),
        Template(
            id: "daily_unopened_hoard",
            keywords: [
                "积灰", "都没拆封", "一本都没看完", "囤了一堆", "买了半年", "负罪感", "没玩",
                "still sealed", "bought but never", "collecting dust", "haven't opened",
            ],
            tone: .negative, priority: 7,
            responses: [
                "买的时候兴致勃勃，买回来就放着，好像买了等于看过玩过了，最后只剩积灰和负罪感。",
                "我懂这种「囤了就是拥有了」的心态，下单的时候最快乐，之后就再也没碰过，钱花得特别冤枉。",
                "好多人都这样，买的时候激情满满，回来就懒得动。不用有负罪感，说不定哪天突然就想拿起来了。",
            ],
            followUps: ["买的时候是不是特别期待？", "有没有想过什么时候开始看 / 玩？"],
            emojis: ["🫂", "🌿", "💙"]
        ),
    ]
}
