import SwiftUI

struct WelcomeView: View {
    let strings: AppStrings
    let language: AppLanguage
    let onSelectLanguage: (AppLanguage) -> Void
    let onStart: () -> Void
    let onAbout: () -> Void
    let onHistory: () -> Void
    let onFullHistory: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            LanguageToggleBar(current: language, onSelect: onSelectLanguage)
                .padding(.top, 16)

            Spacer()

            VStack(spacing: 24) {
                GlowingHeartIcon()

                Text(strings.appName)
                    .font(.system(size: 42, weight: .bold))
                    .foregroundStyle(AppTheme.primaryText)

                Text(strings.welcomeLine1)
                    .font(.title3)
                    .foregroundStyle(AppTheme.primaryText)

                Text(strings.welcomeLine2)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 480)
            }

            Spacer().frame(height: 40)

            HStack(spacing: 0) {
                FeatureItem(icon: "leaf.fill", iconColor: .red.opacity(0.8), label: strings.featureLeaf)
                FeatureItem(icon: "cpu", iconColor: AppTheme.secondaryText, label: strings.featureAI)
                FeatureItem(icon: "doc.text", iconColor: AppTheme.secondaryText, label: strings.featureLocal)
            }
            .frame(maxWidth: 520)

            Spacer().frame(height: 40)

            PrimaryButton(strings.startWriting, action: onStart)

            Spacer()

            PrivacyFooter(text: strings.privacyWelcome)
                .padding(.bottom, 24)

            HStack(spacing: 24) {
                Button(strings.moodDiary, action: onHistory)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.accentBlue)
                Button(strings.myRecords, action: onFullHistory)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                Button(strings.aboutApp, action: onAbout)
                    .font(.caption)
                    .foregroundStyle(AppTheme.accentBlue)
            }
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
