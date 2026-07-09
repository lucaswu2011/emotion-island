import Foundation

/// 14 天情绪日记 — 本地存储，每天最多 3 枚情绪贴纸
@Observable
final class DailyMoodDiaryStore {
    static let retentionDays = 14
    private let storageKey = "emotion_island_mood_diary"
    private var pagesByDay: [String: DailyMoodPageStorage] = [:]

    init() {
        load()
        pruneOldEntries()
    }

    func displayPages(referenceDate: Date = Date()) -> [DailyMoodPage] {
        let cal = Calendar.current
        let today = cal.startOfDay(for: referenceDate)
        var pages: [DailyMoodPage] = []
        pages.reserveCapacity(Self.retentionDays)
        for offset in 0..<Self.retentionDays {
            guard let day = cal.date(byAdding: .day, value: -offset, to: today) else { continue }
            let key = dayKey(day)
            if let stored = pagesByDay[key] {
                pages.append(
                    DailyMoodPage(dayStart: stored.dayStart, stickers: stored.stickers, snippet: stored.snippet)
                )
            } else {
                pages.append(DailyMoodPage.empty(for: day))
            }
        }
        return pages
    }

    func recordSession(
        conversation: ConversationSession,
        analyzer: EmotionAnalyzer,
        language: AppLanguage
    ) {
        let stickers = buildStickers(from: conversation, analyzer: analyzer, language: language)
        guard !stickers.isEmpty else { return }

        let snippet = diarySnippet(from: conversation)
        let dayStart = Calendar.current.startOfDay(for: Date())
        let key = dayKey(dayStart)

        var stored = pagesByDay[key] ?? DailyMoodPageStorage(dayStart: dayStart, stickers: [], snippet: nil)
        var merged = stored.stickers + stickers
        if merged.count > 3 {
            merged = Array(merged.suffix(3))
        }
        stored.stickers = reassignTags(stickers: merged, language: language)
        if stored.snippet == nil, let snippet {
            stored.snippet = snippet
        } else if let snippet, !snippet.isEmpty {
            stored.snippet = snippet
        }
        pagesByDay[key] = stored

        pruneOldEntries()
        persist()
    }

    // MARK: - Private

    private func buildStickers(
        from session: ConversationSession,
        analyzer: EmotionAnalyzer,
        language: AppLanguage
    ) -> [MoodSticker] {
        let userMessages = session.messages.filter { $0.role == .user }
        var seenIntents = Set<EmotionIntent>()
        var stickers: [MoodSticker] = []
        let now = Date()

        for message in userMessages {
            let intent = analyzer.analyze(message.text).intent
            guard intent != .unknown else { continue }
            guard !seenIntents.contains(intent) else { continue }
            seenIntents.insert(intent)

            let slot = stickers.count
            let hour = Calendar.current.component(.hour, from: now)
            stickers.append(
                MoodSticker(
                    emoji: intent.diaryEmoji,
                    intent: intent,
                    tagLabel: MoodDiaryLabels.timeTag(for: now, slotIndex: slot, lang: language),
                    tagStyle: MoodTagStyle.forSlot(index: slot, hour: hour),
                    recordedAt: now
                )
            )
            if stickers.count >= 3 { break }
        }

        if stickers.isEmpty {
            let intent = session.dominantIntent == .unknown ? session.initialResult.intent : session.dominantIntent
            let resolved = intent == .unknown ? .neutralMasking : intent
            let hour = Calendar.current.component(.hour, from: now)
            stickers.append(
                MoodSticker(
                    emoji: resolved.diaryEmoji,
                    intent: resolved,
                    tagLabel: MoodDiaryLabels.timeTag(for: now, slotIndex: 0, lang: language),
                    tagStyle: MoodTagStyle.forSlot(index: 0, hour: hour),
                    recordedAt: now
                )
            )
        }

        return stickers
    }

    private func reassignTags(stickers: [MoodSticker], language: AppLanguage) -> [MoodSticker] {
        stickers.enumerated().map { index, sticker in
            let usedTimeTag = stickers.prefix(index).contains { $0.tagLabel == sticker.tagLabel }
            let label = usedTimeTag
                ? MoodDiaryLabels.sequentialTag(index: index, lang: language)
                : sticker.tagLabel
            return MoodSticker(
                id: sticker.id,
                emoji: sticker.emoji,
                intent: sticker.intent,
                tagLabel: label,
                tagStyle: sticker.tagStyle,
                recordedAt: sticker.recordedAt
            )
        }
    }

    private func diarySnippet(from session: ConversationSession) -> String? {
        let first = session.messages.first(where: { $0.role == .user })?.text
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !first.isEmpty else { return nil }
        if first.count <= 36 { return first }
        return String(first.prefix(36)) + "…"
    }

    private func dayKey(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        return formatter.string(from: date)
    }

    private func pruneOldEntries() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        guard let cutoff = cal.date(byAdding: .day, value: -(Self.retentionDays - 1), to: today) else { return }
        pagesByDay = pagesByDay.filter { _, page in
            page.dayStart >= cutoff
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([DailyMoodPageStorage].self, from: data) else {
            return
        }
        pagesByDay = Dictionary(uniqueKeysWithValues: decoded.map { (dayKey($0.dayStart), $0) })
    }

    private func persist() {
        let array = pagesByDay.values.sorted { $0.dayStart > $1.dayStart }
        guard let data = try? JSONEncoder().encode(array) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

private struct DailyMoodPageStorage: Codable, Sendable {
    var dayStart: Date
    var stickers: [MoodSticker]
    var snippet: String?
}
