import Foundation

enum EmotionIntent: String, CaseIterable, Codable, Sendable {
    case maskedLoneliness = "maskedLoneliness"
    case sadness = "sadness"
    case joy = "joy"
    case anxiety = "anxiety"
    case anger = "anger"
    case frustration = "frustration"
    case disappointment = "disappointment"
    case fear = "fear"
    case exhaustion = "exhaustion"
    case confusion = "confusion"
    case neutralMasking = "neutralMasking"
    case unknown = "unknown"

    var displayName: String { displayName(for: .chinese) }

    func displayName(for lang: AppLanguage) -> String {
        switch self {
        case .maskedLoneliness: return lang == .english ? "Hidden loneliness" : "隐藏的孤独"
        case .sadness: return lang == .english ? "Low mood" : "低落"
        case .joy: return lang == .english ? "Joy" : "开心"
        case .anxiety: return lang == .english ? "Anxiety" : "焦虑"
        case .anger: return lang == .english ? "Anger" : "愤怒"
        case .frustration: return lang == .english ? "Frustration" : "烦躁委屈"
        case .disappointment: return lang == .english ? "Disappointment" : "失望"
        case .fear: return lang == .english ? "Fear" : "害怕担心"
        case .exhaustion: return lang == .english ? "Exhaustion" : "疲惫"
        case .confusion: return lang == .english ? "Confusion" : "迷茫"
        case .neutralMasking: return lang == .english ? "Neutral masking" : "中性掩饰"
        case .unknown: return lang == .english ? "Unrecognized" : "未识别"
        }
    }

    var recognizedEmotions: String { recognizedEmotions(for: .chinese) }

    func recognizedEmotions(for lang: AppLanguage) -> String {
        switch self {
        case .maskedLoneliness: return lang == .english ? "Low · Lonely" : "低落 · 孤独"
        case .sadness: return lang == .english ? "Low · Lonely" : "低落 · 孤独"
        case .joy: return lang == .english ? "Happy · Uplifted" : "开心 · 愉悦"
        case .anxiety: return lang == .english ? "Anxious · Uneasy" : "焦虑 · 不安"
        case .anger: return lang == .english ? "Angry · Upset" : "愤怒 · 不满"
        case .frustration: return lang == .english ? "Frustrated · Wronged" : "烦躁 · 委屈"
        case .disappointment: return lang == .english ? "Disappointed · Let down" : "失望 · 失落"
        case .fear: return lang == .english ? "Afraid · Worried" : "害怕 · 担心"
        case .exhaustion: return lang == .english ? "Tired · Drained" : "疲惫 · 耗尽"
        case .confusion: return lang == .english ? "Lost · Uncertain" : "迷茫 · 困惑"
        case .neutralMasking: return lang == .english ? "Calm · Masking" : "平静 · 掩饰"
        case .unknown: return lang == .english ? "Calm" : "平静"
        }
    }

    var animationDescription: String { animationDescription(for: .chinese) }

    func animationDescription(for lang: AppLanguage) -> String {
        switch self {
        case .maskedLoneliness:
            return lang == .english ? "Heart contracts, leaf touches the edge" : "心形微缩，叶子轻触边缘"
        case .sadness:
            return lang == .english ? "Leaf wraps the heart · companion words" : "叶子包裹心形 · 陪伴语句"
        case .joy:
            return lang == .english ? "Heart unfolds into a leaf" : "心形舒展成叶子"
        case .anxiety:
            return lang == .english ? "Heart trembles, leaf soothes" : "心形轻颤，叶子轻抚"
        case .anger:
            return lang == .english ? "Heart pulses fast, leaf calms" : "心形急促跳动，叶子轻轻安抚"
        case .frustration:
            return lang == .english ? "Heart tightens, leaf approaches gently" : "心形收紧，叶子试探靠近"
        case .disappointment:
            return lang == .english ? "Heart sinks slowly, leaf holds" : "心形缓缓下沉，叶子托住"
        case .fear:
            return lang == .english ? "Heart shrinks and shakes, leaf guards" : "心形微缩颤抖，叶子环绕守护"
        case .exhaustion:
            return lang == .english ? "Heart breathes slowly, leaf stays" : "心形缓慢呼吸，叶子静静陪伴"
        case .confusion:
            return lang == .english ? "Heart pauses, leaf sways gently" : "心形停顿，叶子轻轻摇晃"
        case .neutralMasking:
            return lang == .english ? "Heart pauses, leaf approaches" : "心形停顿，叶子试探靠近"
        case .unknown:
            return lang == .english ? "Heart breathing" : "心形呼吸"
        }
    }

    var assistantResponse: String { assistantResponse(for: .chinese) }

    func assistantResponse(for lang: AppLanguage) -> String {
        switch self {
        case .maskedLoneliness:
            return lang == .english
                ? "The part you didn't say — want to try sharing it?"
                : "那个没说出口的部分，现在愿意试试吗？"
        case .sadness:
            return lang == .english
                ? "Sadness deserves to be held gently. Want me to stay a while?"
                : "难过也值得被温柔托住，要我陪你多待一会儿吗？"
        case .joy:
            return lang == .english
                ? "Joy is worth celebrating. Want to tell me more?"
                : "开心值得被温柔托住，要我陪你多待一会儿吗？"
        case .anxiety:
            return lang == .english ? "It's okay — take your time. I'm listening." : "没关系，慢慢来，我在听。"
        case .anger:
            return lang == .english
                ? "Anger deserves to be heard — not pushed down. I'm here."
                : "愤怒也值得被认真听见，不是要压下去，只是想让你知道：我在。"
        case .frustration:
            return lang == .english
                ? "Feeling wronged is hard. Want to say a bit more about what's stuck?"
                : "憋屈的感觉不好受，你愿意把卡住的地方多说一点吗？"
        case .disappointment:
            return lang == .english
                ? "When hopes fall flat, disappointment is real. What did you hope for?"
                : "期待落空了，失望是真实的。愿意说说原本希望的是什么吗？"
        case .fear:
            return lang == .english
                ? "Writing down fear takes courage. Want to share a little more?"
                : "害怕的时候，能写下来已经很勇敢了。要不要多说一点？"
        case .exhaustion:
            return lang == .english
                ? "Rest when you need to — today has been enough."
                : "累了就歇一歇，不必勉强自己。今天已经够辛苦了。"
        case .confusion:
            return lang == .english
                ? "When you don't know what to do, writing it down is already enough."
                : "不知道怎么办的时候，先写下来就已经很好了。愿意一起理一理吗？"
        case .neutralMasking:
            return lang == .english ? "Is there more behind \"I'm fine\"?" : "「还好」的背后，是不是还有别的？"
        case .unknown:
            return lang == .english
                ? "One line is enough — unsaid parts might still be gently caught."
                : "写下一句话就好，有些没说出口的部分，也许会被轻轻接住。"
        }
    }

    var islandMessage: String {
        islandMessage(for: .chinese)
    }

    func islandMessage(for lang: AppLanguage) -> String {
        switch self {
        case .maskedLoneliness:
            return lang == .english ? "Is there more behind 'I'm fine'?" : "那个没说出口的部分，现在愿意试试吗？"
        case .sadness:
            return lang == .english ? "Want me to stay with you a while?" : "要我陪你多待一会儿吗？"
        case .joy:
            return lang == .english ? "What made you happy?" : "为什么开心呀？"
        case .anxiety:
            return lang == .english ? "No rush — I'm listening." : "没关系，慢慢来，我在听。"
        case .anger:
            return lang == .english ? "Your anger matters." : "生气是应该的，你的感受很重要。"
        case .frustration:
            return lang == .english ? "Frustration deserves to be seen." : "委屈和烦躁，都值得被看见。"
        case .disappointment:
            return lang == .english ? "Disappointment is allowed." : "失望了，也没关系。"
        case .fear:
            return lang == .english ? "You don't have to face fear alone." : "害怕的时候，不用一个人扛。"
        case .exhaustion:
            return lang == .english ? "Rest if you need to." : "累了，就让自己歇一歇。"
        case .confusion:
            return lang == .english ? "When you're lost, writing it down is enough." : "迷茫的时候，先写下来就好。"
        case .neutralMasking:
            return lang == .english ? "Is there more behind 'okay'?" : "「还好」的背后，是不是还有别的？"
        case .unknown:
            return lang == .english ? "Unsaid things can still be held gently." : "有些没说出口的部分，也许会被轻轻接住。"
        }
    }

    var animationStyle: HeartLeafAnimationStyle {
        switch self {
        case .maskedLoneliness: .contractAndTouch
        case .sadness: .leafWrapsHeart
        case .joy: .heartUnfoldsToLeaf
        case .anxiety: .trembleAndStroke
        case .anger: .angerPulseAndCalm
        case .frustration: .pauseAndApproach
        case .disappointment: .contractAndTouch
        case .fear: .trembleAndStroke
        case .exhaustion: .breathing
        case .confusion: .pauseAndApproach
        case .neutralMasking: .pauseAndApproach
        case .unknown: .breathing
        }
    }

    var islandIcon: String {
        switch self {
        case .anger: "flame.fill"
        case .fear: "shield.fill"
        case .exhaustion: "moon.fill"
        case .joy: "heart.fill"
        default: "leaf.fill"
        }
    }
}

enum HeartLeafAnimationStyle: Sendable {
    case breathing
    case contractAndTouch
    case leafWrapsHeart
    case heartUnfoldsToLeaf
    case trembleAndStroke
    case pauseAndApproach
    case angerPulseAndCalm
}

enum EmotionContext: String, Sendable {
    case boundaryViolation = "boundaryViolation"
    case interpersonalConflict = "interpersonalConflict"
    case unfairness = "unfairness"
    case loss = "loss"
}

struct EmotionAnalysisResult: Identifiable, Sendable {
    let id = UUID()
    let intent: EmotionIntent
    let confidence: Double
    let triggerWords: [String]
    let userText: String
    let timestamp: Date
    let detectedCause: String?
    let contexts: [EmotionContext]

    var intentLabel: String { intentLabel(for: .chinese) }

    func intentLabel(for lang: AppLanguage) -> String {
        let name = intent.displayName(for: lang)
        return lang == .english
            ? "\(name) · confidence: \(String(format: "%.2f", confidence))"
            : "intent: .\(intent.rawValue) · confidence: \(String(format: "%.2f", confidence))"
    }

    var triggerWordsDisplay: String {
        triggerWords.map { "\"\($0)\"" }.joined(separator: " ")
    }

    var hasBoundaryViolation: Bool {
        contexts.contains(.boundaryViolation)
    }
}

struct EmotionRecord: Identifiable, Codable, Sendable {
    let id: UUID
    let text: String
    let intent: EmotionIntent
    let confidence: Double
    let triggerWords: [String]
    let assistantResponse: String
    let chatMessages: [ChatMessage]
    let createdAt: Date

    init(
        id: UUID = UUID(),
        text: String,
        intent: EmotionIntent,
        confidence: Double,
        triggerWords: [String],
        assistantResponse: String,
        chatMessages: [ChatMessage] = [],
        createdAt: Date = Date()
    ) {
        self.id = id
        self.text = text
        self.intent = intent
        self.confidence = confidence
        self.triggerWords = triggerWords
        self.assistantResponse = assistantResponse
        self.chatMessages = chatMessages
        self.createdAt = createdAt
    }
}

struct EmotionRule: Sendable {
    let keywords: [String]
    let intent: EmotionIntent
    let confidence: Double
    let priority: Int

    init(keywords: [String], intent: EmotionIntent, confidence: Double, priority: Int = 0) {
        self.keywords = keywords
        self.intent = intent
        self.confidence = confidence
        self.priority = priority
    }
}
