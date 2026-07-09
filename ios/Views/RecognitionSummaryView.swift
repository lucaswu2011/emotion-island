import SwiftUI

struct RecognitionSummaryView: View {
    let strings: AppStrings
    let language: AppLanguage
    let result: EmotionAnalysisResult
    let detailedResponse: String
    let onBack: () -> Void
    let onSave: () -> Void

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                VStack(spacing: 16) {
                    AssistantBadge(language: language)

                    Text(ResponseFormatter.attributed(detailedResponse))
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.primaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .frame(maxWidth: 520)

                    Circle()
                        .fill(AppTheme.primaryText)
                        .frame(width: 4, height: 4)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text(strings.summaryCaughtMoment)
                        .font(.headline)
                        .foregroundStyle(AppTheme.primaryText)

                    LazyVGrid(columns: columns, spacing: 16) {
                        InfoCard(
                            label: strings.summaryEmotion,
                            value: result.intent.recognizedEmotions(for: language),
                            valueColor: AppTheme.accentBlue
                        )
                        InfoCard(
                            label: strings.summaryTriggers,
                            value: result.triggerWordsDisplay
                        )
                        InfoCard(
                            label: strings.summaryResponseStyle,
                            value: result.intent.animationDescription(for: language)
                        )
                        InfoCard(
                            label: strings.summaryStorage,
                            value: strings.summaryStorageValue
                        )
                    }
                }
                .frame(maxWidth: 600)

                HStack(spacing: 16) {
                    SecondaryButton(strings.backToDiary, icon: "arrow.left", action: onBack)
                    PrimaryButton(strings.saveRecord, icon: "checkmark", action: onSave)
                }
                .padding(.top, 8)
            }
            .padding(40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
