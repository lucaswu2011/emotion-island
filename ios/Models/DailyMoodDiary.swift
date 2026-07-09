import Foundation

/// 某一天上的一枚情绪贴纸（emoji + 标签）
struct MoodSticker: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let emoji: String
    let intent: EmotionIntent
    let tagLabel: String
    let tagStyle: MoodTagStyle
    let recordedAt: Date

    init(
        id: UUID = UUID(),
        emoji: String,
        intent: EmotionIntent,
        tagLabel: String,
        tagStyle: MoodTagStyle,
        recordedAt: Date = Date()
    ) {
        self.id = id
        self.emoji = emoji
        self.intent = intent
        self.tagLabel = tagLabel
        self.tagStyle = tagStyle
        self.recordedAt = recordedAt
    }
}

/// 标签配色 — 每天 2～3 枚贴纸落在不同颜色的标签上
enum MoodTagStyle: String, Codable, Sendable, CaseIterable {
    case dawn
    case noon
    case dusk
    case night
    case mint
    case blush
    case sky

    static func forSlot(index: Int, hour: Int) -> MoodTagStyle {
        let timeBased: MoodTagStyle
        switch hour {
        case 5..<12: timeBased = .dawn
        case 12..<17: timeBased = .noon
        case 17..<21: timeBased = .dusk
        default: timeBased = .night
        }
        let palette: [MoodTagStyle] = [timeBased, .mint, .blush, .sky, .noon, .dusk]
        return palette[index % palette.count]
    }
}

/// 某一天的日记页
struct DailyMoodPage: Identifiable, Sendable {
    let dayStart: Date
    var stickers: [MoodSticker]
    var snippet: String?

    var id: Date { dayStart }

    static func empty(for dayStart: Date) -> DailyMoodPage {
        DailyMoodPage(dayStart: dayStart, stickers: [], snippet: nil)
    }
}

extension EmotionIntent {
    var diaryEmoji: String {
        switch self {
        case .joy: return "😊"
        case .sadness, .maskedLoneliness: return "😢"
        case .anger: return "😤"
        case .frustration: return "😣"
        case .anxiety: return "😰"
        case .fear: return "😨"
        case .exhaustion: return "😮‍💨"
        case .disappointment: return "😞"
        case .confusion: return "😶‍🌫️"
        case .neutralMasking: return "🌿"
        case .unknown: return "📝"
        }
    }
}

enum MoodDiaryLabels {
    static func timeTag(for date: Date, slotIndex: Int, lang: AppLanguage) -> String {
        let hour = Calendar.current.component(.hour, from: date)
        if lang == .english {
            switch hour {
            case 5..<12: return slotIndex == 0 ? "Morning" : "AM"
            case 12..<17: return slotIndex == 0 ? "Afternoon" : "Midday"
            case 17..<21: return "Evening"
            default: return "Night"
            }
        }
        switch hour {
        case 5..<12: return slotIndex == 0 ? "早晨" : "上午"
        case 12..<17: return slotIndex == 0 ? "午后" : "下午"
        case 17..<21: return "傍晚"
        default: return "夜里"
        }
    }

    static func sequentialTag(index: Int, lang: AppLanguage) -> String {
        if lang == .english {
            switch index {
            case 0: return "First"
            case 1: return "Then"
            default: return "Later"
            }
        }
        switch index {
        case 0: return "先"
        case 1: return "后来"
        default: return "再然后"
        }
    }

    static func dayTitle(for dayStart: Date, lang: AppLanguage) -> String {
        let cal = Calendar.current
        if cal.isDateInToday(dayStart) {
            return lang == .english ? "Today" : "今天"
        }
        if cal.isDateInYesterday(dayStart) {
            return lang == .english ? "Yesterday" : "昨天"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = lang == .english ? Locale(identifier: "en_US") : Locale(identifier: "zh_CN")
        dateFormatter.dateFormat = lang == .english ? "MMM d" : "M月d日"
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = dateFormatter.locale
        weekdayFormatter.dateFormat = lang == .english ? "EEE" : "EEE"
        return "\(dateFormatter.string(from: dayStart)) · \(weekdayFormatter.string(from: dayStart))"
    }

    static func weekdayOnly(for dayStart: Date, lang: AppLanguage) -> String {
        let cal = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = lang == .english ? Locale(identifier: "en_US") : Locale(identifier: "zh_CN")
        formatter.dateFormat = lang == .english ? "EEE" : "EEE"
        return formatter.string(from: dayStart)
    }
}
