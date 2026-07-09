import Foundation

/// 学生 · 游戏 / 手机 / 社交场景话术库
extension ScenarioLibrary {

    static let studentDigitalPositive: [Template] = [
        Template(
            id: "student_voice_party",
            keywords: ["连麦", "开黑", "全班同学", "吵吵闹闹", "好朋友打了一下午", "好久没这么放松"],
            tone: .positive, priority: 9,
            responses: [
                "和熟悉的人一起玩游戏也太快乐了吧！不用顾忌什么，边玩边唠嗑，所有学习的压力都跟着散掉了。",
                "这种热热闹闹的感觉真好，比起一个人玩，和朋友并肩作战的快乐是双倍的。玩的时候是不是笑得脸都酸了？",
            ],
            followUps: ["你们今天玩的什么模式呀？", "有没有发生什么搞笑的事？"],
            emojis: ["🎮", "😊", "✨"],
            responsesEN: [
                "Gaming with people you know hits different — no filter, just laughs, and school stress melts away.",
                "Team fun beats solo every time. Bet your cheeks hurt from smiling.",
            ],
            followUpsEN: ["What mode did you play?", "Any funny moments?"]
        ),
        Template(
            id: "student_rank_skin_glory",
            keywords: ["限定皮肤", "全班就我有", "同学羡慕", "熬了一个周末", "打上王者", "太有面了", "单抽出"],
            tone: .positive, priority: 10,
            responses: [
                "也太厉害了吧！靠自己一点点打上去的段位，比什么都有成就感，在同学面前都底气十足。",
                "这是什么欧皇体质！限定皮肤抽到就是赚到，难怪大家都羡慕，这波运气和实力都拉满了。",
            ],
            followUps: ["为了上段位 / 抽皮肤花了不少心思吧？", "有没有同学找你借号玩呀？"],
            emojis: ["🏆", "🎮", "✨"],
            responsesEN: [
                "Grinding your rank up yourself — that's real pride. You earned every star.",
                "Limited skin on a single pull? Luck and skill both maxed out — no wonder classmates are jealous.",
            ],
            followUpsEN: ["How much effort did it take?", "Anyone ask to borrow your account?"]
        ),
        Template(
            id: "student_phone_learn",
            keywords: ["刷到了", "解题技巧", "听懂了", "教程", "学会了做手账", "有用的干货", "解锁新技能"],
            tone: .positive, priority: 8,
            responses: [
                "原来玩手机也不都是浪费时间呀，能无意中挖到有用的干货，还能帮到学习和爱好，这种小惊喜最棒了。",
                "太棒啦！抱着放松的心态刷手机，还顺便学会了新东西，相当于赚了双倍的快乐。",
            ],
            followUps: ["是刷到什么内容让你觉得这么有用呀？", "接下来想接着学什么？"],
            emojis: ["📱", "✨", "😊"],
            responsesEN: [
                "Screen time that actually teaches you something — best kind of surprise.",
                "Relaxed scrolling plus a new skill — double win.",
            ],
            followUpsEN: ["What did you find?", "What do you want to learn next?"]
        ),
        Template(
            id: "student_online_friend",
            keywords: ["网上认识", "同好", "喜欢的东西一模一样", "聊到凌晨", "游戏里认识", "带我上分"],
            tone: .positive, priority: 9,
            responses: [
                "遇到同频的人也太幸运了吧！现实里不好意思说的爱好，在网上能有人懂，这种感觉真的很好。",
                "隔着屏幕却能聊到一块去，这种缘分特别奇妙。有人一起分享喜欢的东西，连快乐都翻倍了。",
            ],
            followUps: ["你们是怎么认识的呀？", "平时都聊些什么话题？"],
            emojis: ["💕", "🎮", "✨"],
            responsesEN: [
                "Finding someone who gets your niche online — when it's hard to say out loud at school — feels so good.",
                "Bonding through a screen is still real. Shared interests double the joy.",
            ],
            followUpsEN: ["How did you meet?", "What do you usually talk about?"]
        ),
        Template(
            id: "student_content_fame",
            keywords: ["视频火了", "涨了好多粉", "好多人点赞", "剪的游戏视频", "日常动态", "获赞"],
            tone: .positive, priority: 9,
            responses: [
                "也太厉害了吧！自己用心做的内容被大家喜欢，这种认可比什么都让人开心，你超有才华的。",
                "恭喜呀！从默默无闻到有人喜欢，这种一点点被看见的感觉，肯定特别有成就感吧。",
            ],
            followUps: ["做这个视频 / 动态花了多久呀？", "接下来打算更什么内容？"],
            emojis: ["🎬", "✨", "😊"],
            responsesEN: [
                "Your edit blew up — that kind of recognition for work you cared about feels amazing.",
                "From quiet to noticed, step by step — that's a big deal.",
            ],
            followUpsEN: ["How long did it take to make?", "What will you post next?"]
        ),
    ]

    static let studentDigitalNegative: [Template] = [
        // MARK: - 自我内耗

        Template(
            id: "student_play_homework_guilt",
            keywords: ["玩十分钟", "一抬头半夜", "作业还没动", "只玩一局", "打了一晚上", "特别恨自己", "特别愧疚"],
            tone: .negative, priority: 10,
            responses: [
                "我懂这种事后的懊悔感，玩的时候没感觉，放下手机就开始焦虑自责，觉得自己自制力差。其实手机里的内容本来就是设计得让人停不下来，不全是你的错呀。",
                "别这么苛责自己，谁都有管不住自己的时候。比起一直内疚，不如想想下次怎么设个提醒，慢慢来就好，不用因为一次没做到就否定自己。",
            ],
            followUps: ["你是玩什么忘了时间呀？", "明天作业要交吗？"],
            emojis: ["🫂", "📱", "🌿"],
            responsesEN: [
                "That post-scroll guilt hits hard — apps are built to hook you. It's not all on you.",
                "Everyone slips sometimes. A reminder for next time beats beating yourself up.",
            ],
            followUpsEN: ["What were you playing?", "Is homework due tomorrow?"]
        ),
        Template(
            id: "student_detox_fail",
            keywords: ["发誓不玩", "又玩了一天", "特别没出息", "删了又下", "管不住自己", "没救了"],
            tone: .negative, priority: 9,
            responses: [
                "反反复复才是常态呀，哪有人说戒就能立刻戒掉的。这不是你没毅力，是手机里的诱惑本来就大，不用把自己说得这么差。",
                "不用逼自己一下子完全不玩，反而更容易反弹。不如试着一点点减少时间，比逼自己彻底戒掉容易多了。你已经在想要改变了，这就已经很棒了。",
            ],
            followUps: ["你为什么突然想戒手机呀？", "有没有试过设屏幕使用时间？"],
            emojis: ["🫂", "📱", "💙"],
            responsesEN: [
                "Relapse is normal — phones are designed to pull you back. That doesn't make you hopeless.",
                "Small cuts beat cold turkey. Wanting change already counts.",
            ],
            followUpsEN: ["Why did you want to quit?", "Tried screen-time limits?"]
        ),
        Template(
            id: "student_scroll_empty",
            keywords: ["刷了一下午", "脑子空空", "什么都没记住", "浪费时间", "不想停下来", "关掉反而更难受"],
            tone: .negative, priority: 9,
            responses: [
                "我懂这种感觉，刷的时候不用动脑，时间过得特别快，可停下来就会觉得空落落的，好像什么都没得到，还白白耗掉了时间。",
                "这不是你的问题，软件本来就是设计成让你不停往下滑的。偶尔这样放空也没关系，不用有太大负罪感，歇够了再慢慢回到状态就好。",
            ],
            followUps: ["一般刷到什么内容会让你停不下来呀？", "有没有什么事是你本来想做的？"],
            emojis: ["🫂", "📱", "🌿"],
            responsesEN: [
                "Scroll trance — fast time, empty after. The feed is built for that loop.",
                "No need for huge guilt. Rest, then ease back when you're ready.",
            ],
            followUpsEN: ["What keeps you scrolling?", "What were you planning to do instead?"]
        ),
        Template(
            id: "student_stay_up_phone",
            keywords: ["刷到两点", "上课打瞌睡", "全程打瞌睡", "熬夜玩手机", "精神差", "又后悔又慌"],
            tone: .negative, priority: 9,
            responses: [
                "晚上越玩越精神，白天上课昏昏沉沉，事后又后悔，这种恶性循环真的太磨人了。我知道你也不想这样，只是晚上的时间太像属于自己的了，舍不得睡对不对？",
                "别太焦虑了，一次没听进去补一补就好。比起一直自责，不如试试睡前把手机放远一点，慢慢调整作息就好。",
            ],
            followUps: ["一般熬夜都在玩什么呀？", "你平时几点睡比较多？"],
            emojis: ["🫂", "💤", "📱"],
            responsesEN: [
                "Night energy, morning crash, then regret — vicious cycle. Night feels like yours; hard to let go.",
                "One rough day isn't the end. Phone farther at bedtime, small steps.",
            ],
            followUpsEN: ["What do you do at night?", "What time do you usually sleep?"]
        ),
        Template(
            id: "student_grades_phone_conflict",
            keywords: ["考砸了", "玩手机太多", "忍不住", "特别矛盾", "恨死自己", "一拿起手机就放不下"],
            tone: .negative, priority: 10,
            responses: [
                "心里明明知道该学习，手却控制不住想玩手机，这种拉扯的感觉最煎熬了。你不是不想变好，只是手机的诱惑太大了，别全怪自己。",
                "其实不用非黑即白，不是学习就完全不能碰手机。可以试着学完一小段，奖励自己玩十分钟，这样既不耽误学习，也不用憋着自己。",
            ],
            followUps: ["哪门科目落下最多呀？", "你有没有试过学习的时候把手机放另一个房间？"],
            emojis: ["🫂", "📚", "📱"],
            responsesEN: [
                "Knowing you should study but reaching for the phone — that tug-of-war is exhausting. You're not failing on purpose.",
                "Try study chunks with small phone rewards instead of all-or-nothing.",
            ],
            followUpsEN: ["Which subject slipped most?", "Ever leave phone in another room?"]
        ),

        // MARK: - 亲子冲突

        Template(
            id: "student_phone_confiscated",
            keywords: ["没收手机", "抢走", "骂了我半小时", "查资料", "以为我在玩", "根本不听我解释"],
            tone: .negative, priority: 10,
            responses: [
                "明明没玩多久，甚至根本没在玩，却被不由分说地骂一顿、没收手机，肯定又委屈又生气吧。连解释的机会都不给，换谁都会觉得憋屈。",
                "被不分青红皂白地误会真的很难受，好像在他们眼里，你拿手机就一定是在玩。这种不被信任的感觉，比挨骂还让人难过。",
            ],
            followUps: ["你当时有跟他们解释吗？", "手机什么时候能还给你呀？"],
            emojis: ["🫂", "😔", "📱"],
            responsesEN: [
                "Snatched and scolded without a fair hearing — infuriating and unfair.",
                "Feeling like any phone use equals \"playing\" — trust hurts more than the yelling.",
            ],
            followUpsEN: ["Did you explain?", "When do you get it back?"]
        ),
        Template(
            id: "student_blamed_phone_grades",
            keywords: ["都是玩手机", "从来没努力过", "扯到玩手机", "做什么都是错的", "全怪手机"],
            tone: .negative, priority: 10,
            responses: [
                "努力被全盘否定的感觉真的很难受，明明你也有认真学，可他们只看得见你玩手机的样子，把所有问题都归到手机上，太不公平了。",
                "我懂这种无力感，好像不管你做什么，只要成绩不好，全都是手机的锅。他们看不到你的努力，只找得到这一个理由，特别让人委屈。",
            ],
            followUps: ["你有跟他们说过你平时的努力吗？", "这次没考好主要是什么原因呀？"],
            emojis: ["🫂", "📚", "💙"],
            responsesEN: [
                "Your effort erased because they only see the phone — that's crushing and unfair.",
                "One scapegoat for every bad grade — they miss what you actually tried.",
            ],
            followUpsEN: ["Have you told them how hard you study?", "What really hurt the score?"]
        ),
        Template(
            id: "student_privacy_invaded",
            keywords: ["偷偷翻", "翻我手机", "聊天记录", "翻我相册", "一点隐私都没有", "趁我洗澡"],
            tone: .negative, priority: 10,
            responses: [
                "自己的秘密被人随便翻看，肯定又气又难受吧。就算是爸妈，也不能随便碰别人的隐私啊，这种不被尊重的感觉，比什么都膈应。",
                "太能理解这种不爽了，手机里全是自己的小秘密，被人偷偷看了，就像房间被人闯进来翻了一遍，一点安全感都没有。",
            ],
            followUps: ["你有当面跟他们说你不高兴吗？", "他们为什么突然翻你手机呀？"],
            emojis: ["🫂", "😤", "🛡️"],
            responsesEN: [
                "Your private space read without consent — even parents shouldn't cross that line.",
                "Like someone ransacked your room — no safety left.",
            ],
            followUpsEN: ["Did you tell them you're upset?", "Why do you think they looked?"]
        ),
        Template(
            id: "student_fight_play_disorder",
            keywords: ["玩物丧志", "大吵一架", "以后没出息", "关在房间", "不懂我压力", "多玩了半小时"],
            tone: .negative, priority: 10,
            responses: [
                "本来学习压力就大，玩会儿手机放松一下，还要被骂得这么难听，肯定又委屈又心寒吧。他们只看到你在玩，却没看到你累的时候。",
                "吵架的时候说的话最伤人了，「没出息」这种话，从爸妈嘴里说出来，比谁骂都疼。你只是想歇一会儿而已，根本不是他们说的那样。",
            ],
            followUps: ["现在还在生气吗？", "平时你压力大的时候，是不是就靠玩手机放松呀？"],
            emojis: ["🫂", "💙", "🏠"],
            responsesEN: [
                "Needing a break after pressure, then hearing you'll \"amount to nothing\" — that cuts deep.",
                "They see play, not exhaustion. Words from parents land hardest.",
            ],
            followUpsEN: ["Still angry?", "Is phone your main way to unwind?"]
        ),
        Template(
            id: "student_parent_double_standard",
            keywords: ["双标", "自己刷", "不让我玩", "凭什么", "他们天天刷", "浪费时间"],
            tone: .negative, priority: 9,
            responses: [
                "确实太不公平了，同样是玩手机，他们玩就是放松，你玩就是不学好。双重标准最让人不服气了，换谁都会觉得心里不平衡。",
                "他们总说玩手机不好，可自己也放不下。道理都用来要求孩子，自己却做不到，难怪你会觉得生气又不服。",
            ],
            followUps: ["你有拿这个怼过他们吗？", "他们一般都用手机干嘛呀？"],
            emojis: ["😤", "🫂", "📱"],
            responsesEN: [
                "Rules for you, freedom for them — of course that feels unfair.",
                "Do as I say, not as I do — no wonder you're angry.",
            ],
            followUpsEN: ["Ever called them out?", "What do they use phones for?"]
        ),

        // MARK: - 社交与衍生

        Template(
            id: "student_toxic_kid",
            keywords: ["小学生", "别玩了", "队友骂", "年纪小", "全程喷我", "不是我的锅"],
            tone: .negative, priority: 9,
            responses: [
                "打游戏本来就是为了开心，凭什么要被陌生人骂啊。年纪小又不代表玩得差，这种乱喷人的人，就是自己打得不好找借口。",
                "别往心里去，网络上什么人都有，他们也就敢隔着屏幕乱骂人。你玩你的，不用因为没素质的人影响心情。",
            ],
            followUps: ["你当时怼回去了吗？", "最后这局赢了还是输了？"],
            emojis: ["🎮", "🫂", "💙"],
            responsesEN: [
                "Games should be fun — random insults say more about them than your age.",
                "Don't let keyboard warriors ruin your mood.",
            ],
            followUpsEN: ["Talk back?", "Win or lose?"]
        ),
        Template(
            id: "student_impulse_topup",
            keywords: ["脑子一热充", "充了几百", "买皮肤", "特别后悔", "忍不住抽", "零花钱", "心疼死了"],
            tone: .negative, priority: 9,
            responses: [
                "冲动消费之后都会后悔的，当时上头觉得特别想要，冷静下来就心疼钱了。没事，就当买了个教训，下次忍住就好了。",
                "我懂这种上头的感觉，喜欢的东西摆在面前，很容易就忍不住。别太自责了，又不是经常这样，偶尔一次没关系的。",
            ],
            followUps: ["充钱买了什么呀？", "是用自己的零花钱充的吗？"],
            emojis: ["😔", "🫂", "💙"],
            responsesEN: [
                "Post-impulse regret is common — heat of the moment, cold wallet after.",
                "Don't spiral — one slip isn't a character flaw.",
            ],
            followUpsEN: ["What did you buy?", "Your own allowance?"]
        ),
        Template(
            id: "student_account_destroyed",
            keywords: ["注销", "毁号", "玩了两年的", "分解", "皮肤全", "段位全没了", "快哭死了"],
            tone: .negative, priority: 11,
            responses: [
                "天呐，那可是你花了两年时间、好多心血养起来的号啊，说没就没了，肯定心都碎了。他们怎么能随便毁掉别人珍惜的东西呢。",
                "太心疼了，那里面不只是数据，还有你好多开心的回忆和付出的努力。一下子全没了，换谁都会崩溃的。",
            ],
            followUps: ["他们为什么要毁你号呀？", "有没有办法找回来？"],
            emojis: ["😔", "🫂", "💙"],
            responsesEN: [
                "Two years of progress gone — that's grief, not just a game.",
                "More than data — memories and effort erased. Anyone would break down.",
            ],
            followUpsEN: ["Why did they do it?", "Any way to recover?"],
            gentleOnly: true
        ),
        Template(
            id: "student_friends_drift",
            keywords: ["好久没出去", "关系都淡了", "总在家玩手机", "聚会都在玩手机", "没什么话聊"],
            tone: .negative, priority: 8,
            responses: [
                "手机玩多了，确实会慢慢和现实的朋友拉开距离，想想也挺失落的。明明人在一起，心却都在手机里，少了好多以前的快乐。",
                "其实不是感情淡了，是大家都习惯了低头玩手机。下次约出来的时候，试试大家都把手机收起来，说不定又能找回以前的感觉。",
            ],
            followUps: ["你和朋友多久没见面了呀？", "以前你们最喜欢一起玩什么？"],
            emojis: ["🫂", "📱", "💙"],
            responsesEN: [
                "Too much screen time can widen real-world distance — that's lonely.",
                "Maybe not less love — just less presence. Phones-down hangouts might help.",
            ],
            followUpsEN: ["How long since you met up?", "What did you used to do together?"]
        ),
        Template(
            id: "student_negative_feed",
            keywords: ["学习焦虑", "越看越慌", "哪哪都不行", "吵架", "不好的新闻", "心里闷闷的", "博眼球"],
            tone: .negative, priority: 9,
            responses: [
                "网上的信息太杂了，看多了确实容易被影响心情，本来好好的，越刷越焦虑。别全往心里去，很多内容都是故意放大焦虑博眼球的。",
                "我懂这种感觉，本来想放松一下，结果刷到糟心的内容，好心情全没了。不如退出来歇会儿，看点轻松的，别让别人的情绪影响你。",
            ],
            followUps: ["刷到什么内容让你这么在意呀？", "要不要我陪你聊点开心的？"],
            emojis: ["🫂", "📱", "🌿"],
            responsesEN: [
                "Feeds amplify anxiety on purpose — not everything you scroll is truth about you.",
                "Wanted relax, got dread — step away and breathe.",
            ],
            followUpsEN: ["What did you see?", "Want to talk about something lighter?"]
        ),
    ]
}
