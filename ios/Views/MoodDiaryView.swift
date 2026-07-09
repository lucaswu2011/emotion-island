import SwiftUI

struct MoodDiaryView: View {
    let strings: AppStrings
    let language: AppLanguage
    @Bindable var moodDiaryStore: DailyMoodDiaryStore
    let onOpenFullHistory: () -> Void

    private var pages: [DailyMoodPage] { moodDiaryStore.displayPages() }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                diaryIntro

                LazyVStack(spacing: 20) {
                    ForEach(pages) { page in
                        DiaryDayRow(page: page, language: language, strings: strings)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)

                Button(action: onOpenFullHistory) {
                    HStack(spacing: 6) {
                        Image(systemName: "text.book.closed")
                        Text(strings.moodDiaryFullHistory)
                    }
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.accentBlue)
                }
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.99, green: 0.98, blue: 0.96))
        .navigationTitle(strings.moodDiaryTitle)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var diaryIntro: some View {
        VStack(spacing: 8) {
            Text(strings.moodDiarySubtitle)
                .font(.subheadline)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
            Text(strings.moodDiaryRetention)
                .font(.caption2)
                .foregroundStyle(AppTheme.secondaryText.opacity(0.85))
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 20)
    }
}

// MARK: - 单日日记行

private struct DiaryDayRow: View {
    let page: DailyMoodPage
    let language: AppLanguage
    let strings: AppStrings

    private var isEmpty: Bool { page.stickers.isEmpty }

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            DaySideTab(
                title: MoodDiaryLabels.dayTitle(for: page.dayStart, lang: language),
                weekday: MoodDiaryLabels.weekdayOnly(for: page.dayStart, lang: language),
                isToday: Calendar.current.isDateInToday(page.dayStart)
            )

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.06), radius: 8, y: 3)

                VStack(alignment: .leading, spacing: 0) {
                    ruledLines
                        .frame(height: 120)
                        .overlay {
                            ZStack {
                                if isEmpty {
                                    Text(strings.moodDiaryEmptyPage)
                                        .font(.caption)
                                        .foregroundStyle(AppTheme.secondaryText.opacity(0.45))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                } else {
                                    stickerField
                                }
                            }
                        }

                    if let snippet = page.snippet, !snippet.isEmpty {
                        Text(snippet)
                            .font(.caption)
                            .foregroundStyle(AppTheme.primaryText.opacity(0.55))
                            .lineSpacing(3)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                            .padding(.top, 4)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }

    private var ruledLines: some View {
        VStack(spacing: 22) {
            ForEach(0..<5, id: \.self) { _ in
                Rectangle()
                    .fill(Color(red: 0.88, green: 0.90, blue: 0.94).opacity(0.55))
                    .frame(height: 1)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 18)
    }

    private var stickerField: some View {
        GeometryReader { geo in
            ForEach(Array(page.stickers.enumerated()), id: \.element.id) { index, sticker in
                MoodTagSticker(sticker: sticker)
                    .position(stickerPosition(index: index, size: geo.size))
                    .rotationEffect(.degrees(stickerRotation(index: index)))
            }
        }
    }

    private func stickerPosition(index: Int, size: CGSize) -> CGPoint {
        switch index {
        case 0:
            return CGPoint(x: size.width * 0.72, y: size.height * 0.38)
        case 1:
            return CGPoint(x: size.width * 0.32, y: size.height * 0.58)
        default:
            return CGPoint(x: size.width * 0.78, y: size.height * 0.78)
        }
    }

    private func stickerRotation(index: Int) -> Double {
        switch index {
        case 0: return -7
        case 1: return 5
        default: return -3
        }
    }
}

// MARK: - 侧边日期标签

private struct DaySideTab: View {
    let title: String
    let weekday: String
    let isToday: Bool

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(isToday ? AppTheme.accentBlue : AppTheme.primaryText)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            Text(weekday)
                .font(.system(size: 9))
                .foregroundStyle(AppTheme.secondaryText)
        }
        .frame(width: 52)
        .padding(.vertical, 12)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isToday ? AppTheme.accentBlue.opacity(0.1) : Color(red: 0.94, green: 0.93, blue: 0.91))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isToday ? AppTheme.accentBlue.opacity(0.25) : Color.clear, lineWidth: 1)
        )
        .padding(.trailing, 8)
        .padding(.top, 8)
    }
}

// MARK: - 情绪贴纸（emoji + 彩色标签）

private struct MoodTagSticker: View {
    let sticker: MoodSticker

    var body: some View {
        VStack(spacing: 2) {
            Text(sticker.emoji)
                .font(.system(size: 28))
            Text(sticker.tagLabel)
                .font(.system(size: 9, weight: .semibold))
                .foregroundStyle(tagForeground)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(tagBackground)
                .clipShape(Capsule())
        }
        .shadow(color: .black.opacity(0.08), radius: 3, y: 2)
    }

    private var tagBackground: Color {
        switch sticker.tagStyle {
        case .dawn: return Color(red: 1.0, green: 0.88, blue: 0.78)
        case .noon: return Color(red: 1.0, green: 0.96, blue: 0.75)
        case .dusk: return Color(red: 0.88, green: 0.84, blue: 0.98)
        case .night: return Color(red: 0.78, green: 0.84, blue: 0.96)
        case .mint: return Color(red: 0.82, green: 0.95, blue: 0.88)
        case .blush: return Color(red: 0.98, green: 0.86, blue: 0.88)
        case .sky: return Color(red: 0.85, green: 0.92, blue: 0.98)
        }
    }

    private var tagForeground: Color {
        Color(red: 0.28, green: 0.28, blue: 0.32)
    }
}
