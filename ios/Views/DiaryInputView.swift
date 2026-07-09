import SwiftUI

struct DiaryInputView: View {
    let strings: AppStrings
    @Binding var text: String
    let onSubmit: () -> Void
    let onDemo: () -> Void

    private let maxLength = 200

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                Text(strings.diaryCaption)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)

                Text(strings.todayISay)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(AppTheme.primaryText)
            }

            Spacer().frame(height: 48)

            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(strings.diaryPlaceholder)
                        .font(.title3)
                        .foregroundStyle(Color.gray.opacity(0.35))
                        .padding(.top, 4)
                }

                TextField("", text: $text, axis: .vertical)
                    .font(.title3)
                    .foregroundStyle(AppTheme.primaryText)
                    .lineLimit(3...6)
                    .onChange(of: text) { _, newValue in
                        if newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            }
            .frame(maxWidth: 500, minHeight: 80, alignment: .topLeading)

            HStack {
                Spacer()
                Text("\(text.count) / \(maxLength)")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }
            .frame(maxWidth: 500)

            Spacer().frame(height: 32)

            VStack(spacing: 6) {
                Text(strings.diaryHint1)
                Text(strings.diaryHint2)
            }
            .font(.subheadline)
            .foregroundStyle(AppTheme.secondaryText)
            .multilineTextAlignment(.center)

            Spacer().frame(height: 32)

            VStack(spacing: 16) {
                PrimaryButton(strings.trySample, icon: "plus") {
                    text = strings.sampleSadText
                    onSubmit()
                }

                Button(strings.learnAI, action: onDemo)
                    .font(.caption)
                    .foregroundStyle(AppTheme.accentBlue)
            }

            if !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                PrimaryButton(strings.continueButton, action: onSubmit)
                    .padding(.top, 8)
            }

            Spacer()

            PrivacyFooter(
                icon: "lock.fill",
                text: strings.privacyDiary
            )
            .padding(.bottom, 32)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
