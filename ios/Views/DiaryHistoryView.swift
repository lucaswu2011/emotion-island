import SwiftUI

struct DiaryHistoryView: View {
    let strings: AppStrings
    let language: AppLanguage
    let records: [EmotionRecord]

    var body: some View {
        Group {
            if records.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "book.closed")
                        .font(.largeTitle)
                        .foregroundStyle(AppTheme.secondaryText)
                    Text(strings.historyEmptyTitle)
                        .font(.headline)
                        .foregroundStyle(AppTheme.secondaryText)
                    Text(strings.historyEmptyBody)
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(records) { record in
                            HistoryCard(record: record, strings: strings, language: language)
                        }
                    }
                    .padding(24)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .navigationTitle(strings.historyTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct HistoryCard: View {
    let record: EmotionRecord
    let strings: AppStrings
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(record.intent.recognizedEmotions(for: language))
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.accentBlue)
                Spacer()
                Text(record.createdAt.diaryDisplayString)
                    .font(.caption2)
                    .foregroundStyle(AppTheme.secondaryText)
            }

            if record.chatMessages.isEmpty {
                Text(record.text)
                    .font(.body)
                    .foregroundStyle(AppTheme.primaryText)
                    .lineSpacing(4)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(record.chatMessages.prefix(4)) { message in
                        HStack(alignment: .top, spacing: 6) {
                            Text(message.role == .user ? strings.historyUser : strings.historyAssistant)
                                .font(.caption2.weight(.medium))
                                .foregroundStyle(AppTheme.secondaryText)
                                .frame(width: language == .english ? 36 : 28, alignment: .leading)
                            Text(message.text)
                                .font(.caption)
                                .foregroundStyle(AppTheme.primaryText)
                        }
                    }
                    if record.chatMessages.count > 4 {
                        Text(strings.historyMessageCount(record.chatMessages.count))
                            .font(.caption2)
                            .foregroundStyle(AppTheme.secondaryText)
                    }
                }
            }

            HStack(spacing: 6) {
                Text(record.assistantResponse.replacingOccurrences(of: "**", with: ""))
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
                    .lineSpacing(3)
                if let lastEmoji = record.chatMessages.last(where: { $0.role == .assistant })?.emojis.first {
                    Text(lastEmoji)
                        .font(.caption)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
