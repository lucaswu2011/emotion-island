import Foundation

/// 游戏语境识别 — 区分「提到游戏」与「说清是哪款游戏」
enum GameSignals {

    static let gamingContextZH = [
        "游戏", "游戏里", "打游戏", "玩游戏", "上线", "这局", "那局", "上一局",
        "队友", "敌人", "击败", "击杀", "人头", "排位", "上分", "掉分", "连跪",
        "副本", "抽卡", "出金", "圣遗物", "装备", "段位", "星", "吃鸡",
        "五杀", "超神", "MVP", "mvp", "渡劫", "演员", "挂机", "460",
        "落地成盒", "摸金", "撤离", "肝", "卡池", "保底", "歪了", "沉船",
        "出了", "摸到", "出货", "肥", "非酋", "欧皇",
        "连麦", "开黑", "限定皮肤", "刷短视频", "涨粉", "没收手机", "毁号",
        "卧谈", "体测", "黑板报", "宿舍", "饭卡", "跑操", "拖堂",
    ]

    static let gamingContextEN = [
        "game", "gaming", "match", "ranked", "teammate", "enemy", "enemies",
        "killed", "kill", "mvp", "carry", "gacha", "pity", "rank", "lobby",
        "squad", "clutch", "tilted", "noob", "afk", "toxic", "extract", "loot",
    ]

    /// 游戏黑话 / 专属道具 — 一听就知道在玩什么，无需再问「哪款游戏」
    static let gameSlangZH = [
        // 三角洲 / 暗区撤离类
        "非洲之心", "非洲心", "大红", "大金", "小金", "机密文件", "哈夫币", "六套", "五套", "四套",
        "跑刀", "撤离点", "长弓溪谷", "零号大坝", "巴克什", "航天基地", "猛攻", "凑战备",
        // MOBA
        "风暴龙王", "风暴龙", "暴君", "主宰", "峡谷", "扣6", "扣 6", "巅峰赛", "星耀", "钻石段",
        // 吃鸡 / 战术射击
        "老六", "KD", "落地成盒", "决赛圈", "王牌", "战神榜",
        // 原神 / 星铁
        "原石", "专武", "满精", "满命", "双黄", "大保底", "小保底", "深渊", "混沌回忆", "遗器",
        "双爆", "胚子", "35分", "圣遗物",
        // 金铲铲 / 蛋仔
        "三星五费", "德莱文", "凤凰蛋", "恐龙蛋", "鹅蛋", "锁血", "D出来", "卡池",
        "单抽出金", "无敌战神", "百万撤离", "黑屋局", "渡劫失败", "掉段",
        // 无畏契约 / 瓦
        "辐能战魂", "辐能", "不朽", "辐能渡劫", "ACE", "clutch", "守包", "peek", "鬼魅", "警长",
        // 第五人格
        "巅七", "巅峰七阶", "六阶", "溜鬼", "四跑", "四抓", "地窖", "震慑", "认知分", "牌子",
        "人皇", "屠皇", "修机", "压机", "秒倒", "红网", "鞭尸", "佛转魔",
    ]

    static let specificGameNames = [
        "王者荣耀", "王者", "英雄联盟", "LOL", "lol", "League",
        "和平精英", "PUBG", "pubg",
        "三角洲", "三角洲行动", "打洲", "暗区", "暗区突围",
        "无畏契约", "瓦罗兰特", "Valorant", "valorant", "瓦", "打瓦",
        "第五人格", "Identity V",
        "蛋仔", "蛋仔派对", "金铲铲", "云顶",
        "原神", "星穹", "崩铁", "星穹铁道", "铁道",
        "DNF", "地下城", "梦幻西游", "逆水寒", "永劫", "CS", "CSGO", "csgo",
        "守望", "炉石", "Steam", "steam", "Switch", "PS5", "Xbox",
        "明日方舟", "碧蓝", "阴阳师", "第五人格", "光遇", "minecraft", "我的世界",
    ]

    static func hasGamingContext(_ text: String) -> Bool {
        if LanguageSignals.containsAny(gameSlangZH, in: text) { return true }
        if LanguageSignals.containsAny(gamingContextZH, in: text) { return true }
        if LanguageSignals.containsAny(gamingContextEN, in: text) { return true }
        return TopicDetector.detect(in: text) == .gaming
    }

    static func mentionsSpecificGame(in text: String) -> Bool {
        if LanguageSignals.containsAny(specificGameNames, in: text) { return true }
        if LanguageSignals.containsAny(gameSlangZH, in: text) { return true }
        return false
    }

    static func shouldAskGameTitle(
        currentText: String,
        session: ConversationSession,
        usedKeys: Set<String>
    ) -> Bool {
        shouldAskGameTitle(
            currentText: currentText,
            priorUserTexts: session.messages.filter { $0.role == .user }.map(\.text),
            usedKeys: usedKeys
        )
    }

    static func shouldAskGameTitle(
        currentText: String,
        priorUserTexts: [String],
        usedKeys: Set<String>
    ) -> Bool {
        guard !usedKeys.contains("game_ask_title") else { return false }
        guard hasGamingContext(currentText) else { return false }
        // 只说「打算 / 准备去打」等计划，还没真正开玩 — 不追问哪款游戏
        if isGamingIntentOnly(currentText) { return false }

        let allUserText = (priorUserTexts + [currentText]).joined(separator: " ")
        if mentionsSpecificGame(in: allUserText) { return false }

        return true
    }

    /// 仅表达「要去 / 打算玩」而非已发生的对局
    static func isGamingIntentOnly(_ text: String) -> Bool {
        guard hasGamingContext(text) else { return false }
        let futureIntent = [
            "打算", "准备", "想去", "要去", "计划", "想打", "想玩", "一会打", "等会打",
            "今晚打", "今天要打", "回头打", "打完再", "奖励自己", "庆祝",
            "going to play", "plan to play", "want to play", "gonna play",
        ]
        let pastOrResult = [
            "打了", "玩了", "刚打", "刚玩", "连跪", "连胜", "五杀", "超神", "吃鸡", "赢了", "输了",
            "上王者", "出金", "ACE", "这局", "那局", "上一局", "一局", "打了好久", "玩了一下午",
            "played", "just played", "won", "lost", "clutch", "mvp",
        ]
        let hasFuture = LanguageSignals.containsAny(futureIntent, in: text)
        let hasResult = LanguageSignals.containsAny(pastOrResult, in: text)
        return hasFuture && !hasResult
    }

    /// 用户已描述具体战绩 / 爽点 — 才可用偏兴奋的接话
    static func hasGamingAchievementContext(_ text: String) -> Bool {
        LanguageSignals.containsAny([
            "五杀", "超神", "吃鸡", "连胜", "上王者", "出金", "ACE", "mvp", "MVP",
            "carry", "clutch", "高光", "大杀", "赢了", "上分", "渡劫成功", "非洲之心",
            "太帅", "好爽", "上头", "厉害死了", "秀",
        ], in: text)
    }

    // MARK: - 升段 / 冲分语境

    static let rankUpKeywordsZH = [
        "升段", "升了段", "段位涨", "新段位", "晒晒段位", "晒段位", "看看段位", "我的段位",
        "上分了", "冲段", "升大段", "打上王者", "上王者", "上星耀", "晋级成功", "渡劫成功",
        "终于升", "段位到手",
    ]

    static let gachaDistressKeywordsZH = [
        "大保底歪", "保底歪", "沉船", "抽卡沉", "原石全没", "歪了常驻", "武器池歪", "大保底还歪",
        "吃保底", "没出货", "定轨了", "抽卡好难受", "抽卡沉船",
    ]

    static func isRankUpThread(_ text: String) -> Bool {
        LanguageSignals.containsAny(rankUpKeywordsZH, in: text)
    }

    static func hasGachaDistress(_ text: String) -> Bool {
        LanguageSignals.containsAny(gachaDistressKeywordsZH, in: text)
            || (text.contains("保底") && (text.contains("歪") || text.contains("沉")))
    }

    static func isRankGrindDurationAnswer(_ text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count <= 18 else { return false }

        let durationMarkers = [
            "一天", "两天", "俩天", "三天", "四天", "五天", "六天", "七天", "一周", "两周",
            "几小时", "半天", "一晚", "一宿", "整个周末", "一个周末", "一下午", "一上午", "一整晚",
        ]
        let grindVerbs = ["冲了", "打了", "练了", "熬了", "肝了", "花了", "用了", "整整", "大概", "差不多"]
        let hasDuration = durationMarkers.contains { trimmed.contains($0) }
        let hasGrind = grindVerbs.contains { trimmed.contains($0) }
        return hasDuration && (hasGrind || trimmed.contains("才") || trimmed.contains("就"))
    }

    static func assistantAskedRankGrind(in assistantTexts: [String]) -> Bool {
        guard let last = assistantTexts.last else { return false }
        return last.contains("冲了多久") || last.contains("打了多久") || last.contains("冲了多长")
            || (last.localizedCaseInsensitiveContains("how long") && last.localizedCaseInsensitiveContains("rank"))
    }

    static func recentUserStory(from session: ConversationSession) -> String {
        let userTexts = session.messages.filter { $0.role == .user }.map(\.text)
        return userTexts.suffix(2).joined(separator: session.userLanguage.listSeparator)
    }

    static func isRankGrindFollowUp(currentText: String, session: ConversationSession) -> Bool {
        guard isRankGrindDurationAnswer(currentText) else { return false }

        if isRankUpThread(recentUserStory(from: session)) { return true }

        let assistantTexts = session.messages.filter { $0.role == .assistant }.map(\.text)
        if assistantAskedRankGrind(in: assistantTexts) { return true }

        return session.usedReplyKeys.contains { $0.contains("game_show_rank") }
    }

    static func shouldSuppressNegativeGamingScenario(
        id: String,
        accumulated: String,
        current: String
    ) -> Bool {
        let recent = accumulated + " " + current
        guard isRankUpThread(recent) else { return false }
        guard !hasGachaDistress(current) else { return false }

        let gachaLike = id.contains("gacha") || id.contains("enhance_fail") || id.contains("weapon")
        guard gachaLike else { return false }

        if isRankGrindDurationAnswer(current) { return true }
        if isRankUpThread(current) && !hasGachaDistress(current) { return true }
        return false
    }
}
