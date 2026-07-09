import Foundation

/// 本地情绪意图识别 — 完全离线，不上传任何数据
struct EmotionAnalyzer: Sendable {

    private static let rules: [EmotionRule] = [
        // 愤怒 — 优先匹配更具体的表达
        EmotionRule(keywords: ["有点生气", "很生气", "太生气了", "气死了", "气疯了"], intent: .anger, confidence: 0.95, priority: 10),
        EmotionRule(keywords: ["生气", "愤怒", "恼火", "气愤", "火大", "恼怒"], intent: .anger, confidence: 0.93, priority: 8),
        EmotionRule(keywords: ["被偷", "偷拿", "偷了", "拿走我的", "动了我的", "未经允许", "没经过同意"], intent: .anger, confidence: 0.90, priority: 9),

        // 被诬陷 — 优先于一般委屈
        EmotionRule(keywords: ["被诬陷", "诬陷我", "冤枉我", "错怪", "栽赃", "泼脏水", "打小报告", "搜包", "不是我拿的", "不是我的锅"], intent: .frustration, confidence: 0.96, priority: 11),
        EmotionRule(keywords: ["背锅", "甩锅", "被怀疑", "怀疑我偷"], intent: .frustration, confidence: 0.94, priority: 10),

        // 委屈烦躁
        EmotionRule(keywords: ["好委屈", "太委屈", "很委屈", "委屈死了"], intent: .frustration, confidence: 0.94, priority: 9),
        EmotionRule(keywords: ["委屈", "憋屈", "烦躁", "不爽", "郁闷", "心烦"], intent: .frustration, confidence: 0.90, priority: 7),

        // 失望
        EmotionRule(keywords: ["好失望", "太失望", "失望了"], intent: .disappointment, confidence: 0.93, priority: 8),
        EmotionRule(keywords: ["失望", "失落", "落空", "白期待了", "没想到会"], intent: .disappointment, confidence: 0.89, priority: 6),

        // 害怕担心
        EmotionRule(keywords: ["好害怕", "太害怕", "吓坏了"], intent: .fear, confidence: 0.94, priority: 9),
        EmotionRule(keywords: ["害怕", "恐惧", "担心", "担忧", "心慌", "不安"], intent: .fear, confidence: 0.88, priority: 6),

        // 疲惫
        EmotionRule(keywords: ["好累", "太累了", "累死了", "精疲力竭", "筋疲力尽"], intent: .exhaustion, confidence: 0.93, priority: 8),
        EmotionRule(keywords: ["疲惫", "很累", "累坏了", "撑不住", "透支"], intent: .exhaustion, confidence: 0.90, priority: 6),

        // 迷茫
        EmotionRule(keywords: ["好迷茫", "不知道怎么办", "不知所措", "无所适从"], intent: .confusion, confidence: 0.91, priority: 8),
        EmotionRule(keywords: ["迷茫", "困惑", "混乱", "没方向"], intent: .confusion, confidence: 0.86, priority: 5),

        // 难过
        EmotionRule(keywords: ["有点难过", "我有点难过", "好难过", "很难过"], intent: .sadness, confidence: 0.94, priority: 8),
        EmotionRule(keywords: ["难过", "不开心", "心里压着", "想哭", "伤心", "心碎"], intent: .sadness, confidence: 0.90, priority: 6),
        EmotionRule(keywords: ["不知道从哪儿说起", "不知道从何说起", "不知道怎么说"], intent: .sadness, confidence: 0.88, priority: 7),
        EmotionRule(keywords: ["孤独", "寂寞", "孤单"], intent: .sadness, confidence: 0.87, priority: 5),

        // 开心
        EmotionRule(keywords: ["今天很开心", "今天开心", "好开心", "很开心"], intent: .joy, confidence: 0.93, priority: 8),
        EmotionRule(keywords: ["开心", "高兴", "快乐", "幸福", "满足", "感恩"], intent: .joy, confidence: 0.88, priority: 5),

        // 焦虑
        EmotionRule(keywords: ["有点焦虑", "好焦虑", "太焦虑"], intent: .anxiety, confidence: 0.92, priority: 8),
        EmotionRule(keywords: ["焦虑", "紧张", "压力大", "喘不过气"], intent: .anxiety, confidence: 0.88, priority: 6),

        // 生活场景 — 高信号短语
        EmotionRule(keywords: ["冷暴力", "不回消息", "躲着不说"], intent: .frustration, confidence: 0.94, priority: 10),
        EmotionRule(keywords: ["动手打", "打我", "一巴掌", "家暴", "不是第一次了", "PUA", "经济控制"], intent: .fear, confidence: 0.96, priority: 12),
        EmotionRule(keywords: ["催婚", "催生", "别人家孩子"], intent: .frustration, confidence: 0.93, priority: 9),
        EmotionRule(keywords: ["提不起兴趣", "什么都没意思", "浑浑噩噩", "麻木", "空洞"], intent: .sadness, confidence: 0.92, priority: 9),
        EmotionRule(keywords: ["猫生病", "狗生病", "毛孩子生病", "跑丢了", "拆家"], intent: .fear, confidence: 0.90, priority: 8),

        // 掩饰
        EmotionRule(keywords: ["今天还好", "还好今天"], intent: .maskedLoneliness, confidence: 0.92, priority: 7),
        EmotionRule(keywords: ["今天还行"], intent: .neutralMasking, confidence: 0.92, priority: 8),
        EmotionRule(keywords: ["还好吧", "还行吧", "一般般", "凑合"], intent: .neutralMasking, confidence: 0.87, priority: 5),

        // English — anger
        EmotionRule(keywords: ["so angry", "very angry", "furious", "pissed", "mad at"], intent: .anger, confidence: 0.94, priority: 10),
        EmotionRule(keywords: ["angry", "mad", "annoyed", "irritated"], intent: .anger, confidence: 0.90, priority: 8),
        EmotionRule(keywords: ["stolen", "took my", "without asking"], intent: .anger, confidence: 0.90, priority: 9),

        EmotionRule(keywords: ["framed", "falsely accused", "blamed for", "not my fault", "set up"], intent: .frustration, confidence: 0.94, priority: 11),

        // English — frustration
        EmotionRule(keywords: ["so wronged", "unfair", "wronged"], intent: .frustration, confidence: 0.92, priority: 9),
        EmotionRule(keywords: ["frustrated", "upset", "fed up"], intent: .frustration, confidence: 0.88, priority: 7),

        // English — disappointment
        EmotionRule(keywords: ["disappointed", "let down", "disappointment"], intent: .disappointment, confidence: 0.91, priority: 8),

        // English — fear
        EmotionRule(keywords: ["so scared", "terrified", "frightened"], intent: .fear, confidence: 0.93, priority: 9),
        EmotionRule(keywords: ["scared", "afraid", "worried", "anxious about"], intent: .fear, confidence: 0.87, priority: 6),

        // English — exhaustion
        EmotionRule(keywords: ["so tired", "very tired", "exhausted", "worn out", "burned out", "dead tired"], intent: .exhaustion, confidence: 0.93, priority: 8),
        EmotionRule(keywords: ["tired", "drained", "fatigued"], intent: .exhaustion, confidence: 0.88, priority: 6),

        // English — confusion
        EmotionRule(keywords: ["so confused", "don't know what to do", "lost"], intent: .confusion, confidence: 0.90, priority: 8),
        EmotionRule(keywords: ["confused", "uncertain"], intent: .confusion, confidence: 0.85, priority: 5),

        // English — sadness
        EmotionRule(keywords: ["so sad", "very sad", "heartbroken"], intent: .sadness, confidence: 0.93, priority: 8),
        EmotionRule(keywords: ["sad", "unhappy", "lonely", "crying", "hurt"], intent: .sadness, confidence: 0.88, priority: 6),

        // English — joy
        EmotionRule(keywords: ["so happy", "very happy", "thrilled", "excited"], intent: .joy, confidence: 0.93, priority: 8),
        EmotionRule(keywords: ["happy", "glad", "joyful"], intent: .joy, confidence: 0.87, priority: 5),

        // English — anxiety
        EmotionRule(keywords: ["so anxious", "very anxious", "stressed out"], intent: .anxiety, confidence: 0.92, priority: 8),
        EmotionRule(keywords: ["anxious", "nervous", "stressed"], intent: .anxiety, confidence: 0.87, priority: 6),

        // English — masking
        EmotionRule(keywords: ["i'm fine", "im fine", "doing okay", "not bad"], intent: .maskedLoneliness, confidence: 0.88, priority: 7),
    ]

    private static let boundaryKeywords = [
        "偷", "偷拿", "偷了", "偷看", "拿走", "动了我的", "翻我的", "未经允许", "没告诉我", "私自",
        "stolen", "took my", "without asking", "went through my"
    ]

    private static let conflictKeywords = [
        "吵架", "争吵", "骂我", "说我", "欺负", "针对我", "误会我", "不理解我",
        "fight", "yelled at", "argued", "misunderstood me", "bullied"
    ]

    func analyze(_ text: String) -> EmotionAnalysisResult {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return emptyResult(for: trimmed)
        }

        let cause = extractCause(from: trimmed)
        let contexts = detectContexts(in: trimmed)
        var bestMatch: (rule: EmotionRule, triggers: [String], score: Double)?

        for rule in Self.rules {
            var matched: [String] = []
            for keyword in rule.keywords {
                if trimmed.localizedCaseInsensitiveContains(keyword) {
                    matched.append(keyword)
                }
            }
            guard !matched.isEmpty else { continue }

            var score = rule.confidence
            score += Double(rule.priority) * 0.005
            score += Double(matched.map(\.count).max() ?? 0) * 0.003
            score += Double(matched.count) * 0.015

            if rule.intent == .anger && contexts.contains(.boundaryViolation) {
                score += 0.04
            }

            if bestMatch == nil || score > bestMatch!.score {
                bestMatch = (rule, matched, score)
            }
        }

        if let best = bestMatch {
            var intent = best.rule.intent
            var triggers = best.triggers
            var confidence = min(best.score, 0.99)

            if intent != .anger && contexts.contains(.boundaryViolation) {
                intent = .anger
                confidence = max(confidence, 0.91)
                triggers += Self.boundaryKeywords.filter { trimmed.contains($0) }
            }

            return EmotionAnalysisResult(
                intent: intent,
                confidence: confidence,
                triggerWords: Array(Set(triggers)),
                userText: trimmed,
                timestamp: Date(),
                detectedCause: cause,
                contexts: contexts
            )
        }

        return inferFromSentiment(trimmed, cause: cause, contexts: contexts)
    }

    func generateDetailedResponse(for result: EmotionAnalysisResult, lang: AppLanguage = .chinese) -> String {
        switch result.intent {
        case .anger:
            return angerResponse(for: result, lang: lang)
        case .sadness, .maskedLoneliness:
            if lang == .english {
                return "The part you didn't say — want to try sharing it? **Sadness deserves to be held gently.** \(result.intent.assistantResponse(for: lang))"
            }
            return "那个没说出口的部分，现在愿意试试吗？**难过也值得被温柔托住**，\(result.intent.assistantResponse(for: lang))"
        case .frustration:
            if let cause = result.detectedCause {
                if lang == .english {
                    return "Because of \(cause), feeling wronged is real. **Your feelings don't need explaining to be valid.** Want to say a bit more?"
                }
                return "因为\(cause)，憋屈和委屈都是真实的。**你的感受不需要被解释才成立**，愿意多说一点吗？"
            }
            if lang == .english {
                return "**Frustration and feeling wronged deserve to be seen** — not to be swallowed alone. I'm here to listen."
            }
            return "**委屈和烦躁也值得被看见**，不是要你一定消化掉，只是想陪你说一说。"
        case .disappointment:
            if let cause = result.detectedCause {
                if lang == .english {
                    return "Because of \(cause), disappointment makes sense. **Hopes falling flat doesn't mean you wanted too much.** What did you hope for?"
                }
                return "因为\(cause)，失望是理所当然的。**期待落空不代表你要求太多**，愿意说说原本希望的是什么吗？"
            }
            return result.intent.assistantResponse(for: lang)
        case .fear:
            if let cause = result.detectedCause {
                if lang == .english {
                    return "Feeling afraid because of \(cause) — **writing it down took courage.** Want to share a little more?"
                }
                return "因为\(cause)而感到害怕，**能写下来已经很勇敢了**。要不要一起把担心多说一点？"
            }
            if lang == .english {
                return "**You don't have to face fear alone.** I'm here — want to share a little more?"
            }
            return "**害怕的时候不用一个人扛**，我在这儿，你愿意多说一点吗？"
        case .exhaustion:
            if lang == .english {
                return "**Rest when you need to** — today has been enough. You don't have to push through."
            }
            return "**累了就允许自己歇一歇**，今天已经够辛苦了，不必再勉强。"
        case .confusion:
            if lang == .english {
                return "**When you're lost, writing it down is enough.** No need to figure it all out right now."
            }
            return "**迷茫的时候先写下来就好**，不必马上想清楚，愿意一起理一理吗？"
        default:
            return result.intent.assistantResponse(for: lang)
        }
    }

    func islandMessage(for result: EmotionAnalysisResult, lang: AppLanguage = .chinese) -> String {
        if MoodQuickPick.isOkayMood(result.userText, language: lang) {
            return lang == .english ? "An ordinary day is a real day." : "平平淡淡才是真。"
        }

        switch result.intent {
        case .anger where result.hasBoundaryViolation:
            return lang == .english ? "Someone crossed a line — anger makes sense." : "东西被动了，生气是应该的。"
        case .anger where result.detectedCause != nil:
            return lang == .english ? "It's normal to be angry about this." : "这件事让你生气，很正常。"
        case .anger:
            return result.intent.islandMessage(for: lang)
        case .frustration:
            return lang == .english ? "You don't have to swallow this alone." : "憋屈的时候，不用一个人消化。"
        default:
            return result.intent.islandMessage(for: lang)
        }
    }

    // MARK: - Private

    private func angerResponse(for result: EmotionAnalysisResult, lang: AppLanguage) -> String {
        if result.hasBoundaryViolation {
            if let cause = result.detectedCause {
                if lang == .english {
                    return "Because \(cause), **anger makes sense.** Your boundaries were crossed. Want to say more about what happened?"
                }
                return "因为\(cause)，**生气是理所当然的**。你的东西被擅自触碰，边界值得被认真对待。愿意多说一点那时发生了什么吗？"
            }
            if lang == .english {
                return "Your things were touched without consent — **anger is normal.** Your feelings deserve to be heard. Want to share more?"
            }
            return "东西被动了、边界被跨过了，**生气很正常**。你的感受值得被认真听见，愿意多说一点吗？"
        }

        if result.contexts.contains(.interpersonalConflict) {
            if let cause = result.detectedCause {
                if lang == .english {
                    return "Angry because of \(cause) — **your feelings don't need to be justified first.** Want to tell me more?"
                }
                return "因为\(cause)而生气，**你的感受不需要先被「合理化」才成立**。愿意把整件事多说一点吗？"
            }
            if lang == .english {
                return "**Anger after being hurt or misunderstood is real** — I'm listening."
            }
            return "**被冒犯、被误解时的愤怒是真实的**，不是要你一定原谅，只是想让你知道：我在听。"
        }

        if let cause = result.detectedCause {
            if lang == .english {
                return "Angry because of \(cause) — **that emotion deserves acknowledgment.** Want to share more?"
            }
            return "因为\(cause)感到生气，**这种情绪值得被承认**。不是要压下去，而是想问问：你愿意多说一点吗？"
        }

        if lang == .english {
            return "**Anger is worth seeing too** — not to push down, but to know your feelings matter."
        }
        return "**愤怒也是一种值得被看见的情绪**。不是要压下去，而是想让你知道：你的感受很重要。"
    }

    private func extractCause(from text: String) -> String? {
        let separators = ["因为", "由于", "原因是", "because", "since", "due to"]
        for sep in separators {
            guard let range = text.range(of: sep, options: .caseInsensitive) else { continue }
            let cause = String(text[range.upperBound...])
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .trimmingCharacters(in: CharacterSet(charactersIn: "，。！？、；："))
            if !cause.isEmpty { return cause }
        }
        return nil
    }

    private func detectContexts(in text: String) -> [EmotionContext] {
        var contexts: [EmotionContext] = []
        if Self.boundaryKeywords.contains(where: { text.contains($0) }) {
            contexts.append(.boundaryViolation)
        }
        if Self.conflictKeywords.contains(where: { text.contains($0) }) {
            contexts.append(.interpersonalConflict)
        }
        if ["不公平", "凭什么", "太过分", "欺负人"].contains(where: { text.contains($0) }) {
            contexts.append(.unfairness)
        }
        if ["失去", "丢了", "没了", "离开"].contains(where: { text.contains($0) }) {
            contexts.append(.loss)
        }
        return contexts
    }

    private func inferFromSentiment(
        _ text: String,
        cause: String?,
        contexts: [EmotionContext]
    ) -> EmotionAnalysisResult {
        let sentimentMap: [(words: [String], intent: EmotionIntent, confidence: Double)] = [
            (["怒", "气", "恨", "讨厌", "angry", "mad", "furious"], .anger, 0.75),
            (["委屈", "烦", "闷", "wronged", "frustrated"], .frustration, 0.74),
            (["怕", "惧", "忧", "scared", "afraid", "fear"], .fear, 0.73),
            (["累", "疲", "倦", "tired", "exhausted", "drained"], .exhaustion, 0.73),
            (["迷茫", "困惑", "confused", "lost"], .confusion, 0.72),
            (["失望", "落", "disappointed"], .disappointment, 0.72),
            (["孤独", "寂寞", "痛", "哭", "压抑", "沉重", "sad", "lonely", "hurt"], .sadness, 0.74),
            (["乐", "喜", "幸福", "happy", "glad", "joy"], .joy, 0.72),
        ]

        var triggers: [String] = []
        var intent: EmotionIntent = .unknown
        var confidence = 0.65

        for entry in sentimentMap {
            for word in entry.words where text.localizedCaseInsensitiveContains(word) {
                triggers.append(word)
                if entry.confidence > confidence {
                    intent = entry.intent
                    confidence = entry.confidence
                }
            }
        }

        if contexts.contains(.boundaryViolation) {
            intent = .anger
            confidence = max(confidence, 0.88)
        }

        if text.count <= 6 && (text.contains("好") || text.contains("行")) {
            intent = .maskedLoneliness
            triggers = [text]
            confidence = 0.70
        }

        return EmotionAnalysisResult(
            intent: intent,
            confidence: confidence,
            triggerWords: triggers.isEmpty ? [String(text.prefix(12))] : Array(Set(triggers)),
            userText: text,
            timestamp: Date(),
            detectedCause: cause,
            contexts: contexts
        )
    }

    private func emptyResult(for text: String) -> EmotionAnalysisResult {
        EmotionAnalysisResult(
            intent: .unknown,
            confidence: 0.0,
            triggerWords: [],
            userText: text,
            timestamp: Date(),
            detectedCause: nil,
            contexts: []
        )
    }
}
