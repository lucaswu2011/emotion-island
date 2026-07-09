import Foundation

enum ChatRole: String, Codable, Sendable {
    case user
    case assistant
}

struct ChatMessage: Identifiable, Codable, Sendable, Equatable {
    let id: UUID
    let role: ChatRole
    let text: String
    let emojis: [String]
    let createdAt: Date

    init(id: UUID = UUID(), role: ChatRole, text: String, emojis: [String] = [], createdAt: Date = Date()) {
        self.id = id
        self.role = role
        self.text = text
        self.emojis = emojis
        self.createdAt = createdAt
    }
}

struct ChatReply: Sendable {
    let text: String
    let emojis: [String]
    let replyKey: String

    init(_ text: String, emojis: [String] = [], replyKey: String = UUID().uuidString) {
        self.text = text
        self.emojis = emojis
        self.replyKey = replyKey
    }
}

enum ConversationTopic: String, Sendable, Codable, Hashable {
    case exam
    case work
    case relationship
    case family
    case boundaryViolation
    case loneliness
    case health
    case disappointment
    case selfBlame
    case gaming
    case falselyAccused
    case pet
    case travel
    case consumption
    case general
}

enum ConversationPhase: Sendable {
    case opening
    case listening
    case unfolding
    case venting
    case deepListening
    case comforting
}

enum DisclosureStage: Sendable {
    case emotionOnly
    case droppingHints
    case unfolding
    case readyForComfort
}

enum DistressLevel: Int, Sendable, Comparable {
    case calm = 0
    case elevated = 1
    case high = 2
    case overwhelming = 3

    static func < (lhs: DistressLevel, rhs: DistressLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}

struct ConversationSession: Sendable {
    let initialResult: EmotionAnalysisResult
    var messages: [ChatMessage]
    var phase: ConversationPhase
    var turnCount: Int
    var negativeStreak: Int
    var distressLevel: DistressLevel
    var usedReplyKeys: Set<String>
    var discussedTopics: Set<ConversationTopic>
    var dominantIntent: EmotionIntent
    var disclosureStage: DisclosureStage
    var userLanguage: AppLanguage
    /// 上一轮助手发了引导词时，下一轮走通用承接池而非场景匹配
    var pendingFollowUpTone: SentimentTone?
    /// 连续迁怒 / 人身攻击轮次（用于三级辱骂升级）
    var profanityAttackStreak: Int
    /// 三级边界话术步进 0…2
    var profanityBoundaryStep: Int
    /// 辱骂宣泄后，下一轮若无脏字则轻引导倾诉
    var awaitingProfanityCalmCheck: Bool

    var userTurnCount: Int {
        messages.filter { $0.role == .user }.count
    }

    var isLongSession: Bool {
        userTurnCount >= 4
    }

    var isVentingHard: Bool {
        negativeStreak >= 2 || distressLevel >= .high
    }

    var accumulatedStory: String {
        let sep = userLanguage.listSeparator
        return messages.filter { $0.role == .user }.map(\.text).joined(separator: sep)
    }

    var fullTranscript: String {
        messages
            .map { ($0.role == .user ? userLanguage.transcriptUserLabel : userLanguage.transcriptAssistantLabel) + "：\($0.text)" }
            .joined(separator: "\n")
    }

    var recentUserTexts: [String] {
        messages.filter { $0.role == .user }.suffix(5).map(\.text)
    }
}
