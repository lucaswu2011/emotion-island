import SwiftUI

// MARK: - 设计系统

enum AppTheme {
    static let accentBlue = Color(red: 0.0, green: 0.48, blue: 1.0)
    static let softGreen = Color(red: 0.45, green: 0.75, blue: 0.55)
    static let cardGray = Color(red: 0.97, green: 0.97, blue: 0.97)
    static let secondaryText = Color(red: 0.6, green: 0.6, blue: 0.6)
    static let primaryText = Color(red: 0.2, green: 0.2, blue: 0.2)
}

// MARK: - 隐私页脚

struct PrivacyFooter: View {
    let icon: String
    let text: String

    init(icon: String = "checkmark.circle", text: String) {
        self.icon = icon
        self.text = text
    }

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(AppTheme.secondaryText)
            Text(text)
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
        }
        .multilineTextAlignment(.center)
    }
}

// MARK: - 主按钮

struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.body.weight(.semibold))
                }
                Text(title)
                    .font(.body.weight(.semibold))
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 32)
            .padding(.vertical, 16)
            .background(AppTheme.accentBlue)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 次要按钮

struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(.body.weight(.medium))
            }
            .foregroundStyle(AppTheme.primaryText)
            .padding(.horizontal, 28)
            .padding(.vertical, 16)
            .background(Color.white)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.gray.opacity(0.3), lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 功能亮点项

struct FeatureItem: View {
    let icon: String
    let iconColor: Color
    let label: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(iconColor)
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - 助手标签

struct AssistantBadge: View {
    var language: AppLanguage = .chinese

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(AppTheme.accentBlue)
                .frame(width: 6, height: 6)
            Text(language == .english ? "Companion · on-device" : "小助手 · 本地识别")
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
        }
    }
}

// MARK: - 信息卡片

struct InfoCard: View {
    let label: String
    let value: String
    let valueColor: Color

    init(label: String, value: String, valueColor: Color = AppTheme.primaryText) {
        self.label = label
        self.value = value
        self.valueColor = valueColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(label)
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
            Spacer(minLength: 0)
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(valueColor)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 110, alignment: .topLeading)
        .background(AppTheme.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - 心形发光图标

struct GlowingHeartIcon: View {
    @State private var isPulsing = false

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: 100, height: 100)
                .shadow(color: .black.opacity(0.06), radius: 20, y: 4)

            Image(systemName: "heart.fill")
                .font(.system(size: 36))
                .foregroundStyle(.red)
                .scaleEffect(isPulsing ? 1.05 : 0.95)
                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: isPulsing)
        }
        .onAppear { isPulsing = true }
    }
}

// MARK: - 日期格式化

extension Date {
    var diaryDisplayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self) + " · 本地存储"
    }
}

enum ResponseFormatter {
    static let boldPhrases = [
        "难过也值得被温柔托住",
        "生气是理所当然的",
        "生气很正常",
        "愤怒也是一种值得被看见的情绪",
        "你的感受不需要被解释才成立",
        "委屈和烦躁也值得被看见",
        "期待落空不代表你要求太多",
        "能写下来已经很勇敢了",
        "害怕的时候不用一个人扛",
        "累了就允许自己歇一歇",
        "迷茫的时候先写下来就好",
        "你的感受很重要",
        "你的感受不需要先被「合理化」才成立",
        "被冒犯、被误解时的愤怒是真实的",
        "这种情绪值得被承认",
    ]

    static func attributed(_ text: String) -> AttributedString {
        let clean = text.replacingOccurrences(of: "**", with: "")
        var str = AttributedString(clean)
        for phrase in boldPhrases {
            if let range = str.range(of: phrase) {
                str[range].font = .subheadline.bold()
            }
        }
        return str
    }

    static func islandIconColor(for intent: EmotionIntent) -> Color {
        switch intent {
        case .anger: .orange
        case .fear: .blue
        case .joy: .pink
        case .exhaustion: .purple.opacity(0.7)
        default: AppTheme.softGreen
        }
    }
}

// MARK: - 语言切换

struct LanguageToggleBar: View {
    let current: AppLanguage
    let onSelect: (AppLanguage) -> Void

    var body: some View {
        HStack(spacing: 6) {
            toggleButton(title: "中文", language: .chinese)
            toggleButton(title: "English", language: .english)
        }
        .padding(4)
        .background(AppTheme.cardGray)
        .clipShape(Capsule())
    }

    private func toggleButton(title: String, language: AppLanguage) -> some View {
        let selected = current == language
        return Button {
            onSelect(language)
        } label: {
            Text(title)
                .font(.subheadline.weight(selected ? .semibold : .regular))
                .foregroundStyle(selected ? .white : AppTheme.secondaryText)
                .padding(.horizontal, 18)
                .padding(.vertical, 8)
                .background(selected ? AppTheme.accentBlue : Color.clear)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
