import SwiftUI

/// 五大核心心情 — 大方块快选
enum MoodQuickPick {
    struct Option: Identifiable, Sendable {
        let id: String
        let label: String
        let message: String
        let emoji: String
    }

    static func core(for language: AppLanguage) -> [Option] {
        switch language {
        case .english:
            return [
                Option(id: "happy", label: "Happy", message: "I'm happy today", emoji: "😊"),
                Option(id: "okay", label: "Okay", message: "I'm okay today", emoji: "🙂"),
                Option(id: "sad", label: "Sad", message: "I'm a little sad", emoji: "😔"),
                Option(id: "weary", label: "Weary", message: "I'm so weary I can barely hold on", emoji: "😮‍💨"),
                Option(id: "tired", label: "Tired", message: "I'm so tired from today", emoji: "💤"),
                Option(id: "wronged", label: "Wronged", message: "I feel so wronged", emoji: "🥺"),
            ]
        case .chinese:
            return coreChinese
        }
    }

    static let coreChinese: [Option] = [
        Option(id: "happy", label: "开心", message: "今天很开心", emoji: "😊"),
        Option(id: "okay", label: "还行", message: "今天还行", emoji: "🙂"),
        Option(id: "sad", label: "难过", message: "我有点难过", emoji: "😔"),
        Option(id: "weary", label: "疲惫", message: "好疲惫，整个人快撑不住了", emoji: "😮‍💨"),
        Option(id: "tired", label: "劳累", message: "好累啊，今天干了很多活", emoji: "💤"),
        Option(id: "wronged", label: "委屈", message: "好委屈", emoji: "🥺"),
    ]

    static func isSelected(_ option: Option, currentText: String) -> Bool {
        currentText == option.message || currentText == option.label
    }

    static func isOkayMood(_ text: String, language: AppLanguage) -> Bool {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let option = core(for: language).first(where: { $0.id == "okay" }) else { return false }
        return trimmed == option.message || trimmed == option.label
    }
}

struct MoodQuickPickGrid: View {
    let language: AppLanguage
    let selectedText: String
    let onSelect: (MoodQuickPick.Option) -> Void

    private var options: [MoodQuickPick.Option] {
        MoodQuickPick.core(for: language)
    }

    private let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14),
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(options) { option in
                Button {
                    onSelect(option)
                } label: {
                    moodTile(option)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func moodTile(_ option: MoodQuickPick.Option) -> some View {
        let isSelected = MoodQuickPick.isSelected(option, currentText: selectedText)

        return VStack(spacing: 10) {
            Text(option.emoji)
                .font(.system(size: 32))
            Text(option.label)
                .font(.body.weight(.semibold))
                .foregroundStyle(isSelected ? .white : AppTheme.primaryText)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 108)
        .background(isSelected ? AppTheme.accentBlue : AppTheme.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(isSelected ? AppTheme.accentBlue : Color.gray.opacity(0.12), lineWidth: 1)
        )
    }
}
