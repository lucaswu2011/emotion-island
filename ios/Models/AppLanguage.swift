import Foundation

/// 根据用户输入判断对话语言（中文 / 英文）
enum AppLanguage: String, Codable, Sendable {
    case chinese
    case english

    static func detect(from text: String) -> AppLanguage {
        var cjk = 0
        var latin = 0
        for scalar in text.unicodeScalars {
            let v = scalar.value
            if (0x4E00...0x9FFF).contains(v) || (0x3400...0x4DBF).contains(v) {
                cjk += 1
            } else if scalar.properties.isAlphabetic, v < 128 {
                latin += 1
            }
        }
        if cjk > 0 { return .chinese }
        if latin > 0 { return .english }
        return .chinese
    }

    static func detect(from messages: [String]) -> AppLanguage {
        for message in messages.reversed() where !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return detect(from: message)
        }
        return .chinese
    }

    var listSeparator: String {
        switch self {
        case .chinese: "，"
        case .english: ", "
        }
    }

    var transcriptUserLabel: String {
        switch self {
        case .chinese: "我"
        case .english: "Me"
        }
    }

    var transcriptAssistantLabel: String {
        switch self {
        case .chinese: "小助手"
        case .english: "Companion"
        }
    }
}
