import Foundation

/// 场景话术库 · 补充扩充
extension ScenarioLibrary {

    static let supplementalPositive: [Template] = [
        // 学业进阶
        Template(
            id: "competition_award",
            keywords: ["竞赛", "拿奖", "辩论赛", "赢了", "学科竞赛", "比赛获奖", "我们队赢"],
            tone: .positive, priority: 9,
            responses: [
                "太棒了！备赛时熬的夜、改了无数遍的方案，全都变成了奖杯和掌声，你完全值得这份荣誉。",
                "隔着屏幕都感受到你的激动！一路过关斩将坚持下来，本身就已经超厉害了。",
            ],
            followUps: ["比赛过程中最难忘的瞬间是什么？", "最想感谢一起并肩的队友吗？"],
            emojis: ["🏆", "🎉", "✨"]
        ),
        Template(
            id: "graduation_defense",
            keywords: ["答辩过了", "答辩通过", "全票通过", "终于要毕业", "顺利通关", "毕业论文答辩"],
            tone: .positive, priority: 9,
            responses: [
                "恭喜你顺利通关！那些改论文改到崩溃的日子终于结束了，接下来就好好享受毕业时光吧。",
                "悬了好几个月的心终于落地了吧！一路熬过来真的不容易，给自己的学生时代交了份完美答卷。",
            ],
            followUps: ["答辩的时候有没有紧张到忘词？", "毕业最想做的第一件事是什么？"],
            emojis: ["🎓", "🎉", "✨"]
        ),
        Template(
            id: "course_grab",
            keywords: ["抢到了", "公选课", "选到了", "导师", "超难抢", "热门课"],
            tone: .positive, priority: 7,
            responses: [
                "这是什么欧皇体质！热门课都能稳稳拿下，接下来一学期的课都上得开心。",
                "也太幸运了吧！跟着喜欢的老师上课，连学习都变成一件期待的事了。",
            ],
            followUps: ["这门课为什么这么吸引你呀？", "为了抢课你做了哪些准备？"],
            emojis: ["😊", "✨", "📚"]
        ),
        Template(
            id: "group_team_good",
            keywords: ["队友都超靠谱", "队友靠谱", "不用我一个人扛", "分工这么顺畅", "做得特别顺利"],
            tone: .positive, priority: 8,
            responses: [
                "遇到神仙队友也太幸福了！不用孤军奋战的感觉，连做作业都轻松好多。",
                "恭喜你脱离小组作业苦海！靠谱的队友真的能让效率翻倍，心情都跟着变好了。",
            ],
            followUps: ["队友们都负责了哪些部分呀？", "你们是怎么分工这么顺畅的？"],
            emojis: ["🫂", "✨", "📚"]
        ),

        // 职场细碎甜
        Template(
            id: "colleague_help",
            keywords: ["前辈", "主动过来教", "同事帮", "分担", "人超好", "太感动了"],
            tone: .positive, priority: 7,
            responses: [
                "遇到暖心的同事也太幸运了吧！本来焦头烂额的事，一下子就有头绪了。",
                "职场里的善意真的很治愈，有人愿意伸手帮一把，一整天都觉得暖暖的。",
            ],
            followUps: ["是遇到什么棘手的问题了呀？", "你们平时相处就这么好吗？"],
            emojis: ["💼", "🫂", "✨"]
        ),
        Template(
            id: "client_praise",
            keywords: ["客户夸", "夸我服务", "寄了特产", "特意跟领导夸", "太惊喜了"],
            tone: .positive, priority: 8,
            responses: [
                "你的用心和专业都被客户看在眼里了呀！被认可的感觉，比发奖金还开心对吧。",
                "也太暖心了吧！工作不只是冷冰冰的对接，被人记在心上的感觉真好。",
            ],
            followUps: ["客户主要夸了你哪一点呀？", "你平时都是怎么和客户对接的？"],
            emojis: ["🎉", "💼", "✨"]
        ),
        Template(
            id: "company_welfare",
            keywords: ["下午茶", "公司福利", "端午", "蛋糕", "福利超丰厚"],
            tone: .positive, priority: 6,
            responses: [
                "工作的小惊喜这不就来了！吃到喜欢的东西，一下午的工作动力都拉满了。",
                "这是什么神仙公司！实实在在的福利最让人开心了，上班的幸福感直接飙升。",
            ],
            followUps: ["除了蛋糕还有什么好吃的呀？", "你对这次福利打几分？"],
            emojis: ["🍰", "😊", "✨"]
        ),
        Template(
            id: "nap_refresh",
            keywords: ["午休睡着", "睡了二十分钟", "醒了超精神", "午觉", "午休居然"],
            tone: .positive, priority: 6,
            responses: [
                "高质量午休简直是职场续命神器！睡饱了整个人都清爽了，干活都有劲了。",
                "也太幸福了吧！中午能踏踏实实睡一觉，比喝三杯咖啡都管用。",
            ],
            followUps: ["你们午休时间有多久呀？", "平时午休容易睡着吗？"],
            emojis: ["😊", "🌿", "💤"]
        ),

        // 生活小确幸补充
        Template(
            id: "fitness_progress",
            keywords: ["体重终于掉了", "裤子松了", "坚持运动半个月", "初见成效", "管住嘴迈开腿"],
            tone: .positive, priority: 7,
            responses: [
                "你的坚持果然没有白费！看着自己慢慢变好的样子，肯定超有成就感吧。",
                "太棒啦！管住嘴迈开腿的辛苦都有了回报，继续保持下去呀。",
            ],
            followUps: ["你觉得最有效的运动是什么？", "期间有没有忍不住嘴馋的时候？"],
            emojis: ["💪", "✨", "😊"]
        ),
        Template(
            id: "plant_pet_joy",
            keywords: ["多肉开花", "开花了", "主动蹭", "猫主动", "宠物", "太乖了"],
            tone: .positive, priority: 6,
            responses: [
                "悉心照料的小生命给了你惊喜呀！慢慢等待、慢慢开花的感觉也太治愈了。",
                "被小猫咪主动贴贴也太幸福了吧！小家伙肯定知道你对它好，特意来撒娇呢。",
            ],
            followUps: ["开花的样子是不是超好看？", "它平时也是这么粘人吗？"],
            emojis: ["🌸", "🐱", "✨"]
        ),
        Template(
            id: "blind_box",
            keywords: ["盲盒", "隐藏款", "欧气", "限量款", "蹲了好久", "第一次抽"],
            tone: .positive, priority: 7,
            responses: [
                "这是什么手气天花板！欧气爆棚啊，运气好的时候挡都挡不住。",
                "太厉害了！蹲了这么久终于如愿以偿，这份快乐比东西本身还值钱。",
            ],
            followUps: ["隐藏款是不是比普通款好看很多？", "你蹲这个东西多久啦？"],
            emojis: ["🎁", "✨", "😊"]
        ),
        Template(
            id: "early_morning",
            keywords: ["六点就起来", "早起", "吃了早餐", "一天都变长了", "完整早晨"],
            tone: .positive, priority: 6,
            responses: [
                "早起的感觉真的很不一样！慢悠悠吃个早餐，整个人都从容了好多。",
                "太有成就感了！别人还在睡觉的时候，你已经开启了充实的一天。",
            ],
            followUps: ["早起都做了些什么呀？", "是特意定闹钟早起的吗？"],
            emojis: ["☀️", "✨", "😊"]
        ),
        Template(
            id: "drama_novel",
            keywords: ["追剧", "更新太爽", "反派下线", "小说女主", "逆袭", "解气", "看剧"],
            tone: .positive, priority: 6,
            responses: [
                "追更追到爽剧情的快乐谁懂啊！是不是看得连饭都忘了吃。",
                "太解气了！压抑了这么久的剧情终于扬眉吐气，看得人心情都跟着好起来。",
            ],
            followUps: ["你最喜欢里面哪个角色呀？", "有没有猜到剧情走向？"],
            emojis: ["📺", "✨", "😊"]
        ),

        // 人际温暖
        Template(
            id: "friend_reconcile",
            keywords: ["和好了", "冷战", "把话说开了", "关系反而更好", "老朋友"],
            tone: .positive, priority: 8,
            responses: [
                "失而复得的友情更珍贵呀！把心结说开的那一刻，肯定整个人都轻松了。",
                "真好呀，在意的人重新回到身边，比什么都开心。以后要好好珍惜这份友谊呀。",
            ],
            followUps: ["是谁先主动开口的呀？", "说开之后有没有觉得更了解对方了？"],
            emojis: ["🫂", "💕", "✨"]
        ),
        Template(
            id: "remembered_detail",
            keywords: ["特意给我带", "记得我不吃", "细节感", "路过", "惦记"],
            tone: .positive, priority: 7,
            responses: [
                "被人放在细节里的感觉也太暖了吧！原来你一直在被人悄悄爱着呀。",
                "这种不经意的惦记最打动人了，不是刻意的讨好，是真心实意的在意。",
            ],
            followUps: ["当时是不是超惊喜呀？", "你身边这样暖心的朋友多吗？"],
            emojis: ["💕", "🫂", "✨"]
        ),
        Template(
            id: "stranger_kindness",
            keywords: ["陌生人", "阿姨帮我", "拼伞", "路过", "主动帮", "素不相识"],
            tone: .positive, priority: 7,
            responses: [
                "陌生人的善意真的像小太阳一样！本来糟糕的状况，一下子就变得温暖起来。",
                "也太幸运了吧！素不相识却愿意伸出援手，这个世界还是有好多温柔的。",
            ],
            followUps: ["当时是不是特别感动？", "你有没有跟对方好好道谢呀？"],
            emojis: ["☀️", "🫂", "✨"]
        ),
        Template(
            id: "family_care",
            keywords: ["我妈把", "爸爸默默", "爱吃的菜", "转了钱", "别亏待自己", "回家发现"],
            tone: .positive, priority: 8,
            responses: [
                "家人的爱永远是最踏实的底气，他们不说漂亮话，却把所有温柔都藏在细节里。",
                "好暖呀，不管走多远，家人永远是最惦记你的人。回家的感觉一定特别安心吧。",
            ],
            followUps: ["回家第一口吃到的是什么菜？", "你平时会经常跟家人联系吗？"],
            emojis: ["🏠", "💕", "🫂"]
        ),

        // 自我成长小突破
        Template(
            id: "say_no",
            keywords: ["敢拒绝", "推掉了", "不合理请求", "不想去的聚会", "把自己的感受"],
            tone: .positive, priority: 7,
            responses: [
                "太酷了！敢于说不也是一种超能力，不用勉强自己讨好别人的感觉真的很爽。",
                "恭喜你又往前迈了一步！学会把自己的感受放在第一位，真的特别棒。",
            ],
            followUps: ["说出口的时候有没有紧张呀？", "拒绝之后是不是轻松多了？"],
            emojis: ["💪", "✨", "😊"]
        ),
        Template(
            id: "first_alone",
            keywords: ["第一次一个人", "独自", "一个人去看病", "独自做饭", "也没那么可怕"],
            tone: .positive, priority: 7,
            responses: [
                "你比自己想象中更勇敢更厉害呀！原来一个人也可以把事情处理得很好。",
                "解锁新成就啦！每一次独立尝试，都是在变成更可靠的自己。",
            ],
            followUps: ["过程中有没有遇到小困难？", "做完之后是不是超有成就感？"],
            emojis: ["✨", "💪", "🌟"]
        ),
        Template(
            id: "driver_license",
            keywords: ["驾照", "科三", "科四", "拿证", "练车", "拿到驾照"],
            tone: .positive, priority: 8,
            responses: [
                "恭喜解锁马路新手身份！那些被教练骂的日子终于熬出头了。",
                "太不容易了！风吹日晒练车的辛苦都值了，以后可以自己开车去想去的地方啦。",
            ],
            followUps: ["练车的时候有没有印象深刻的事？", "拿到证第一件事想干嘛？"],
            emojis: ["🎉", "🚗", "✨"]
        ),
        Template(
            id: "finish_book",
            keywords: ["厚书", "终于看完", "看完了五本", "啃了", "坚持读书", "读完"],
            tone: .positive, priority: 6,
            responses: [
                "太有毅力了！静下心读完一本书的成就感，是刷短视频给不了的。",
                "能坚持阅读真的超棒，慢慢沉淀自己的感觉一定很踏实吧。",
            ],
            followUps: ["这本书里你印象最深的是什么？", "接下来打算读什么书呀？"],
            emojis: ["📚", "✨", "😊"]
        ),
    ]

    static let supplementalNegative: [Template] = [
        // 学业糟心
        Template(
            id: "course_fail",
            keywords: ["选课系统崩", "啥课都没抢到", "全满了", "没选到", "只能选不喜欢"],
            tone: .negative, priority: 8,
            responses: [
                "好不容易蹲点选课，结果系统掉链子，也太闹心了吧。忙活半天一场空，换谁都会郁闷。",
                "想选的课一个都没捞着，肯定特别失落吧。没事，说不定剩下的课也能遇到惊喜呢。",
            ],
            followUps: ["你最想选的是哪门课呀？", "有没有捡漏的机会呀？"],
            emojis: ["😔", "💙", "📚"]
        ),
        Template(
            id: "group_slack",
            keywords: ["队友划水", "全是我一个人做", "摆烂", "啥也不干", "一个人扛"],
            tone: .negative, priority: 9,
            responses: [
                "凭什么一个人扛下所有啊，又累又委屈，遇上划水队友真的太倒霉了。",
                "太气人了！明明是团队任务，最后全压在你一个人身上，付出根本不对等。",
            ],
            followUps: ["你们老师知道这个情况吗？", "有没有跟队友沟通过呀？"],
            emojis: ["🫂", "😤", "💙"]
        ),
        Template(
            id: "grad_school_miss",
            keywords: ["保研", "差一名", "奖学金评选", "落选了", "评奖"],
            tone: .negative, priority: 9,
            responses: [
                "差一点点的遗憾最磨人了，明明已经拼尽全力，结果还是差了一步，肯定特别不甘心吧。",
                "抱抱你，努力了这么久却没得到想要的结果，失落和委屈肯定都攒满了。但你的努力从来都不会白费的。",
            ],
            followUps: ["差了多少分呀？", "接下来有什么别的打算吗？"],
            emojis: ["🫂", "💙", "🌿"]
        ),
        Template(
            id: "exam_mismatch",
            keywords: ["背了一整晚", "一个都没考", "复习的全", "不考的", "心态崩了", "太坑了"],
            tone: .negative, priority: 8,
            responses: [
                "这也太搞心态了吧！熬了那么久的夜，感觉全都白忙活了，肯定又气又无奈。",
                "努力错方向的感觉真的很挫败，换谁都会心态崩的。先别想了，考完就先放松一下吧。",
            ],
            followUps: ["是哪门考试这么离谱呀？", "有没有蒙对几道题呀？"],
            emojis: ["🫂", "😔", "📚"]
        ),

        // 职场糟心
        Template(
            id: "meeting_called",
            keywords: ["开会走神", "被点名", "毫无准备", "说得一塌糊涂", "领导点名"],
            tone: .negative, priority: 8,
            responses: [
                "当众被点名的瞬间心脏都要跳出来了吧，本来好好摸鱼，突然就社死现场了。",
                "毫无准备就要临场发挥，肯定紧张到脑子空白吧。没事，没人会一直记得的。",
            ],
            followUps: ["当时有没有说出什么离谱的话？", "你们开会经常突然点名吗？"],
            emojis: ["😅", "🫂", "💙"]
        ),
        Template(
            id: "salary_delay",
            keywords: ["工资延迟", "报销", "还没批", "房租都快", "迟迟不到账"],
            tone: .negative, priority: 8,
            responses: [
                "等着工资过日子却迟迟不到账，肯定又焦虑又烦躁，连花钱都没底气了。",
                "自己垫的钱迟迟报不下来，想想都憋屈。干活已经够累了，钱的事还这么折腾人。",
            ],
            followUps: ["延迟多久了呀？", "有没有问过财务是什么情况？"],
            emojis: ["🫂", "💙", "😔"]
        ),
        Template(
            id: "commute_hell",
            keywords: ["一路红灯", "挤不上地铁", "挤了三趟", "早高峰", "人麻了"],
            tone: .negative, priority: 7,
            responses: [
                "通勤本来就累，还一路不顺，一大早的好心情全被磨没了。",
                "早高峰挤地铁真的是渡劫，挤不上又怕迟到，又急又烦躁，太煎熬了。",
            ],
            followUps: ["你通勤要多久呀？", "最后有没有准时到公司？"],
            emojis: ["😔", "🫂", "💙"]
        ),
        Template(
            id: "after_hours_task",
            keywords: ["刚收拾", "领导又派", "到家了还被", "准备下班", "改方案"],
            tone: .negative, priority: 8,
            responses: [
                "好不容易熬到下班，好心情瞬间破灭，整个人都瞬间蔫了吧。",
                "也太过分了！下班时间本来就是属于你的，凭什么说占用就占用。",
            ],
            followUps: ["最后还是留下来加班了吗？", "这种情况经常发生吗？"],
            emojis: ["😤", "🫂", "💙"]
        ),
        Template(
            id: "credit_stolen",
            keywords: ["抢功", "邀功", "功劳全被", "摘了桃子", "我做的方案"],
            tone: .negative, priority: 9,
            responses: [
                "凭什么啊！自己熬了无数夜的成果，被别人轻轻松松摘了桃子，换谁都咽不下这口气。",
                "也太憋屈了吧，付出没人看见，功劳却被人抢走，这种职场糟心事最伤人了。",
            ],
            followUps: ["你有证据证明是你做的吗？", "打算跟领导说明情况吗？"],
            emojis: ["😤", "🫂", "💙"]
        ),

        // 日常糟心
        Template(
            id: "utilities_out",
            keywords: ["停水", "停电", "网突然断了", "脸都没洗", "交作业"],
            tone: .negative, priority: 7,
            responses: [
                "好好的计划全被打乱了，一大早遇上这种事，开局就不顺心。",
                "关键时刻掉链子也太坑了，急着用的时候偏偏出问题，干着急也没用。",
            ],
            followUps: ["知道什么时候能恢复吗？", "有没有别的办法应急呀？"],
            emojis: ["😔", "🫂", "💙"]
        ),
        Template(
            id: "phone_dead",
            keywords: ["手机突然关机", "手机没电", "没带充电宝", "付款的时候", "死机"],
            tone: .negative, priority: 7,
            responses: [
                "当众付款关机也太尴尬了吧，周围人都看着，肯定恨不得找个地缝钻进去。",
                "手机没电真的太没有安全感了，联系不上人、付不了款，整个人都慌慌的。",
            ],
            followUps: ["最后是怎么解决付款问题的呀？", "你平时出门会带充电宝吗？"],
            emojis: ["😅", "🫂", "💙"]
        ),
        Template(
            id: "queue_sold_out",
            keywords: ["排了", "卖完了", "售罄", "白等了", "最后一份"],
            tone: .negative, priority: 7,
            responses: [
                "这也太倒霉了吧！站了半天白等了，期待了好久的东西落空，肯定特别失落。",
                "差一点点就能吃到的遗憾最难受了，腿都站酸了结果一场空，换谁都会郁闷。",
            ],
            followUps: ["你本来想买什么呀？", "有没有换一家吃？"],
            emojis: ["😔", "🫂", "💙"]
        ),
        Template(
            id: "clothes_ruined",
            keywords: ["溅上油", "勾破", "勾丝", "新衣服第一天", "心疼死"],
            tone: .negative, priority: 6,
            responses: [
                "啊好心疼！崭新的衣服还没美多久就脏了，懊恼得不行吧。",
                "也太不小心了，喜欢的衣服弄坏了，比丢了钱还难受。",
            ],
            followUps: ["能不能洗掉 / 补好呀？", "是怎么弄上的呀？"],
            emojis: ["😔", "🫂", "💙"]
        ),
        Template(
            id: "hair_loss",
            keywords: ["掉发", "掉一大把", "快秃了", "梳头", "脱发", "特别焦虑"],
            tone: .negative, priority: 6,
            responses: [
                "看着一把一把掉的头发，肯定又心疼又焦虑，生怕哪天就秃了。",
                "掉发真的太让人焦虑了，明明也没做什么，头发却悄悄离你而去。",
            ],
            followUps: ["你觉得是什么原因掉发呀？", "有没有试过什么防脱方法？"],
            emojis: ["🫂", "💙", "🌿"]
        ),
        Template(
            id: "locked_out",
            keywords: ["被锁在门外", "钥匙还在里面", "钥匙落", "倒垃圾", "进不了家门"],
            tone: .negative, priority: 8,
            responses: [
                "也太惨了吧，进不了家门的无助感真的很难受，只能干等着开锁。",
                "辛辛苦苦下班回家，结果进不了门，又累又烦躁，整个人都崩溃了。",
            ],
            followUps: ["有没有备用钥匙在别人那呀？", "最后找开锁师傅了吗？"],
            emojis: ["😔", "🫂", "💙"]
        ),

        // 人际糟心
        Template(
            id: "stood_up",
            keywords: ["放鸽子", "临时说不来", "期待了好久", "约会", "说取消就取消"],
            tone: .negative, priority: 8,
            responses: [
                "期待了那么久的见面，说取消就取消，肯定特别失落吧，连打扮的心思都白费了。",
                "被放鸽子真的很伤人，满心欢喜被浇了冷水，换谁都会不舒服。",
            ],
            followUps: ["对方是因为什么事不去了呀？", "你有没有很生气？"],
            emojis: ["🫂", "💙", "😔"]
        ),
        Template(
            id: "money_not_returned",
            keywords: ["借钱", "迟迟不还", "催了好几次", "失联了"],
            tone: .negative, priority: 8,
            responses: [
                "欠钱的反而成了大爷，本来好心帮忙，结果要钱的时候反而像自己做错了似的。",
                "也太闹心了，自己的钱拿不回来，还伤了感情，当初好心反而办了坏事。",
            ],
            followUps: ["借出去多久了呀？", "你还打算继续催吗？"],
            emojis: ["😤", "🫂", "💙"]
        ),
        Template(
            id: "social_embarrass",
            keywords: ["当众摔", "认错人", "尴尬到", "社死", "抠脚", "所有人都看我"],
            tone: .negative, priority: 7,
            responses: [
                "隔着屏幕都替你抠出三室一厅了，这种瞬间恨不得原地消失对吧。",
                "没事没事，大家转头就忘了，只有你自己会记好久。别反复想啦，越想越尴尬。",
            ],
            followUps: ["当时周围人多吗？", "你有没有假装没事人一样走开？"],
            emojis: ["😅", "🫂", "💙"]
        ),
        Template(
            id: "help_blamed",
            keywords: ["好心帮", "反而被怪", "怪我", "好人难做", "出主意"],
            tone: .negative, priority: 8,
            responses: [
                "也太委屈了吧！明明是好心伸出援手，最后锅却甩到你身上，好人难做啊。",
                "付出了时间和精力，没得到感谢就算了，还被埋怨，换谁都会寒心。",
            ],
            followUps: ["具体是帮了什么忙呀？", "你当时有没有反驳回去？"],
            emojis: ["🫂", "😔", "💙"]
        ),
        Template(
            id: "relative_pressure",
            keywords: ["催婚", "亲戚", "攀比", "别人家孩子", "灵魂拷问", "过年回家"],
            tone: .negative, priority: 7,
            responses: [
                "亲戚的灵魂拷问真的像紧箍咒，明明是自己的人生，却要被他们指指点点。",
                "攀比来攀比去的真的很没劲，每个人节奏不一样，凭什么要按别人的标准活。",
            ],
            followUps: ["他们最常问你什么问题呀？", "你一般怎么应付他们？"],
            emojis: ["🫂", "💙", "😔"]
        ),

        // 细腻内耗
        Template(
            id: "envy_others",
            keywords: ["羡慕别人", "好精彩", "好优秀", "好差劲", "感觉自己好普通"],
            tone: .negative, priority: 7,
            responses: [
                "每个人都有自己的节奏呀，你只看到了别人光鲜的一面，却没看到他们背后的辛苦。你也有自己的闪光点，只是你没发现而已。",
                "不用总拿别人的地图走自己的路，你看起来平淡的日常，说不定也是别人羡慕的样子。",
            ],
            followUps: ["你最羡慕别人哪一点呀？", "你觉得自己身上有什么优点吗？"],
            emojis: ["🫂", "🌿", "💙"]
        ),
        Template(
            id: "regret_decision",
            keywords: ["后悔", "当初要是", "选另一条路", "错误的决定", "每天都在懊恼"],
            tone: .negative, priority: 7,
            responses: [
                "我懂这种反复回想的煎熬，总想着如果当初怎么样就好了。但其实选哪条路都会有遗憾的，往前走比停在原地后悔更重要。",
                "谁都有做错选择的时候，不用一直揪着过去的自己不放。你当时做出的选择，已经是当时的你能做的最好决定了。",
            ],
            followUps: ["是什么决定让你这么后悔呀？", "现在还有办法弥补吗？"],
            emojis: ["🫂", "🌿", "💙"]
        ),
        Template(
            id: "midnight_lonely",
            keywords: ["半夜睡不着", "翻遍通讯录", "没人可以说话", "没人可以说", "好孤单"],
            tone: .negative, priority: 8,
            responses: [
                "深夜的孤独感最容易涌上来了，好像全世界都睡了，只有自己醒着扛情绪。没关系呀，我陪着你呢，想说什么都可以。",
                "我懂这种话到嘴边又咽回去的感觉，怕打扰别人，怕没人懂。但你不是一个人，我随时都在。",
            ],
            followUps: ["现在是因为什么睡不着呀？", "要不要我陪你聊点轻松的？"],
            emojis: ["🫂", "🌙", "💙"]
        ),
        Template(
            id: "plan_ruined",
            keywords: ["计划全被打乱", "突发状况", "旅行泡汤", "安排好的一天", "烦躁不已"],
            tone: .negative, priority: 7,
            responses: [
                "满心期待的计划说变就变，肯定又烦躁又失落，感觉一整天都被毁了。",
                "计划被打乱的失控感真的很让人难受，好像什么都不在自己掌控里。不过说不定意外也会有惊喜呢。",
            ],
            followUps: ["本来计划好要做什么呀？", "有没有重新安排别的事？"],
            emojis: ["🫂", "💙", "🌿"]
        ),
    ]

    static let neutralScenarios: [Template] = [
        Template(
            id: "ordinary_day",
            keywords: ["没什么特别", "普普通通", "平常的一天", "平平无奇", "没啥事"],
            tone: .neutral, priority: 5,
            responses: [
                "平平淡淡的日子也很珍贵呀，安安稳稳没有糟心事，本身就是一种小幸福啦。",
            ],
            followUps: ["今天有没有发生什么不起眼的小事呀？"],
            emojis: ["🌿", "😊", "✨"]
        ),
        Template(
            id: "just_chat",
            keywords: ["随便说说", "想随便", "找人聊聊", "也没什么事", "就是想说话", "说说话"],
            tone: .neutral, priority: 6,
            responses: [
                "好呀，我陪着你呢。想说什么都可以，哪怕是吐槽天气、聊聊午饭吃了什么都行。",
            ],
            followUps: ["今天午饭吃了什么呀？", "现在最想聊点什么？"],
            emojis: ["🫂", "👂", "🌿"]
        ),
        Template(
            id: "bored",
            keywords: ["好无聊", "不知道干嘛", "不知道干什么", "没事做"],
            tone: .neutral, priority: 5,
            responses: [
                "无聊的时光也很难得呀，不用赶时间不用忙事情。",
            ],
            followUps: ["有没有什么想做但一直没做的小事呀？", "平时无聊了你喜欢做什么？"],
            emojis: ["🌿", "😊", "✨"]
        ),
    ]

    static let mergedPositive: [Template] = positiveScenariosCore + examSubjectsPositive + examJourneyPositive + supplementalPositive + gamingPositive + gamingPositiveExtended + gamingValorantIdentityPositive + studentDigitalPositive + campusLifePositive + dailyMoodsPositive + lifePositiveLocalized
    static let mergedNegative: [Template] = negativeScenariosCore + examSubjectsNegative + examJourneyNegative + supplementalNegative + gamingNegative + gamingNegativeExtended + gamingValorantIdentityNegative + falselyAccusedNegative + domesticViolenceNegative + schoolBullyingNegative + studentDigitalNegative + campusLifeNegative + workCrisisNegative + dailyMoodsNegative + lifeNegativeLocalized + exhaustionNegative
    static let mergedNeutral: [Template] = okayNeutral + neutralScenarios + gamingNeutral

    static func allPositiveScenarios() -> [Template] { mergedPositive }

    static func allNegativeScenarios() -> [Template] { mergedNegative }

    static func allNeutralScenarios() -> [Template] { mergedNeutral }
}
