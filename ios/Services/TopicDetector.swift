import Foundation

/// 对话话题识别与切换检测
enum TopicDetector {

    static func detect(in text: String) -> ConversationTopic {
        let t = text
        if containsAny(["考试", "题目", "考场", "考完", "发挥", "成绩", "答辩", "保研", "选课", "exam", "test", "grade", "score"], in: t) {
            return .exam
        }
        if containsAny([
            "诬陷", "冤枉", "背锅", "甩锅", "打小报告", "搜包", "错怪", "栽赃", "泼脏水",
            "不是我拿的", "不是我的锅", "当众骂", "说我偷", "说我拿",
            "framed", "wronged", "blamed me", "falsely accused"
        ], in: t) {
            return .falselyAccused
        }
        if LanguageSignals.suggestsBoundaryViolation(t) {
            return .boundaryViolation
        }
        if containsAny(["父母", "妈妈", "爸爸", "对象", "伴侣", "老公", "老婆", "异地恋", "催婚", "冷暴力", "家暴", "动手", "家里", "亲戚", "parent", "mom", "dad", "family", "home", "boyfriend", "girlfriend", "abuse", "hit me"], in: t) {
            return .family
        }
        if containsAny(["朋友", "同学", "老师", "吵架", "约会", "放鸽子", "friend", "classmate", "teacher", "fight", "stood me up"], in: t) {
            return .relationship
        }
        if containsAny(["猫", "狗", "宠物", "毛孩", "拆家", "寻宠", "cat", "dog", "pet"], in: t) {
            return .pet
        }
        if containsAny(["高铁", "飞机", "旅行", "民宿", "误了", "剐蹭", "追尾", "flight", "train", "travel"], in: t) {
            return .travel
        }
        if containsAny(["网购", "网上买", "网上购", "退货", "插队", "充卡", "跑路", "政务大厅", "假货", "踢皮球"], in: t) {
            return .consumption
        }
        if containsAny(["工作", "加班", "老板", "同事", "客户", "工资", "报销", "辞退", "开除", "裁员", "fired", "laid off", "work", "overtime", "boss", "job", "colleague"], in: t) {
            return .work
        }
        if containsAny(["孤独", "没人", "睡不着", "半夜", "lonely", "no one to talk", "can't sleep at night"], in: t) {
            return .loneliness
        }
        if containsAny(["生病", "头疼", "身体", "掉发", "湿疹", "痛经", "体检", "减肥", "虚惊", "sick", "headache", "health"], in: t) {
            return .health
        }
        if containsAny(["后悔", "羡慕", "差劲", "普通", "regret", "envy", "not good enough"], in: t) {
            return .selfBlame
        }
        if containsAny(["落选", "失望", "没抢到", "泡汤", "disappointed", "sold out"], in: t) {
            return .disappointment
        }
        if containsAny([
            "王者", "排位", "五杀", "吃鸡", "原神", "星穹", "抽卡", "连跪", "渡劫",
            "蛋仔", "金铲铲", "三角洲", "和平精英", "英雄联盟", "LOL", "MOBA",
            "圣遗物", "副本", "落地成盒", "460", "演员", "挂机", "超神", "巅峰赛",
            "游戏", "敌人", "击败", "击杀", "打游戏",
            "非洲之心", "大红", "大金", "哈夫币", "机密文件", "六套", "跑刀", "风暴龙王",
            "专武", "深渊", "三星五费", "老六", "非酋", "欧皇",
            "辐能", "无畏契约", "瓦", "valorant", "ACE", "第五人格", "巅七", "溜鬼", "四抓",
            "game", "ranked", "gacha", "pvp", "enemy", "enemies", "killed", "extract"
        ], in: t) {
            return .gaming
        }
        return .general
    }

    /// 用户是否明显切换到新话题
    static func hasShifted(from priorText: String, to currentText: String) -> Bool {
        let prior = priorText.trimmingCharacters(in: .whitespacesAndNewlines)
        let current = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prior.isEmpty, !current.isEmpty else { return false }

        if LanguageSignals.hasTopicPivotCue(current) { return true }

        let priorTopic = detect(in: prior)
        let currentTopic = detect(in: current)
        if priorTopic != .general, currentTopic != .general, priorTopic != currentTopic {
            return true
        }

        let threshold = LanguageSignals.isMostlyEnglish(current) ? 20 : 10
        guard current.count >= threshold else { return false }

        return domainOverlap(prior, current) < 0.12
    }

    // MARK: - Private

    private static func containsAny(_ keywords: [String], in text: String) -> Bool {
        LanguageSignals.containsAny(keywords, in: text)
    }

    private static func domainOverlap(_ a: String, _ b: String) -> Double {
        let tokensA = domainTokens(in: a)
        let tokensB = domainTokens(in: b)
        guard !tokensA.isEmpty, !tokensB.isEmpty else { return tokensA.isEmpty && tokensB.isEmpty ? 1 : 0 }
        let shared = tokensA.intersection(tokensB).count
        return Double(shared) / Double(max(tokensA.count, tokensB.count))
    }

    private static func domainTokens(in text: String) -> Set<String> {
        var found = Set<String>()
        for keywords in allDomainKeywords {
            for kw in keywords where text.localizedCaseInsensitiveContains(kw) {
                found.insert(kw.lowercased())
            }
        }
        return found
    }

    private static let allDomainKeywords: [[String]] = [
        ["考试", "题目", "成绩", "答辩", "exam", "test", "grade"],
        ["工作", "加班", "老板", "同事", "work", "boss", "job"],
        ["朋友", "同学", "吵架", "friend", "fight"],
        ["父母", "妈妈", "爸爸", "对象", "催婚", "冷暴力", "family", "mom", "dad"],
        ["猫", "狗", "宠物", "拆家", "cat", "dog", "pet"],
        ["高铁", "飞机", "旅行", "误了", "travel", "flight"],
        ["网购", "网上买", "退货", "插队", "充卡", "假货"],
        ["累", "疲惫", "tired", "exhausted"],
        ["开心", "高兴", "赢了", "happy", "glad", "won"],
        ["难过", "委屈", "生气", "sad", "upset", "angry"],
        ["奶茶", "蛋糕", "外卖", "food", "coffee", "cake"],
        ["追剧", "小说", "剧", "movie", "show", "novel"],
        ["王者", "排位", "五杀", "吃鸡", "原神", "抽卡", "连跪", "game", "ranked", "gacha"],
    ]
}
