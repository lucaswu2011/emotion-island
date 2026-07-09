import SwiftUI

struct LanguageSelectionView: View {
    let suggestedLanguage: AppLanguage
    let onSelect: (AppLanguage) -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                GlowingHeartIcon()

                Text("情绪岛 · Emotion Island")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppTheme.primaryText)

                Text("选择你的语言 · Choose your language")
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                    .multilineTextAlignment(.center)
            }

            Spacer().frame(height: 48)

            HStack(spacing: 20) {
                languageTile(
                    title: "中文",
                    subtitle: "简体",
                    language: .chinese
                )
                languageTile(
                    title: "English",
                    subtitle: "EN",
                    language: .english
                )
            }
            .frame(maxWidth: 420)

            Spacer()

            PrivacyFooter(
                text: "本地运行 · Runs locally · 不上云"
            )
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    private func languageTile(title: String, subtitle: String, language: AppLanguage) -> some View {
        let highlighted = suggestedLanguage == language
        return Button {
            onSelect(language)
        } label: {
            VStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(highlighted ? .white : AppTheme.primaryText)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(highlighted ? .white.opacity(0.85) : AppTheme.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 140)
            .background(highlighted ? AppTheme.accentBlue : AppTheme.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(highlighted ? AppTheme.accentBlue : Color.gray.opacity(0.12), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
