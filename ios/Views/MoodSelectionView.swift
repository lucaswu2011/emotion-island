import SwiftUI

struct MoodSelectionView: View {
    let strings: AppStrings
    let language: AppLanguage
    @Binding var text: String
    let analysisResult: EmotionAnalysisResult?
    let islandMessage: String
    let onAnalyze: () -> Void
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if let result = analysisResult {
                    VStack(spacing: 8) {
                        DynamicIslandPill(
                            message: islandMessage,
                            icon: result.intent.islandIcon,
                            iconColor: ResponseFormatter.islandIconColor(for: result.intent),
                            showMetadata: true,
                            metadata: result.intentLabel(for: language)
                        )
                    }
                    .padding(.top, 24)
                }

                Spacer().frame(height: 24)

                Text(strings.todayISay)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(AppTheme.primaryText)

                Spacer().frame(height: 24)

                TextField(strings.diaryPlaceholder, text: $text, axis: .vertical)
                    .font(.title3)
                    .foregroundStyle(AppTheme.primaryText)
                    .padding(24)
                    .frame(maxWidth: 560, minHeight: 120)
                    .background(AppTheme.cardGray)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .lineLimit(2...8)
                    .onChange(of: text) { _, _ in
                        onAnalyze()
                    }

                Spacer().frame(height: 28)

                VStack(alignment: .leading, spacing: 14) {
                    Text(strings.moodFeelingLabel)
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(AppTheme.secondaryText)

                    MoodQuickPickGrid(language: language, selectedText: text) { option in
                        text = option.message
                        onAnalyze()
                    }
                }
                .frame(maxWidth: 520)

                Spacer().frame(height: 32)

                if analysisResult != nil {
                    PrimaryButton(strings.moodContinueChat, icon: "bubble.left.and.bubble.right", action: onContinue)
                }

                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity)
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            onAnalyze()
        }
    }
}
