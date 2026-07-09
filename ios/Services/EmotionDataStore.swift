import Foundation

/// 本地数据存储 — 仅保存在设备上，不上传、不同步
@Observable
final class EmotionDataStore {
    private let storageKey = "emotion_island_records"
    private(set) var records: [EmotionRecord] = []

    init() {
        load()
    }

    func save(_ record: EmotionRecord) {
        records.insert(record, at: 0)
        persist()
    }

    func delete(_ record: EmotionRecord) {
        records.removeAll { $0.id == record.id }
        persist()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([EmotionRecord].self, from: data) else {
            return
        }
        records = decoded
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(records) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}
