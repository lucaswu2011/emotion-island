import Foundation

/// 「还行」模块 — 平平淡淡、不好不坏的中性平稳状态识别
enum OkayMoodSignals {

    static let okayKeywordsZH = [
        // 核心词
        "还行", "还行吧", "就那样", "就那样呗", "老样子", "马马虎虎", "一般般", "凑合",
        "不好不坏", "普普通通", "平平淡淡", "平平常常", "过得去", "凑活", "凑活过",
        // 日常状态
        "没啥大事", "没什么特别", "说不上好", "说不上坏", "按部就班", "平平稳稳",
        "也就那样", "还能怎么样", "还能离咋地", "正常过日子", "日子照常",
        "没什么波澜", "老样子呗", "今天过得还行", "正常上学", "正常上班",
        "一天就这么过去", "没什么好说的", "说不上好也说不上坏",
        // 事件结果
        "不好也不差", "面试感觉一般", "效果马马虎虎", "凑合能穿", "应该能及格",
        "打了个平手", "没出错也没什么亮点", "勉强够精神", "正常水平",
        "不算好看也不算难看", "不惊艳也不难吃",
        // 闲散无聊
        "闲了一天", "没什么安排", "混了一天", "摸鱼", "发呆发了",
        "有点无聊但也还行", "没什么意思也不算难受", "没什么想做的",
        // 情绪体感
        "心情就那样", "情绪平平", "说不上快乐", "说不上难过", "没什么开心",
        "没什么烦心", "身体还行", "心里空空", "淡淡的", "没什么情绪波动",
        "有点累但也还好", "也没特别有精神",
        // 随口应答
        "一般般吧", "不怎么样也不糟糕",
        // 轻微波折
        "整体还行", "也算还行", "都解决了", "刚好赶上", "没迟到", "慢慢写也能写完",
        "不算特别糟", "不算难熬", "不算特别熬人",
    ]

    static let okayKeywordsEN = [
        "i'm okay", "im okay", "just okay", "so-so", "so so", "nothing special",
        "same as usual", "nothing much", "not bad", "not great", "mediocre",
        "ordinary day", "pretty average", "just getting by", "meh", "it's fine",
    ]

    static let negativeBlockersZH = [
        "很难过", "好难过", "崩溃", "烦死了", "气死了", "糟心", "绝望", "不想活",
        "家暴", "打我", "霸凌", "委屈", "哭", "好烦", "太难受", "撑不住",
        "太开心了", "好开心", "气死了", "破防",
    ]

    static func isOkayMood(_ text: String, language: AppLanguage) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        if MoodQuickPick.isOkayMood(trimmed, language: language) { return true }

        if LanguageSignals.containsAny(negativeBlockersZH, in: trimmed) { return false }
        if LanguageSignals.isHeavyDistressEvent(trimmed) { return false }

        let tone = LanguageSignals.detectSentimentTone(in: trimmed)
        if tone == .negative && !containsOkayCue(in: trimmed, language: language) { return false }
        if tone == .positive && !containsOkayCue(in: trimmed, language: language) { return false }

        return containsOkayCue(in: trimmed, language: language)
    }

    private static func containsOkayCue(in text: String, language: AppLanguage) -> Bool {
        let zh = LanguageSignals.containsAny(okayKeywordsZH, in: text)
        if language == .chinese { return zh }
        return zh || LanguageSignals.containsAny(okayKeywordsEN, in: text)
    }
}
