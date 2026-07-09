import Foundation

/// 小助手回复来源：本地话术库 或 DeepSeek 大模型
enum CompanionAIProvider: String, CaseIterable, Codable, Sendable {
    case local
    case deepSeek

    static let storageKey = "companionAIProvider"

    var iconName: String {
        switch self {
        case .local: return "leaf.fill"
        case .deepSeek: return "sparkles"
        }
    }

    func displayName(language: AppLanguage) -> String {
        switch (self, language) {
        case (.local, .english): return "Local AI"
        case (.local, _): return "本地 AI"
        case (.deepSeek, .english): return "DeepSeek"
        case (.deepSeek, _): return "DeepSeek"
        }
    }

    func shortLabel(language: AppLanguage) -> String {
        switch (self, language) {
        case (.local, .english): return "Local"
        case (.local, _): return "本地"
        case (.deepSeek, _): return "DeepSeek"
        }
    }

    static func load() -> CompanionAIProvider {
        guard let raw = UserDefaults.standard.string(forKey: storageKey),
              let value = CompanionAIProvider(rawValue: raw) else {
            return .local
        }
        return value
    }

    func save() {
        UserDefaults.standard.set(rawValue, forKey: Self.storageKey)
    }
}

enum DeepSeekAPIKeyStore {
    private static let userDefaultsKey = "deepSeekAPIKey"

    /// 应用内置 DeepSeek Key — 用户选择 DeepSeek 即可直接使用
    private static let bundledDefaultKey = "sk-f6a6e8aaa24f4aa4917e8df1065a81a3"

    static var apiKey: String {
        get {
            let stored = UserDefaults.standard.string(forKey: userDefaultsKey)?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if !stored.isEmpty { return stored }
            return bundledDefaultKey
        }
        set {
            UserDefaults.standard.set(
                newValue.trimmingCharacters(in: .whitespacesAndNewlines),
                forKey: userDefaultsKey
            )
        }
    }

    static var hasKey: Bool { !apiKey.isEmpty }
}
