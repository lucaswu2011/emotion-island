import Foundation

/// 校园生活场景话术库 — 宿舍、食堂、班委、体测、人际、校规
extension ScenarioLibrary {

    static let campusLifePositive: [Template] = [
        // MARK: - 宿舍 · 正向
        Template(
            id: "campus_dorm_night_talk",
            keywords: ["卧谈", "夜聊", "聊心里话", "聊八卦", "笑得肚子", "亲近了好多"],
            tone: .positive, priority: 9,
            responses: [
                "宿舍卧谈真的是学生时代最珍贵的回忆了！关了灯围在一起聊心事、聊八卦，不用设防，轻轻松松的，这种热热闹闹的感觉太美好了。",
                "也太幸福了吧！能遇到聊得来的室友，连住校都变成了值得期待的事。深夜说过的心里话，都会变成彼此专属的小秘密。",
            ],
            followUps: ["你们昨晚聊得最多的是什么话题呀？", "是不是聊着聊着就忘了时间？"],
            emojis: ["🏠", "✨", "😊"],
            responsesEN: [
                "Late-night dorm talks are peak school memories — no filters, just hearts and laughs.",
                "Roommates you can open up to make boarding school feel like home.",
            ],
            followUpsEN: ["What did you talk about most?", "Did you lose track of time?"]
        ),
        Template(
            id: "campus_dorm_kindness",
            keywords: ["帮我带饭", "记了笔记", "帮我占座", "早八", "太暖心了", "神仙室友"],
            tone: .positive, priority: 8,
            responses: [
                "被人放在心上的感觉真的好踏实，不用开口说就有人想着你，这种细碎的温柔最戳人了。",
                "神仙室友也太好了吧！住校能遇到靠谱又贴心的室友，简直是上学最幸运的事之一。",
            ],
            followUps: ["你平时也会经常帮室友带东西吗？", "你们宿舍关系一直都这么好吗？"],
            emojis: ["🏠", "💕", "✨"],
            responsesEN: [
                "Being remembered without asking — small kindness, big warmth.",
                "A solid roommate is one of campus life's best gifts.",
            ],
            followUpsEN: ["Do you help them too?", "Has your dorm always been this close?"]
        ),
        Template(
            id: "campus_dorm_party",
            keywords: ["宿舍过生日", "偷偷准备了蛋糕", "宿舍团建", "一起吃火锅", "感动哭了"],
            tone: .positive, priority: 8,
            responses: [
                "一群人热热闹闹为一个人准备惊喜的感觉真好，青春里的生日，有室友陪着过，也太难忘了。",
                "宿舍团建也太快乐了！不用顾及别的，一群同龄人吃吃喝喝说说笑笑，所有烦恼都没了。",
            ],
            followUps: ["是谁想出来的惊喜主意呀？", "你们下一次团建打算去哪？"],
            emojis: ["🎂", "🏠", "✨"],
            responsesEN: [
                "Surprising a roommate on their birthday — that's the kind of memory you keep.",
                "Dorm hangouts where everyone eats and laughs — stress melts away.",
            ],
            followUpsEN: ["Whose idea was the surprise?", "Where's the next outing?"]
        ),
        Template(
            id: "campus_dorm_study",
            keywords: ["期末周", "带我复习", "一起熬夜", "互相抽背", "学习搭子", "不然我肯定挂科"],
            tone: .positive, priority: 9,
            responses: [
                "有人一起并肩作战的感觉真好，一个人复习容易偷懒，一群人陪着熬，好像连背书都没那么苦了。",
                "神仙学习搭子啊！大家互相帮扶着往前走，期末周再难熬，也变得有底气多了。",
            ],
            followUps: ["你们一般复习到几点呀？", "有没有谁是宿舍的「学霸担当」？"],
            emojis: ["📚", "🏠", "💪"],
            responsesEN: [
                "Studying together beats solo cramming — company makes finals less brutal.",
                "Dorm study buddies — shared effort, shared confidence.",
            ],
            followUpsEN: ["How late do you review?", "Who's the dorm ace?"]
        ),

        // MARK: - 食堂课间 · 正向
        Template(
            id: "campus_canteen_lucky",
            keywords: ["最后一份", "糖醋排骨", "最爱的鸡腿", "跑着去食堂", "运气爆棚"],
            tone: .positive, priority: 7,
            responses: [
                "干饭人的顶级快乐！抢到最后一份爱吃的菜，这顿饭吃得都比平时香，一整天的好心情都有了。",
                "也太幸运了吧！食堂热门菜全靠抢，能赶上最后一份，简直是今日份校园小锦鲤。",
            ],
            followUps: ["你为了这道菜跑了多久呀？", "食堂你最爱的菜还有什么？"],
            emojis: ["🍱", "✨", "😊"],
            responsesEN: [
                "Last serving of your favorite dish — diner's jackpot.",
                "Campus luck when the line pays off.",
            ],
            followUpsEN: ["How fast did you run?", "What else do you love there?"]
        ),
        Template(
            id: "campus_break_nap",
            keywords: ["课间十分钟", "趴桌睡", "醒了之后特别精神", "活过来了"],
            tone: .positive, priority: 7,
            responses: [
                "课间十分钟的觉是全世界最香的！短短十分钟，睡得又沉又香，醒过来整个人都回血了。",
                "学生党续命神器就是课间趴桌睡！虽然时间短，但解乏效果一流，下节课都能听进去了。",
            ],
            followUps: ["你一般课间都会睡觉吗？", "有没有睡过头错过上课铃？"],
            emojis: ["💤", "✨", "😊"],
            responsesEN: [
                "Ten-minute desk naps hit different — full recharge.",
                "The secret weapon between classes.",
            ],
            followUpsEN: ["Do you nap every break?", "Ever oversleep the bell?"]
        ),
        Template(
            id: "campus_shop_ice",
            keywords: ["小卖部", "最后一瓶", "冰可乐", "冰棒", "冲去小卖部"],
            tone: .positive, priority: 7,
            responses: [
                "大热天里的冰饮就是救赎啊！上完体育课喝一口冰的，从头顶爽到脚底，所有燥热都没了。",
                "校园小卖部的快乐真的很简单，一瓶冰汽水、一根冰棒，就能治愈一整节课的疲惫。",
            ],
            followUps: ["你最喜欢小卖部的什么东西呀？", "是不是一下课就冲过去了？"],
            emojis: ["🥤", "✨", "😊"],
            responsesEN: [
                "Ice drink after PE — instant cooldown.",
                "Simple joy: one cold soda from the school shop.",
            ],
            followUpsEN: ["Favorite snack there?", "Sprint right after class?"]
        ),
        Template(
            id: "campus_bump_friend",
            keywords: ["偶遇", "小学的好朋友", "聊了一路", "偷偷说了好多八卦", "顺路"],
            tone: .positive, priority: 7,
            responses: [
                "校园里的偶遇总是特别惊喜，本来平平无奇的放学路，因为遇到了想见的人，一下子就变得有意思了。",
                "这种不期而遇的快乐最棒了！短短一段路，聊几句八卦、说几句废话，心情都跟着亮起来。",
            ],
            followUps: ["你们好久没见了吗？", "有没有约着下次一起玩？"],
            emojis: ["✨", "😊", "🌿"],
            responsesEN: [
                "Running into someone on the way home — ordinary path, instant brightness.",
                "Short walk, long gossip — campus joy.",
            ],
            followUpsEN: ["Long time no see?", "Plan to hang out again?"]
        ),

        // MARK: - 班级社团 · 正向
        Template(
            id: "campus_event_success",
            keywords: ["主题班会", "策划", "社团招新", "办得特别成功", "都说好"],
            tone: .positive, priority: 9,
            responses: [
                "太棒啦！从策划到落地肯定花了不少心思吧，能得到大家的认可，所有付出都值了，你超有组织能力的。",
                "看着自己筹备的活动热热闹闹的，成就感直接拉满。能把一件事从头到尾做好，你真的很厉害。",
            ],
            followUps: ["为了这次活动你准备了多久呀？", "有没有哪个环节你最满意？"],
            emojis: ["🎉", "✨", "💪"],
            responsesEN: [
                "Planning to applause — your effort showed.",
                "Seeing your event come alive — that's real leadership.",
            ],
            followUpsEN: ["How long did you prep?", "Favorite moment?"]
        ),
        Template(
            id: "campus_board_award",
            keywords: ["黑板报", "手抄报", "年级第一", "一等奖", "熬了两个晚自习"],
            tone: .positive, priority: 9,
            responses: [
                "恭喜呀！一笔一画熬出来的作品，拿到奖的瞬间，所有熬夜的辛苦都烟消云散了。",
                "也太厉害了吧！能从那么多作品里脱颖而出，说明你的审美和画功都超棒的，为班级争光了。",
            ],
            followUps: ["黑板报的主题是什么呀？", "有没有和同学一起分工合作？"],
            emojis: ["🏆", "✨", "😊"],
            responsesEN: [
                "Late nights on the board display — worth it when the prize lands.",
                "Standing out among so many entries — you made the class proud.",
            ],
            followUpsEN: ["What was the theme?", "Team effort?"]
        ),
        Template(
            id: "campus_cadre_praise",
            keywords: ["评优", "班长", "课代表", "特别负责", "表扬了我", "大家都投我"],
            tone: .positive, priority: 8,
            responses: [
                "你的认真和付出大家都看在眼里呢，能被全班认可，比拿什么奖都让人开心。你完全配得上这份肯定。",
                "当班委其实特别累，要两头兼顾，能得到老师和同学的双重认可，说明你真的做得特别好。",
            ],
            followUps: ["你当班委多久了呀？", "平时最让你头疼的事是什么？"],
            emojis: ["💼", "✨", "😊"],
            responsesEN: [
                "Class recognition for showing up — you earned it.",
                "Being class rep is thankless work; double praise means you're doing it right.",
            ],
            followUpsEN: ["How long in the role?", "Hardest part?"]
        ),

        // MARK: - 体育课 · 正向
        Template(
            id: "campus_pe_pass",
            keywords: ["八百米", "一千米", "体测及格", "练了半个月", "历史最好成绩"],
            tone: .positive, priority: 9,
            responses: [
                "太不容易了！那些喘不上气、腿软的瞬间都熬过来了，及格的瞬间是不是觉得连呼吸都变轻松了。",
                "恭喜通关体测大关！每天的练习都没白费，悬了好久的心终于可以落地了。",
            ],
            followUps: ["跑最后一圈的时候是不是快坚持不住了？", "及格了第一件事想干嘛？"],
            emojis: ["🏃", "🎉", "✨"],
            responsesEN: [
                "Gasping, legs shaking — then pass. That relief is real.",
                "Daily runs paid off — fitness test cleared.",
            ],
            followUpsEN: ["Last lap hardest?", "First thing after passing?"]
        ),
        Template(
            id: "campus_pe_free",
            keywords: ["自由活动", "不用跑圈", "不用做操", "体育老师心情好"],
            tone: .positive, priority: 7,
            responses: [
                "体育课自由活动简直是学生时代的顶级福利！不用跑圈不用做操，想干嘛干嘛，一节课都美滋滋的。",
                "也太幸运了吧！本来以为要累死累活跑圈，结果直接解放，这快乐来得也太突然了。",
            ],
            followUps: ["自由活动的时候你一般都玩什么呀？", "你们体育课经常跑圈吗？"],
            emojis: ["⚽", "✨", "😊"],
            responsesEN: [
                "Free PE period — no laps, pure bliss.",
                "Expected torture, got freedom — best surprise.",
            ],
            followUpsEN: ["What do you do?", "Usually lots of running?"]
        ),
        Template(
            id: "campus_sports_meet",
            keywords: ["运动会", "拿了第三名", "跳远", "全班都在喊", "班级加分"],
            tone: .positive, priority: 9,
            responses: [
                "全班为你呐喊的感觉也太热血了吧！迎着风往前跑的时候，所有的力气都好像被加满了。",
                "靠自己的努力为班级争光，这种集体荣誉感真的太棒了。站在领奖台上的时候，肯定特别骄傲吧。",
            ],
            followUps: ["比赛的时候紧张吗？", "有没有同学给你送水递纸巾？"],
            emojis: ["🏅", "✨", "🔥"],
            responsesEN: [
                "Class cheering your name at the finish — pure adrenaline.",
                "Points for the class, pride for you — worth every sprint.",
            ],
            followUpsEN: ["Nervous?", "Friends bring water?"]
        ),

        // MARK: - 校园人际 · 正向
        Template(
            id: "campus_deskmate_bond",
            keywords: ["同桌", "特别聊得来", "盼着去上学", "带小零食", "帮我讲题"],
            tone: .positive, priority: 9,
            responses: [
                "有个合拍的同桌真的是上学的一大动力！上课一起听课、下课一起唠嗑，连枯燥的课都变得有意思了。",
                "也太幸运了吧！学生时代的同桌情谊最纯粹了，互相分享零食、偷偷讲小话，都是特别珍贵的回忆。",
            ],
            followUps: ["你们平时上课会偷偷聊天吗？", "同桌最让你暖心的一件事是什么？"],
            emojis: ["📚", "💕", "✨"],
            responsesEN: [
                "A desk mate you click with — school gets easier to look forward to.",
                "Snacks, whispers, help with homework — pure school-day magic.",
            ],
            followUpsEN: ["Whisper in class?", "Sweetest thing they did?"]
        ),
        Template(
            id: "campus_anonymous_note",
            keywords: ["匿名", "小纸条", "抽屉里", "一颗糖", "怦怦跳", "鼓励纸条"],
            tone: .positive, priority: 8,
            responses: [
                "这种匿名的小温柔最让人心动了，偷偷猜是谁放的，心里又甜又好奇，一整天都忍不住想这件事。",
                "也太浪漫了吧！学生时代的好感总是藏在这些小心翼翼的细节里，青涩又美好。",
            ],
            followUps: ["你心里有没有猜到是谁呀？", "纸条上写了什么内容？"],
            emojis: ["💕", "✨", "🌸"],
            responsesEN: [
                "Anonymous note in your drawer — sweet mystery all day.",
                "Crushes hide in tiny details at this age — tender and real.",
            ],
            followUpsEN: ["Guess who?", "What did it say?"]
        ),
        Template(
            id: "campus_patient_tutor",
            keywords: ["学长", "耐心", "讲了半天", "讲了三遍", "没不耐烦"],
            tone: .positive, priority: 8,
            responses: [
                "遇到耐心又温柔的人真的像捡到宝，本来不会的题让人焦虑，被温柔讲解之后，连题目都变得可爱了。",
                "被人耐心对待的感觉真好，不会也不用怕被骂，安安心心听讲解，连学习都变开心了。",
            ],
            followUps: ["讲完之后你听懂了吗？", "你平时也会经常帮别人讲题吗？"],
            emojis: ["📚", "✨", "😊"],
            responsesEN: [
                "Patient help with a hard problem — anxiety turns into relief.",
                "Learning without fear of being judged — that's golden.",
            ],
            followUpsEN: ["Got it finally?", "Do you help others too?"]
        ),

        // MARK: - 校规 · 正向
        Template(
            id: "campus_guard_kind",
            keywords: ["忘带校卡", "保安", "直接进去了", "没记名", "好说话的门卫"],
            tone: .positive, priority: 7,
            responses: [
                "也太幸运了吧！本来慌得不行，结果被温柔放行，悬着的心一下子落地了，今天开局就走运。",
                "遇到通情达理的保安大叔也太暖了，不用挨批评、不用扣分，简直是今日份小确幸。",
            ],
            followUps: ["你经常忘带校卡吗？", "当时是不是特别紧张？"],
            emojis: ["✨", "😊", "🌿"],
            responsesEN: [
                "Forgot ID, expected trouble — kind guard saved the morning.",
                "Small mercy at the gate — lucky start to the day.",
            ],
            followUpsEN: ["Forget often?", "Were you nervous?"]
        ),
        Template(
            id: "campus_run_dismissed",
            keywords: ["跑操", "提前解散", "不用晒", "下雨天不用跑操"],
            tone: .positive, priority: 7,
            responses: [
                "少跑一圈都是赚的！大热天跑操简直是折磨，提前解散的快乐，能开心一整个上午。",
                "不用跑操也太幸福了！可以慢悠悠歇一会儿，不用满头大汗回教室，连上课都舒服多了。",
            ],
            followUps: ["你们平时要跑几圈呀？", "你最讨厌夏天跑操了吧？"],
            emojis: ["🏃", "✨", "😊"],
            responsesEN: [
                "Early dismissal from morning run — win before first period.",
                "Rain or short loop — no sweaty sprint back to class.",
            ],
            followUpsEN: ["How many laps usually?", "Hate summer runs?"]
        ),
    ]

    static let campusLifeNegative: [Template] = [
        // MARK: - 宿舍 · 负向
        Template(
            id: "campus_dorm_noise",
            keywords: ["熬夜打游戏", "开麦", "一两点", "和对象打电话", "外放", "根本睡不着"],
            tone: .negative, priority: 10,
            responses: [
                "天天睡不好真的太折磨人了，白天上课本来就累，晚上想好好休息都不行，整个人都熬得没精神。",
                "一点边界感都没有，自己熬夜还要连累别人休息，说了还不听，真的特别闹心。天天休息不好，上课都受影响。",
            ],
            followUps: ["你有没有正式跟他提过呀？", "这种情况持续多久了？"],
            emojis: ["😮‍💨", "🫂", "💙"],
            responsesEN: [
                "No sleep night after night — classes become a blur.",
                "Zero boundaries at 2 a.m. gaming or calls — exhausting and unfair.",
            ],
            followUpsEN: ["Spoken up formally?", "How long has this lasted?"]
        ),
        Template(
            id: "campus_dorm_borrow",
            keywords: ["随便用我的", "护肤品", "零食", "不跟我说", "拿去用", "还回来都坏了"],
            tone: .negative, priority: 9,
            responses: [
                "私人物品被乱动真的特别膈应，用之前说一声是最基本的尊重，次次都不打招呼，也太没分寸了。",
                "东西虽小，但不告而拿就是让人不舒服。都是住在一起的人，又不好说得太重，憋在心里又委屈。",
            ],
            followUps: ["你有当面跟他说过你介意吗？", "最让你受不了的是用什么东西？"],
            emojis: ["😤", "🫂", "💙"],
            responsesEN: [
                "Using your stuff without asking — basic respect missing.",
                "Hard to confront, easy to feel wronged when you live together.",
            ],
            followUpsEN: ["Told them you mind?", "What bothers you most?"]
        ),
        Template(
            id: "campus_dorm_isolated",
            keywords: ["宿舍", "孤立", "不叫我", "像个外人", "悄悄话", "融不进去"],
            tone: .negative, priority: 10,
            responses: [
                "住在同一个空间却被排除在外，那种格格不入的感觉真的太煎熬了，明明每天都见面，却像隔着一堵墙。",
                "抱抱你，被孤立的时候最容易自我怀疑了。但这不是你的问题，只是你们刚好合不来而已，不用勉强自己融入。",
            ],
            followUps: ["你知道是因为什么变成这样的吗？", "平时你一般都怎么打发宿舍时间？"],
            emojis: ["🫂", "💙", "😔"],
            responsesEN: [
                "Same room, different world — exclusion in your own space hurts.",
                "Not your fault if you don't fit that clique — don't force it.",
            ],
            followUpsEN: ["Know why it shifted?", "How do you pass time in the dorm?"]
        ),
        Template(
            id: "campus_dorm_deduct",
            keywords: ["连累扣分", "整个宿舍", "被子没叠", "违规用电器", "太冤"],
            tone: .negative, priority: 9,
            responses: [
                "凭什么别人的错要全宿舍一起买单啊，自己老老实实遵守规定，结果被连累挨骂，也太憋屈了。",
                "集体受罚最让人无语了，明明不是自己的问题，还要跟着受牵连，换谁都会觉得不服气。",
            ],
            followUps: ["扣分会影响评优吗？", "你室友事后有没有说抱歉？"],
            emojis: ["😤", "🫂", "💙"],
            responsesEN: [
                "Penalized for a roommate's mess — unfair group punishment.",
                "You followed rules; still got blamed — infuriating.",
            ],
            followUpsEN: ["Affect honors?", "Did they apologize?"]
        ),
        Template(
            id: "campus_dorm_clean",
            keywords: ["值日表", "只有我一个人", "垃圾桶", "没人倒", "视而不见"],
            tone: .negative, priority: 9,
            responses: [
                "都是住在一起的人，凭什么只有你一个人付出啊。公共区域大家都有责任维护，总让一个人收拾，也太不公平了。",
                "看着乱糟糟的宿舍，别人都能忍，只有你看不下去动手收拾，做完又觉得委屈，特别矛盾。",
            ],
            followUps: ["你有跟大家提过重新排值日表吗？", "最脏的地方一般是哪里？"],
            emojis: ["😮‍💨", "🫂", "💙"],
            responsesEN: [
                "Shared space, solo cleanup — that's not fair.",
                "You can't stand the mess but resent being the only one who acts.",
            ],
            followUpsEN: ["Asked to redo the roster?", "Worst spot?"]
        ),

        // MARK: - 食堂课间 · 负向
        Template(
            id: "campus_canteen_bad",
            keywords: ["排了十分钟", "卖完了", "插队", "糖醋排骨没了", "没素质"],
            tone: .negative, priority: 8,
            responses: [
                "眼巴巴排了半天，结果想吃的菜没了，期待落空的感觉也太失落了，连吃饭的心情都没了一半。",
                "插队的人真的太没规矩了，大家都在老老实实排队，凭什么他要特殊。好好的吃饭心情都被破坏了。",
            ],
            followUps: ["最后你换了什么菜吃呀？", "你当时有没有出声制止？"],
            emojis: ["😤", "🫂", "💙"],
            responsesEN: [
                "Long line, dish gone — lunch mood ruined.",
                "Cutting in line when everyone waits — rude and frustrating.",
            ],
            followUpsEN: ["What did you eat instead?", "Call them out?"]
        ),
        Template(
            id: "campus_overtime_class",
            keywords: ["拖堂", "下课铃响", "课间十分钟", "连上厕所", "名存实亡"],
            tone: .negative, priority: 9,
            responses: [
                "拖堂真的是学生党噩梦，本来就短的课间，被拖得连喝水、上厕所的时间都没有，一节课接一节课，累得喘不过气。",
                "最烦明明下课了还讲个不停，听也听不进去，休息也休息不好，两边都耽误，特别煎熬。",
            ],
            followUps: ["哪个老师最喜欢拖堂呀？", "拖堂的时候你一般在干嘛？"],
            emojis: ["😮‍💨", "🫂", "💙"],
            responsesEN: [
                "Bell rings, teacher keeps going — no bathroom, no breath.",
                "Can't listen, can't rest — worst of both.",
            ],
            followUpsEN: ["Which teacher?", "What do you do while waiting?"]
        ),
        Template(
            id: "campus_noon_noisy",
            keywords: ["午休", "吵吵闹闹", "睡不着", "挪椅子", "刚睡着就被吵醒"],
            tone: .negative, priority: 8,
            responses: [
                "午休本来就短，还被吵得没法睡，下午上课肯定昏昏沉沉的。想好好休息都不行，想想都觉得累。",
                "好不容易能歇一会儿，总被各种声音打断，刚酝酿的睡意全没了，又气又无奈。",
            ],
            followUps: ["你们午休有纪律委员管吗？", "下午上课会不会犯困？"],
            emojis: ["😮‍💨", "🫂", "💙"],
            responsesEN: [
                "Short nap ruined by noise — afternoon classes suffer.",
                "Almost asleep, then chairs scrape — maddening.",
            ],
            followUpsEN: ["Anyone enforce quiet?", "Afternoon sleepy?"]
        ),
        Template(
            id: "campus_meal_card_lost",
            keywords: ["饭卡丢了", "饭卡没钱", "充值机坏了", "没饭吃", "急死了"],
            tone: .negative, priority: 9,
            responses: [
                "饭卡丢了又急又慌，不仅吃饭成问题，里面的钱也怕被人刷走，上学都没心思了。",
                "关键时刻掉链子也太倒霉了，饿着肚子上课，连听课都没力气。先找同学借点钱垫一垫呀。",
            ],
            followUps: ["最后找到饭卡了吗？", "你饭卡里充了多少钱呀？"],
            emojis: ["😔", "🫂", "💙"],
            responsesEN: [
                "Lost meal card — panic about food and the balance.",
                "Empty stomach, broken top-up — borrow from a friend if you can.",
            ],
            followUpsEN: ["Found it?", "How much was on it?"]
        ),

        // MARK: - 班级社团 · 负向
        Template(
            id: "campus_cadre_stuck",
            keywords: ["班长", "两头不讨好", "管得不好", "嫌我事多", "纪律委员", "记名字"],
            tone: .negative, priority: 10,
            responses: [
                "夹心饼干最难受了，一边要完成老师的要求，一边要顾及同学的感受，怎么做都有人不满意，吃力又不讨好。",
                "当班委的委屈真的只有自己知道，明明是为了班级好，结果两边都落埋怨，特别寒心。",
            ],
            followUps: ["最让你委屈的是哪件事呀？", "有没有想过不当班委了？"],
            emojis: ["🫂", "💙", "😔"],
            responsesEN: [
                "Class rep between teacher and classmates — never wins.",
                "Trying to help the class, blamed from both sides — heartbreaking.",
            ],
            followUpsEN: ["What hurt most?", "Thinking of quitting?"]
        ),
        Template(
            id: "campus_group_slack",
            keywords: ["全是我一个人", "划水", "小组作业", "社团任务", "一起领功劳"],
            tone: .negative, priority: 10,
            responses: [
                "凭什么一个人干所有人的活啊，功劳还要大家一起分，付出和回报根本不对等，越想越气。",
                "最烦这种甩手掌柜了，嘴上答应得好好的，真做事的时候全不见人影，所有压力都压在你一个人身上。",
            ],
            followUps: ["你有跟他们提过分工的事吗？", "最后任务完成得怎么样？"],
            emojis: ["😤", "🫂", "💙"],
            responsesEN: [
                "All work, shared credit — rage-inducing imbalance.",
                "Promises in meetings, ghosts when it's time to deliver.",
            ],
            followUpsEN: ["Raised division of labor?", "How did it turn out?"]
        ),
        Template(
            id: "campus_duty_alone",
            keywords: ["值日", "提前跑了", "只剩我一个人", "总偷懒", "扫地倒垃圾"],
            tone: .negative, priority: 9,
            responses: [
                "凭什么大家的值日，要你一个人干完啊。别人都早早回家了，你留下来打扫卫生，想想都觉得委屈。",
                "总偷懒的人也太没责任心了，都是一个组的，凭什么你要多干那么多。下次直接跟组长反映。",
            ],
            followUps: ["你打扫了多久才弄完呀？", "这种情况经常发生吗？"],
            emojis: ["😮‍💨", "🫂", "💙"],
            responsesEN: [
                "Everyone's duty, your broom alone — unfair.",
                "Chronic slackers — tell the group leader next time.",
            ],
            followUpsEN: ["How long did cleanup take?", "Happens often?"]
        ),

        // MARK: - 体育课 · 负向
        Template(
            id: "campus_pe_fail",
            keywords: ["八百米", "一千米", "差点吐了", "没及格", "腿就软了", "走下来的"],
            tone: .negative, priority: 9,
            responses: [
                "跑的时候喘不上气、腿像灌了铅一样，那种煎熬真的太难受了。拼尽全力还没及格，肯定又累又委屈。",
                "抱抱你，体测真的是好多人的噩梦。已经拼尽全力跑完就已经很棒了，下次再练练肯定能过的。",
            ],
            followUps: ["你平时是不是很少运动呀？", "最难受的是跑第几圈的时候？"],
            emojis: ["🫂", "💙", "🏃"],
            responsesEN: [
                "Gasping, legs heavy, still fail — brutal and unfair feeling.",
                "You finished — that's already something. Practice helps next time.",
            ],
            followUpsEN: ["Rarely exercise?", "Which lap was worst?"]
        ),
        Template(
            id: "campus_pe_stolen",
            keywords: ["体育课被", "占了", "数学老师", "期待了一周", "说要考试"],
            tone: .negative, priority: 9,
            responses: [
                "期待了整整一周的快乐，说没就没了，就像心里空了一块似的。连喘口气的机会都不给，也太惨了。",
                "占课真的是学生党最崩溃的事之一，本来就少得可怜的放松时间，还要被挤压，越想越郁闷。",
            ],
            followUps: ["哪个老师最喜欢占体育课呀？", "占课一般都用来干嘛？"],
            emojis: ["😔", "🫂", "💙"],
            responsesEN: [
                "Week of looking forward to PE — gone in one math period.",
                "Stealing the rare break — crushing.",
            ],
            followUpsEN: ["Which teacher?", "Used for what?"]
        ),
        Template(
            id: "campus_pe_injury",
            keywords: ["崴脚", "拉伤", "打篮球", "肿得像馒头", "体测前"],
            tone: .negative, priority: 9,
            responses: [
                "也太不小心了，伤筋动骨最麻烦了，上课、吃饭、回宿舍都不方便，肯定特别影响生活。",
                "疼在身上，还耽误事，本来计划好的事也全泡汤了。好好养伤，别着急乱动呀。",
            ],
            followUps: ["怎么伤到的呀？", "有没有同学扶你、帮你带饭？"],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Sprained ankle — stairs, meals, everything harder.",
                "Pain plus cancelled plans — rest up, don't rush back.",
            ],
            followUpsEN: ["How did it happen?", "Friends help out?"]
        ),

        // MARK: - 校园人际 · 负向
        Template(
            id: "campus_rumor",
            keywords: ["传绯闻", "起哄", "越解释越乱", "男同学", "同桌", "特别尴尬"],
            tone: .negative, priority: 10,
            responses: [
                "被乱传绯闻真的特别尴尬，明明什么都没有，被大家起哄得好像真的有事一样，连正常相处都变得别扭。",
                "最烦这种捕风捉影的八卦了，随随便便就拿别人开玩笑，根本不顾及当事人的感受。越解释他们越起劲，别理就好了。",
            ],
            followUps: ["传得最凶的是哪些人呀？", "你和那个人平时关系怎么样？"],
            emojis: ["😔", "🫂", "💙"],
            responsesEN: [
                "Rumors make normal talk awkward — nothing happened but everyone acts like it did.",
                "Teasing gossip ignores your feelings — silence often beats over-explaining.",
            ],
            followUpsEN: ["Who spreads it most?", "How are you two usually?"]
        ),
        Template(
            id: "campus_friend_coldwar",
            keywords: ["最好的朋友", "冷战", "谁也不理谁", "同桌闹别扭", "特别尴尬"],
            tone: .negative, priority: 9,
            responses: [
                "和在乎的人冷战最熬人了，明明坐得很近，却一句话都不说，心里堵得慌，上课都听不进去。",
                "我懂这种别扭的感觉，想低头又拉不下面子，不说话又心里难受。其实只要有一个人先开口，关系就会缓和的。",
            ],
            followUps: ["是因为什么事吵起来的呀？", "你心里是不是已经不生气了？"],
            emojis: ["🫂", "💙", "💔"],
            responsesEN: [
                "Cold war with someone you care about — so close physically, so far emotionally.",
                "Pride vs hurt — one small opener can thaw things.",
            ],
            followUpsEN: ["What started it?", "Still angry inside?"]
        ),
        Template(
            id: "campus_lonely_break",
            keywords: ["独来独往", "成群结队", "插不上话", "假装看书", "特别孤单"],
            tone: .negative, priority: 9,
            responses: [
                "看着别人热热闹闹，自己却孤零零的，那种格格不入的感觉真的很难受。但不用勉强自己融入不适合的圈子呀。",
                "抱抱你，不是你不够好，只是还没遇到同频的人而已。一个人也可以很自在，慢慢就会遇到合得来的朋友的。",
            ],
            followUps: ["你是刚到这个班级吗？", "平时课间你一般都做什么？"],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Crowds laughing while you're alone — lonely but not a flaw.",
                "Not wrong, just not matched yet — your people will show up.",
            ],
            followUpsEN: ["New to the class?", "What do you do at break?"]
        ),

        // MARK: - 校规 · 负向
        Template(
            id: "campus_uniform_stain",
            keywords: ["新校服", "钢笔水", "蹭脏", "洗不掉", "一身油"],
            tone: .negative, priority: 8,
            responses: [
                "新衣服刚穿就脏了，肯定心疼坏了吧。还是校服，天天都要穿，看着脏印子就闹心。",
                "也太倒霉了，好好的新校服一下子就毁了，洗又洗不掉，穿又不舒服，特别膈应。",
            ],
            followUps: ["对方有跟你道歉吗？", "能不能洗掉呀？"],
            emojis: ["😔", "🫂", "💙"],
            responsesEN: [
                "Brand-new uniform, instant stain — daily wear makes it worse.",
                "Can't wash out — annoying every time you put it on.",
            ],
            followUpsEN: ["Did they apologize?", "Any chance to clean it?"]
        ),
        Template(
            id: "campus_id_deduct",
            keywords: ["忘带红领巾", "忘带校卡", "值周生", "扣了班级分", "迟到了"],
            tone: .negative, priority: 8,
            responses: [
                "又扣分又迟到，回去还要挨老师说，一大早的好心情全没了，也太惨了。",
                "明明人都到学校了，就因为没带卡被拦在外面，又急又无奈。一大早遇上这种事，开局就不顺。",
            ],
            followUps: ["扣了分会影响班级评优吗？", "班主任会不会说你？"],
            emojis: ["😔", "🫂", "💙"],
            responsesEN: [
                "Late, docked points, dreading homeroom — rough morning.",
                "At school but blocked at the gate — frustrating start.",
            ],
            followUpsEN: ["Hurt class ranking?", "Will teacher scold?"]
        ),
        Template(
            id: "campus_false_record",
            keywords: ["自习课", "记名", "根本没说话", "特别冤", "问了个问题"],
            tone: .negative, priority: 9,
            responses: [
                "平白无故被记名，又要挨批评又要扣量化分，明明什么都没做，背了个黑锅，也太委屈了。",
                "被冤枉的感觉真的很差，解释吧好像显得自己狡辩，不解释吧又咽不下这口气。",
            ],
            followUps: ["你跟纪律委员解释过了吗？", "老师知道这件事吗？"],
            emojis: ["😤", "🫂", "💙"],
            responsesEN: [
                "Marked for talking when you didn't — unfair penalty.",
                "Wronged and stuck — explain or swallow it, both suck.",
            ],
            followUpsEN: ["Talked to the monitor?", "Teacher know?"]
        ),
    ]
}
