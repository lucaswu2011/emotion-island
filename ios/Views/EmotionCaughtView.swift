import SwiftUI

struct EmotionCaughtView: View {
    let result: EmotionAnalysisResult
    let detailedResponse: String
    let islandMessage: String
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            DynamicIslandPill(
                message: islandMessage,
                icon: result.intent.islandIcon,
                iconColor: ResponseFormatter.islandIconColor(for: result.intent),
                style: .light
            )
            .padding(.top, 24)

            Spacer()

            VStack(alignment: .leading, spacing: 0) {
                Text("今天，我想说...")
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                    .padding(.bottom, 16)

                Text(result.userText)
                    .font(.title2)
                    .foregroundStyle(AppTheme.primaryText)
                    .lineSpacing(6)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(result.timestamp.diaryDisplayString)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                    .padding(.top, 24)
            }
            .padding(32)
            .frame(maxWidth: 600)
            .background(AppTheme.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: 24))

            Spacer().frame(height: 24)

            Circle()
                .fill(AppTheme.primaryText)
                .frame(width: 4, height: 4)

            Spacer().frame(height: 24)

            VStack(spacing: 12) {
                AssistantBadge()

                Text(ResponseFormatter.attributed(detailedResponse))
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.primaryText)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .frame(maxWidth: 520)
            }

            Spacer()

            PrimaryButton("查看识别详情", action: onContinue)
                .padding(.bottom, 40)
        }
        .padding(.horizontal, 40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
