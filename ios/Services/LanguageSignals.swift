import Foundation

/// 中英文关键词与情境信号
enum LanguageSignals {

    static func containsAny(_ keywords: [String], in text: String) -> Bool {
        keywords.contains { text.localizedCaseInsensitiveContains($0) }
    }

    // MARK: - 态度

    static let positiveZH = [
        "开心", "高兴", "快乐", "幸福", "第一名", "第一", "满分", "100分",
        "进步", "成功", "太好了", "太棒", "真棒", "赢了", "喜悦", "考得好",
        "优异成绩", "表扬", "夸奖", "通过了", "录取", "喜", "兴奋", "超级好",
        "全班第一", "年级第一", "最高分", "破纪录", "做到了",
        "五杀", "超神", "吃鸡", "连胜", "上王者", "出金", "双黄", "满血吃鸡", "渡劫成功", "16.0", "满评",
        "升段", "升了段", "新段位", "晒晒段位", "段位涨", "终于升", "上分",
        "非洲之心", "大红", "大金", "百万撤离", "风暴龙王", "深渊满星", "三星五费",
        "ACE", "单抽出金", "凤凰蛋", "无敌战神",
        "终于好了", "终于正常", "虚惊一场", "说开了", "和解", "解开了", "见到了", "赶上了",
        "太值了", "捡漏", "赚翻了", "一次就办好", "想通了", "释怀", "超出预期", "顺利",
        "失而复得", "白捡", "挖到宝", "幸好带伞", "一路绿灯", "提前送到", "陌生人夸",
        "连续打卡", "改掉熬夜", "老家的味道", "睡了个好觉", "终于发芽", "终于更新",
    ]
    static let positiveEN = [
        "happy", "glad", "joy", "joyful", "excited", "thrilled", "first place", "top of the class",
        "number one", "#1", "perfect score", "100", "progress", "success", "passed", "won",
        "great job", "amazing", "proud", "best score", "highest score", "did it", "celebrate"
    ]

    static let negativeZH = [
        "难过", "委屈", "生气", "崩溃", "没考好", "考砸", "失败", "失望",
        "害怕", "焦虑", "偷", "骂", "吵架", "没做出来", "没发挥", "发挥失常",
        "撑不住", "绝望", "孤独", "烦", "不开心", "痛苦", "哭",
        "连跪", "掉段", "演员", "挂机", "大保底", "歪了", "落地成盒", "沉船", "460", "禁赛",
        "黑屋局", "黑屋", "炸鱼", "渡劫失败",
        "诬陷", "冤枉", "背锅", "甩锅", "打小报告", "搜包", "错怪", "栽赃", "泼脏水",
        "冷暴力", "催婚", "催生", "踩雷", "差到离谱", "气死了", "烦死了", "闹心", "搞砸", "愧疚",
        "融不进去", "提不起劲", "浑浑噩噩", "误了", "照骗", "打水漂", "拆家", "跑丢",
        "别人家", "都不够", "没吃好",
        "忘带钥匙", "白衣服", "烂尾", "断卡", "破戒", "停产", "没边界感", "好心没好报", "失眠",
        "fired", "laid off", "got fired", "lost my job", "terminated",
    ]
    static let negativeEN = [
        "sad", "upset", "angry", "mad", "breakdown", "failed", "failure", "disappointed",
        "scared", "afraid", "anxious", "stolen", "yelled", "fight", "couldn't solve",
        "underperformed", "choked", "can't take", "hopeless", "lonely", "annoyed", "unhappy", "hurt", "cry",
        "fired", "got fired", "fired by", "laid off", "lost my job", "terminated", "goddamn",
    ]

    static func positiveScore(in text: String) -> Int {
        positiveZH.filter { text.contains($0) }.count
        + positiveEN.filter { text.localizedCaseInsensitiveContains($0) }.count
    }

    static func negativeScore(in text: String) -> Int {
        negativeZH.filter { text.contains($0) }.count
        + negativeEN.filter { text.localizedCaseInsensitiveContains($0) }.count
    }

    /// 坏事转好 / 生活正向结局 — 即使带「吓死我了」等后怕词，整体仍算开心
    static let positiveResolutionZH = [
        "终于好了", "终于正常", "终于不咳", "终于见到了", "终于解", "虚惊一场",
        "说开了", "和解了", "误会解开", "赶上了", "一次就办好", "半小时就搞定",
        "会握手了", "学会用", "想通了", "释怀了", "捡漏", "太值了", "赚翻了",
        "超出预期", "没事", "检查结果正常", "复查正常", "摆脱病痛",
    ]

    static func hasPositiveResolution(_ text: String) -> Bool {
        containsAny(positiveResolutionZH, in: text)
    }

    static func suggestsBoundaryViolation(_ text: String) -> Bool {
        guard !containsAny(["拿别人", "开玩笑", "当成段子", "当段子", "说开不起玩笑"], in: text) else {
            return false
        }
        return containsAny([
            "偷拿", "偷了", "被偷", "拿走我的", "拿走", "动了我的", "拿走的", "未经允许",
            "stolen", "took my", "without asking"
        ], in: text)
    }

    static let heavyDistressZH = [
        "被炒", "炒鱿鱼", "开除", "辞退", "裁员", "被裁", "解雇", "丢了工作",
        "分手", "离婚", "去世", "没了", "确诊", "癌症", "流产",
        "家暴", "动手打", "打我", "一巴掌", "扇我", "动手了", "打我爸妈麻烦",
    ]
    static let heavyDistressEN = [
        "got fired", "fired me", "fired by", "laid off", "lost my job", "terminated",
        "got the sack", "made redundant", "boss fired", "fire me", "let me go",
        "broke up", "breakup", "passed away", "died", "diagnosed", "miscarriage",
    ]

    static func isHeavyDistressEvent(_ text: String) -> Bool {
        containsAny(heavyDistressZH, in: text) || containsAny(heavyDistressEN, in: text)
    }

    static func detectSentimentTone(in text: String) -> SentimentTone {
        if isHeavyDistressEvent(text) { return .negative }
        if hasExamFailureContext(text) { return .negative }

        let pos = positiveScore(in: text)
        let neg = negativeScore(in: text)

        if hasPositiveResolution(text), neg <= pos + 1 {
            return .positive
        }
        if pos > neg && pos > 0 { return .positive }
        if neg > pos && neg > 0 { return .negative }
        if pos > 0 && pos >= neg { return .positive }
        return .neutral
    }

    // MARK: - 疲惫

    static let exhaustionZH = [
        "好累", "很累", "累死了", "疲惫", "精疲力竭", "筋疲力尽", "累坏了", "透支", "没力气", "乏力", "累"
    ]
    static let exhaustionEN = [
        "so tired", "very tired", "exhausted", "worn out", "burned out", "burnt out",
        "drained", "no energy", "fatigued", "tired", "dead tired"
    ]

    static func expressesExhaustion(_ text: String) -> Bool {
        containsAny(exhaustionZH, in: text) || containsAny(exhaustionEN, in: text)
    }

    static let exhaustionCauseZH = [
        "因为", "加班", "熬夜", "没睡", "睡不好", "失眠", "工作", "上班", "学习", "复习",
        "考试", "带娃", "带孩", "照顾", "吵", "哭", "病", "疼", "赶", "忙", "通宵",
        "一整天", "一天", "最近", "事情", "太多", "烦", "心累", "人际", "家里",
        "很晚", "才睡", "论文", "作业", "写", "两点", "2点", "凌晨", "睁不开",
        "搬家", "收拾行李", "大扫除", "逛街", "暴走", "兼职", "快递", "扛上楼",
        "办证明", "陪诊", "找房", "看房", "通勤", "陪床", "长途", "火车", "飞机",
        "生理期", "开会", "应酬", "内耗", "纠结", "琐碎", "连轴转", "散架", "直不起腰",
        "跑腿", "办手续", "葛优瘫", "心累", "带娃", "毛孩子", "通宵", "昏昏沉沉",
    ]
    static let exhaustionCauseEN = [
        "because", "overtime", "stay up", "stayed up", "couldn't sleep", "insomnia", "work", "working",
        "study", "studying", "exam", "test", "baby", "kids", "care", "fight", "sick", "pain", "busy",
        "all day", "lately", "too much", "stress", "family", "late", "sleep", "thesis", "paper",
        "essay", "homework", "writing", "2 am", "2am", "two am", "midnight", "can't open my eyes"
    ]

    static func hasExhaustionCause(_ text: String) -> Bool {
        containsAny(exhaustionCauseZH, in: text) || containsAny(exhaustionCauseEN, in: text)
    }

    // MARK: - 考试

    static let examPainZH = ["没做出来", "没发挥", "考砸", "没考好", "发挥失常", "明明会", "考差了", "不如预期", "失利"]
    static let examPainEN = [
        "couldn't finish", "couldn't solve", "knew how", "blanked out", "failed the exam",
        "bad grade", "didn't do well", "underperformed", "choked"
    ]

    static let examFailureDetailZH = [
        "忘记", "全忘记", "全忘了", "都忘了", "没记住", "想不起来", "记不起",
        "大脑空白", "一片空白", "不会写", "写不出", "单词全", "全不会", "没写上",
    ]

    static func hasExamFailureContext(_ text: String) -> Bool {
        if containsAny(examPainZH, in: text) || containsAny(examPainEN, in: text) { return true }
        if mentionsExamSubject(text), containsAny(examFailureDetailZH, in: text) { return true }
        return false
    }

    static func isExamFailThread(accumulated: String, current: String) -> Bool {
        hasExamFailureContext(accumulated + " " + current)
    }

    // MARK: - 校园霸凌（高敏感，优先专属话术池）

    static let schoolBullyingKeywordsZH = [
        "霸凌", "被欺负", "被孤立", "起外号", "被打", "堵我", "造黄谣", "传谣言", "勒索",
        "推搡", "起哄", "排挤", "小团体", "班级群", "挂人", "网络霸凌", "黄谣",
        "不敢告诉老师", "怕报复", "被同学", "校园暴力", "隐私照", "被拍",
    ]

    static let schoolBullyingAdviceKeywordsZH = [
        "怎么办", "该怎么办", "怎么做", "该怎么做", "有什么办法", "怎么才能",
        "what should i", "what do i do", "how should i", "any advice",
    ]

    static func isSeekingAdvice(_ text: String) -> Bool {
        containsAny(schoolBullyingAdviceKeywordsZH, in: text)
    }
    static let schoolBullyingKeywordsEN = [
        "bully", "bullied", "bullying", "school bully", "isolated", "excluded", "nickname",
        "rumor", "cyberbullying", "extortion", "beaten up", "pushed me",
    ]

    static func isSchoolBullyingContext(_ text: String) -> Bool {
        containsAny(schoolBullyingKeywordsZH, in: text)
            || containsAny(schoolBullyingKeywordsEN, in: text)
    }

    static func hasExamPain(_ text: String, tone: SentimentTone) -> Bool {
        guard tone != .positive else { return false }
        return containsAny(examPainZH, in: text) || containsAny(examPainEN, in: text)
    }

    static let examSubjectZH = ["数学", "语文", "英语", "物理", "化学", "生物", "历史", "地理", "政治", "科目"]
    static let examSubjectEN = ["math", "algebra", "calculus", "english", "history", "science", "physics", "chemistry", "biology", "subject"]

    static func mentionsExamSubject(_ text: String) -> Bool {
        containsAny(examSubjectZH, in: text) || containsAny(examSubjectEN, in: text)
    }

    /// 仅当提到期末 / 期中 / 综合考试且未点明具体科目时，才追问「哪门科目」
    static let generalExamTypeZH = ["期末考试", "期末考", "期中考试", "期中考", "综合考试", "综合考"]
    static let generalExamTypeEN = ["final exam", "final exams", "finals", "midterm exam", "midterm", "mid-term", "comprehensive exam"]

    static func shouldAskWhichExamSubject(in text: String) -> Bool {
        let hasGeneral = containsAny(generalExamTypeZH, in: text)
            || containsAny(generalExamTypeEN, in: text)
        guard hasGeneral else { return false }
        return !mentionsExamSubject(text)
    }

    static func examSubjectName(from text: String, lang: AppLanguage) -> String {
        if lang == .chinese {
            return examSubjectZH.first(where: { text.contains($0) }).map { "\($0)" } ?? "那场"
        }
        return examSubjectEN.first(where: { text.localizedCaseInsensitiveContains($0) })?.capitalized ?? "that"
    }

    // MARK: - 人物 / 物品

    static let personZH = ["朋友", "同学", "老师", "父母", "妈妈", "爸爸", "他", "她", "室友", "闺蜜"]
    static let personEN = ["friend", "classmate", "teacher", "parent", "mom", "dad", "mother", "father", "roommate", "partner", "they", "he", "she"]

    static func mentionsPerson(_ text: String) -> Bool {
        containsAny(personZH, in: text) || containsAny(personEN, in: text)
    }

    static let itemZH = ["游泳包", "书包", "手机", "钱包", "东西", "物品"]
    static let itemEN = ["bag", "backpack", "phone", "wallet", "stuff", "things", "laptop"]

    static func extractItem(from text: String, lang: AppLanguage) -> String? {
        let pool = lang == .chinese ? itemZH : itemEN
        return pool.first(where: { text.localizedCaseInsensitiveContains($0) })
    }

    // MARK: - 危机

    static let crisisSevereZH = ["想死", "不想活", "活不下去", "自杀"]
    static let crisisSevereEN = ["want to die", "kill myself", "end it all", "suicide", "don't want to live"]
    static let crisisHeavyZH = ["崩溃", "撑不住", "受不了", "绝望"]
    static let crisisHeavyEN = ["breaking down", "can't take it", "can't handle", "hopeless", "falling apart"]

    // MARK: - 感谢

    static func isThanks(_ text: String) -> Bool {
        text.contains("谢谢") || text.contains("好多了")
            || text.localizedCaseInsensitiveContains("thank you")
            || text.localizedCaseInsensitiveContains("thanks")
            || text.localizedCaseInsensitiveContains("feel better")
    }

    static let emotionOnlyZH = ["委屈", "难过", "生气", "焦虑", "害怕", "失望", "累", "迷茫", "还好", "不开心", "烦", "开心", "高兴"]
    static let emotionOnlyEN = ["sad", "upset", "angry", "anxious", "scared", "disappointed", "tired", "lost", "fine", "unhappy", "happy", "glad"]

    static func isEmotionOnly(_ text: String, lang: AppLanguage) -> Bool {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let limit = lang == .english ? 24 : 8
        guard t.count <= limit else { return false }
        let pool = lang == .chinese ? emotionOnlyZH : emotionOnlyEN
        return pool.contains { lang == .chinese ? t.contains($0) : t.localizedCaseInsensitiveContains($0) }
    }

    // MARK: - 情绪 / 话题转向

    static let brighteningCuesZH = [
        "好多了", "想通了", "开心了", "高兴", "缓过来", "其实还好", "算了", "不太难过",
        "轻松", "转好", "雨过天晴", "释怀", "挺开心", "现在好了", "不过", "但是", "还好",
        "突然开心", "反而开心", "总算", "终于"
    ]
    static let brighteningCuesEN = [
        "feel better", "happier", "cheered up", "relieved", "glad", "happy now",
        "much better", "lighter now", "turned around", "finally"
    ]

    static let darkeningCuesZH = [
        "但又", "可是又", "突然又", "现在又", "又开始", "怎么又", "反而更", "又难过了",
        "又烦", "又气", "又崩", "沉下来", "又难受"
    ]
    static let darkeningCuesEN = [
        "but now", "now again", "suddenly", "again though", "got worse", "heavy again",
        "sinking again", "feels worse"
    ]

    static let topicPivotCuesZH = [
        "对了", "另外", "换个话题", "不说这个", "不说那个", "还有一件事", "顺便",
        "聊点别的", "说个事", "跟你说个", "插一句", "换个事"
    ]
    static let topicPivotCuesEN = [
        "by the way", "anyway", "change of topic", "different topic", "speaking of",
        "also wanted to", "one more thing", "let me tell you"
    ]

    static func hasBrighteningCue(_ text: String) -> Bool {
        containsAny(brighteningCuesZH, in: text) || containsAny(brighteningCuesEN, in: text)
    }

    static func hasDarkeningCue(_ text: String) -> Bool {
        containsAny(darkeningCuesZH, in: text) || containsAny(darkeningCuesEN, in: text)
    }

    static func hasTopicPivotCue(_ text: String) -> Bool {
        containsAny(topicPivotCuesZH, in: text) || containsAny(topicPivotCuesEN, in: text)
    }

    static func isMostlyEnglish(_ text: String) -> Bool {
        let letters = text.filter { $0.isLetter }
        guard !letters.isEmpty else { return false }
        let ascii = letters.filter { $0.isASCII && $0.isLetter }.count
        return Double(ascii) / Double(letters.count) > 0.6
    }
}
