import Foundation

/// 句子态度：先察觉用户是开心、难过还是中性，再选回应
enum SentimentTone: Sendable {
    case positive
    case negative
    case neutral
}

/// 从用户原话里提取「发生了什么 + 什么态度」，再生成贴切回应
struct ContextualResponder: Sendable {

    private let analyzer = EmotionAnalyzer()

    func respond(
        currentText: String,
        session: ConversationSession,
        usedKeys: Set<String>
    ) -> ChatReply {
        let accumulated = session.accumulatedStory
        let ctx = EmotionalContextBuilder.build(currentText: currentText, session: session, analyzer: analyzer)
        let seed = CompanionLanguage.seed(session: session, text: currentText, usedKeys: usedKeys)
        let lang = session.userLanguage

        if let crisis = crisisReply(for: currentText, seed: seed, lang: lang) { return crisis }

        if let heavy = heavyDistressReply(
            currentText: currentText,
            usedKeys: usedKeys,
            seed: seed,
            turnCount: session.turnCount,
            lang: lang
        ) {
            return heavy
        }

        if let profanity = profanityBreakdownReply(
            currentText: currentText,
            accumulated: accumulated,
            session: session,
            usedKeys: usedKeys,
            seed: seed
        ) {
            return profanity
        }

        if let advice = bullyingAdviceIfRequested(
            currentText: currentText,
            accumulated: accumulated,
            usedKeys: usedKeys,
            seed: seed,
            lang: lang
        ) {
            return advice
        }

        if let closing = closingReply(
            currentText: currentText,
            session: session,
            ctx: ctx,
            usedKeys: usedKeys,
            seed: seed
        ) {
            return closing
        }

        if LanguageSignals.isThanks(currentText) {
            return ChatReply(CompanionLanguage.thanksReply(seed: seed, lang: lang), emojis: ["🫂", "😊"], replyKey: "thanks")
        }

        if GameSignals.shouldAskGameTitle(currentText: currentText, session: session, usedKeys: usedKeys) {
            return ChatReply(
                CompanionLanguage.gameTitleAskReply(seed: seed, lang: lang, currentText: currentText),
                emojis: ["🎮", "👂", "✨"],
                replyKey: "game_ask_title"
            )
        }

        if let rankGrind = rankGrindAffirmReply(
            currentText: currentText,
            session: session,
            usedKeys: usedKeys,
            seed: seed,
            turnCount: session.turnCount,
            lang: lang
        ) {
            return rankGrind
        }

        if let pendingTone = session.pendingFollowUpTone {
            return FollowUpGuides.followUpReply(
                for: pendingTone,
                lang: lang,
                seed: seed,
                usedKeys: usedKeys
            )
        }

        if let scenarioReply = scenarioReply(
            ctx: ctx,
            accumulated: accumulated,
            currentText: currentText,
            usedKeys: usedKeys,
            seed: seed,
            turnCount: session.turnCount,
            lang: lang,
            session: session
        ) {
            return scenarioReply
        }

        if ctx.shift == .brightened {
            return ChatReply(
                CompanionLanguage.moodBrightenedReply(seed: seed, lang: lang),
                emojis: ["😊", "✨", "🌸"],
                replyKey: "shift_bright_\(session.turnCount)"
            )
        }

        if ctx.shift == .darkened {
            return ChatReply(
                CompanionLanguage.moodDarkenedReply(seed: seed, lang: lang),
                emojis: ["🫂", "💙"],
                replyKey: "shift_dark_\(session.turnCount)"
            )
        }

        if ctx.topicChanged {
            if LanguageSignals.isHeavyDistressEvent(currentText),
               let heavy = heavyDistressReply(
                   currentText: currentText,
                   usedKeys: usedKeys,
                   seed: seed,
                   turnCount: session.turnCount,
                   lang: lang
               ) {
                return heavy
            }
            if LanguageSignals.isHeavyDistressEvent(currentText) {
                return ChatReply(
                    CompanionLanguage.distressHoldReply(seed: seed, lang: lang),
                    emojis: ["🫂", "💙"],
                    replyKey: "distress_hold_\(session.turnCount)"
                )
            }
            if ctx.currentTone == .neutral {
                return ChatReply(
                    CompanionLanguage.topicPivotReply(seed: seed, lang: lang),
                    emojis: ["👂", "🌿"],
                    replyKey: "topic_pivot_\(session.turnCount)"
                )
            }
        }

        if shouldPrioritizeExhaustion(ctx: ctx, currentText: currentText) {
            return exhaustionScenarioOrPivotReply(
                currentText: currentText,
                accumulated: accumulated,
                usedKeys: usedKeys,
                seed: seed,
                turnCount: session.turnCount,
                lang: lang
            )
        }

        if ctx.effectiveTone == .positive {
            if let matched = matchPositiveSituation(in: ctx.focusText) {
                if let followUp = matched.followUp(ctx.focusText, usedKeys, seed) {
                    return followUp
                }
                return matched.comfort(ctx.focusText, .joy, seed)
            }
            return celebrateReply(
                currentText: currentText,
                accumulated: ctx.focusText,
                seed: seed,
                lang: lang
            )
        }

        if ctx.effectiveTone != .positive,
           let matched = matchNegativeSituation(in: ctx.focusText) {
            if let followUp = matched.followUp(ctx.focusText, usedKeys, seed) {
                return followUp
            }
            return matched.comfort(ctx.focusText, ctx.effectiveIntent, seed)
        }

        if ctx.effectiveTone != .positive,
           let topicComfort = comfortByTopic(accumulated: ctx.focusText, intent: ctx.effectiveIntent, seed: seed, lang: lang) {
            return topicComfort
        }

        if CompanionRules.shouldUseExhaustionPivot(
            currentText: currentText,
            accumulated: accumulated,
            ctx: ctx,
            scenarioMatched: false
        ) {
            return ChatReply(
                CompanionRules.exhaustionPivotReply(lang: lang),
                emojis: ["🫂", "🌿", "😊"],
                replyKey: "exhaustion_pivot_\(session.turnCount)"
            )
        }

        if CompanionRules.shouldUseFallbackListen(
            currentText: currentText,
            ctx: ctx,
            lang: lang,
            scenarioMatched: false
        ) {
            return ChatReply(
                CompanionRules.fallbackListenReply(lang: lang),
                emojis: ["👂", "🌿"],
                replyKey: "fallback_listen_\(session.turnCount)"
            )
        }

        return comfortByIntent(
            currentText: currentText,
            ctx: ctx,
            session: session,
            seed: seed,
            lang: lang
        )
    }

    /// DeepSeek 模式下仍必须走本地话术：危机、收尾、感谢、高敏感场景
    func localGuardReply(
        currentText: String,
        session: ConversationSession,
        usedKeys: Set<String>
    ) -> ChatReply? {
        let accumulated = session.accumulatedStory
        let ctx = EmotionalContextBuilder.build(currentText: currentText, session: session, analyzer: analyzer)
        let seed = CompanionLanguage.seed(session: session, text: currentText, usedKeys: usedKeys)
        let lang = session.userLanguage

        if let crisis = crisisReply(for: currentText, seed: seed, lang: lang) { return crisis }

        if let heavy = heavyDistressReply(
            currentText: currentText,
            usedKeys: usedKeys,
            seed: seed,
            turnCount: session.turnCount,
            lang: lang
        ) {
            return heavy
        }

        if let profanity = profanityBreakdownReply(
            currentText: currentText,
            accumulated: session.accumulatedStory,
            session: session,
            usedKeys: usedKeys,
            seed: seed
        ) {
            return profanity
        }

        if let advice = bullyingAdviceIfRequested(
            currentText: currentText,
            accumulated: accumulated,
            usedKeys: usedKeys,
            seed: seed,
            lang: lang
        ) {
            return advice
        }

        if let closing = closingReply(
            currentText: currentText,
            session: session,
            ctx: ctx,
            usedKeys: usedKeys,
            seed: seed
        ) {
            return closing
        }

        if LanguageSignals.isThanks(currentText) {
            return ChatReply(
                CompanionLanguage.thanksReply(seed: seed, lang: lang),
                emojis: ["🫂", "😊"],
                replyKey: "thanks"
            )
        }

        if let scenario = ScenarioLibrary.match(
            in: accumulated,
            current: currentText,
            tone: ctx.effectiveTone,
            currentOnly: ctx.matchCurrentOnly
        ), scenario.gentleOnly {
            return ScenarioLibrary.reply(
                for: scenario,
                usedKeys: usedKeys,
                seed: seed,
                turnCount: session.turnCount,
                lang: lang
            )
        }

        return nil
    }

    /// 开场时 DeepSeek 模式下的本地安全兜底
    func openingLocalGuardReply(for result: EmotionAnalysisResult, language: AppLanguage) -> ChatReply? {
        let text = result.userText
        let seed = CompanionLanguage.seed(session: nil, text: text, usedKeys: [])

        if let crisis = crisisReply(for: text, seed: seed, lang: language) { return crisis }

        if let heavy = heavyDistressReply(
            currentText: text,
            usedKeys: [],
            seed: seed,
            turnCount: 0,
            lang: language
        ) {
            return heavy
        }

        return nil
    }

    func openingReply(for result: EmotionAnalysisResult, language: AppLanguage) -> ChatReply {
        let text = result.userText
        let lang = language
        let seed = CompanionLanguage.seed(session: nil, text: text, usedKeys: [])

        if let crisis = crisisReply(for: text, seed: seed, lang: lang) { return crisis }

        if let heavy = heavyDistressReply(
            currentText: text,
            usedKeys: [],
            seed: seed,
            turnCount: 0,
            lang: lang
        ) {
            return heavy
        }

        if let profanity = profanityBreakdownReply(
            currentText: text,
            accumulated: text,
            session: nil,
            usedKeys: [],
            seed: seed,
            turnCount: 0
        ) {
            return profanity
        }

        if GameSignals.shouldAskGameTitle(currentText: text, priorUserTexts: [text], usedKeys: []) {
            return ChatReply(
                CompanionLanguage.gameTitleAskReply(seed: seed, lang: lang, currentText: text),
                emojis: ["🎮", "👂", "✨"],
                replyKey: "game_ask_title"
            )
        }

        if MoodQuickPick.isOkayMood(text, language: lang) {
            return ChatReply(
                CompanionLanguage.okayDayReply(lang: lang),
                emojis: ["🌿", "😊"],
                replyKey: "open_okay_day"
            )
        }

        if OkayMoodSignals.isOkayMood(text, language: lang),
           let okay = ScenarioLibrary.matchOkay(in: text, current: text, lang: lang) {
            return ScenarioLibrary.reply(
                for: okay,
                usedKeys: [],
                seed: seed,
                turnCount: 0,
                lang: lang
            )
        }

        let tone = detectTone(in: text)

        if let scenarioReply = scenarioReply(
            ctx: EmotionalContextBuilder.buildOpening(text: text, analyzer: analyzer),
            accumulated: text,
            currentText: text,
            usedKeys: [],
            seed: seed,
            turnCount: 0,
            lang: lang,
            session: nil
        ) {
            return scenarioReply
        }

        if tone == .positive {
            if let matched = matchPositiveSituation(in: text) {
                return matched.comfort(text, .joy, seed)
            }
            return joyOpening(text: text, seed: seed, lang: lang)
        }

        if let matched = matchNegativeSituation(in: text) {
            if let followUp = matched.followUp(text, [], seed) { return followUp }
            return matched.comfort(text, result.intent, seed)
        }

        if LanguageSignals.isEmotionOnly(text, lang: lang) {
            return emotionOpening(text: text, intent: result.intent, tone: tone, seed: seed, lang: lang)
        }

        if shouldPrioritizeExhaustion(ctx: EmotionalContextBuilder.buildOpening(text: text, analyzer: analyzer), currentText: text) {
            return exhaustionScenarioOrPivotReply(
                currentText: text,
                accumulated: text,
                usedKeys: [],
                seed: seed,
                turnCount: 0,
                lang: lang
            )
        }

        let openingCtx = EmotionalContextBuilder.buildOpening(text: text, analyzer: analyzer)
        if CompanionRules.shouldUseFallbackListen(
            currentText: text,
            ctx: openingCtx,
            lang: lang,
            scenarioMatched: false
        ) {
            return ChatReply(
                CompanionRules.fallbackListenReply(lang: lang),
                emojis: ["👂", "🌿"],
                replyKey: "fallback_listen_open"
            )
        }

        return comfortByIntent(
            currentText: text,
            ctx: openingCtx,
            session: nil,
            seed: seed,
            lang: lang
        )
    }

    // MARK: - 态度察觉

    private func detectTone(in text: String) -> SentimentTone {
        LanguageSignals.detectSentimentTone(in: text)
    }

    // MARK: - 升段冲分时长跟进

    private func rankGrindAffirmReply(
        currentText: String,
        session: ConversationSession,
        usedKeys: Set<String>,
        seed: Int,
        turnCount: Int,
        lang: AppLanguage
    ) -> ChatReply? {
        guard GameSignals.isRankGrindFollowUp(currentText: currentText, session: session) else {
            return nil
        }

        let matchAccumulated = GameSignals.recentUserStory(from: session)
        if let scenario = ScenarioLibrary.match(
            in: matchAccumulated,
            current: currentText,
            tone: .positive,
            currentOnly: true
        ), scenario.id == "game_rank_grind_time" {
            return ScenarioLibrary.reply(
                for: scenario,
                usedKeys: usedKeys,
                seed: seed,
                turnCount: turnCount,
                lang: lang
            )
        }

        return ChatReply(
            CompanionLanguage.pickB(
                zh: [
                    "两天！这也太不容易了，每一颗星都是一点点熬出来的，这份坚持真的值得被看见。",
                    "连冲两天，精力和心态都得扛住不少压力吧？能升上去说明你该得的，真的超棒！",
                ],
                en: [
                    "Two whole days! That's real grind — every rank point was earned.",
                    "Two days of pushing rank takes stamina and nerves. You absolutely deserve this.",
                ],
                lang: lang,
                seed: seed
            ),
            emojis: ["🏆", "💪", "✨"],
            replyKey: "game_rank_grind_affirm_\(turnCount)"
        )
    }

    // MARK: - 开心 / 成就回应
    private func scenarioReply(
        ctx: TurnEmotionalContext,
        accumulated: String,
        currentText: String,
        usedKeys: Set<String>,
        seed: Int,
        turnCount: Int,
        lang: AppLanguage,
        session: ConversationSession?
    ) -> ChatReply? {
        if ProfanityBreakdownHandler.shouldBypassScenarioMatch(for: currentText) {
            return nil
        }

        let matchAccumulated: String
        if let session, GameSignals.isRankGrindFollowUp(currentText: currentText, session: session) {
            matchAccumulated = GameSignals.recentUserStory(from: session)
        } else {
            matchAccumulated = accumulated
        }

        let story = matchAccumulated + " " + currentText
        if OkayMoodSignals.isOkayMood(currentText, language: lang),
           let okay = ScenarioLibrary.matchOkay(in: matchAccumulated, current: currentText, lang: lang) {
            return ScenarioLibrary.reply(
                for: okay,
                usedKeys: usedKeys,
                seed: seed,
                turnCount: turnCount,
                lang: lang
            )
        }

        if LanguageSignals.expressesExhaustion(story) || LanguageSignals.hasExhaustionCause(currentText),
           let exhaustion = ScenarioLibrary.matchExhaustion(in: matchAccumulated, current: currentText) {
            return ScenarioLibrary.reply(
                for: exhaustion,
                usedKeys: usedKeys,
                seed: seed,
                turnCount: turnCount,
                lang: lang
            )
        }

        guard let scenario = ScenarioLibrary.match(
            in: matchAccumulated,
            current: currentText,
            tone: ctx.effectiveTone,
            currentOnly: ctx.matchCurrentOnly
        ) else {
            return nil
        }
        var reply = ScenarioLibrary.reply(
            for: scenario,
            usedKeys: usedKeys,
            seed: seed,
            turnCount: turnCount,
            lang: lang,
            userStory: matchAccumulated + " " + currentText
        )

        if ctx.shift != nil || (ctx.topicChanged && !scenario.gentleOnly),
           let bridge = CompanionLanguage.conversationBridge(
               shift: ctx.shift,
               topicChanged: ctx.topicChanged,
               currentTone: ctx.currentTone,
               lang: lang,
               seed: seed + turnCount
           ) {
            reply = ChatReply(
                CompanionLanguage.weave([bridge, reply.text]),
                emojis: reply.emojis,
                replyKey: reply.replyKey + "|bridge"
            )
        }

        return reply
    }

    // MARK: - 开心 / 成就回应

    private func joyOpening(text: String, seed: Int, lang: AppLanguage) -> ChatReply {
        if LanguageSignals.isEmotionOnly(text, lang: lang)
            || text.contains("开心") || text.contains("高兴")
            || text.localizedCaseInsensitiveContains("happy") || text.localizedCaseInsensitiveContains("glad") {
            return ChatReply(
                CompanionLanguage.joyInvite(seed: seed, lang: lang),
                emojis: ["😊", "✨"],
                replyKey: "open_joy"
            )
        }
        return celebrateReply(currentText: text, accumulated: text, seed: seed, lang: lang)
    }

    private func celebrateReply(currentText: String, accumulated: String, seed: Int, lang: AppLanguage) -> ChatReply {
        let sub = CompanionLanguage.subject(from: accumulated, lang: lang)
        let lower = accumulated.lowercased()

        if accumulated.contains("第一名") || accumulated.contains("全班第一") || accumulated.contains("年级第一")
            || lower.contains("first place") || lower.contains("top of the class") || lower.contains("number one") {
            return ChatReply(
                CompanionLanguage.celebrateFirst(subject: sub, seed: seed, lang: lang),
                emojis: ["🎉", "✨", "💪"],
                replyKey: "celebrate_first"
            )
        }

        if accumulated.contains("满分") || accumulated.contains("100分") || accumulated.contains("最高分")
            || lower.contains("perfect score") || lower.contains("100") || lower.contains("highest score") {
            return ChatReply(
                CompanionLanguage.celebrateScore(subject: sub, seed: seed, lang: lang),
                emojis: ["🎉", "✨", "💪"],
                replyKey: "celebrate_score"
            )
        }

        if accumulated.contains("进步") || lower.contains("progress") || lower.contains("improved") {
            return ChatReply(
                CompanionLanguage.celebrateProgress(seed: seed, lang: lang),
                emojis: ["✨", "💪", "😊"],
                replyKey: "celebrate_progress"
            )
        }

        if accumulated.contains("考试") || accumulated.contains("考") || lower.contains("exam"), let sub {
            return ChatReply(
                CompanionLanguage.celebrateScore(subject: sub, seed: seed, lang: lang),
                emojis: ["😊", "✨", "📚"],
                replyKey: "celebrate_exam"
            )
        }

        if accumulated.contains("成功") || accumulated.contains("做到了") || accumulated.contains("通过了")
            || lower.contains("success") || lower.contains("did it") || lower.contains("passed") {
            return ChatReply(
                CompanionLanguage.celebrateGeneric(
                    touch: lang == .english ? "you did it" : "做到了",
                    seed: seed,
                    lang: lang
                ),
                emojis: ["🎉", "✨", "😊"],
                replyKey: "celebrate_success"
            )
        }

        let touch = CompanionLanguage.lightTouch(on: currentText, lang: lang)
        return ChatReply(
            CompanionLanguage.celebrateGeneric(touch: touch, seed: seed, lang: lang),
            emojis: ["😊", "✨", "🌸"],
            replyKey: "celebrate_gen"
        )
    }

    // MARK: - 情境匹配

    private func matchPositiveSituation(in text: String) -> PositiveSituationHandler? {
        PositiveSituationHandler.all.first { $0.matches(text) }
    }

    private func matchNegativeSituation(in text: String) -> NegativeSituationHandler? {
        NegativeSituationHandler.all.first { $0.matches(text) }
    }

    private func comfortByTopic(accumulated: String, intent: EmotionIntent, seed: Int, lang: AppLanguage) -> ChatReply? {
        if detectTone(in: accumulated) == .positive { return nil }
        if accumulated.contains("冤枉") || accumulated.contains("误解")
            || accumulated.localizedCaseInsensitiveContains("wronged") || accumulated.localizedCaseInsensitiveContains("misunderstood") {
            return ChatReply(
                CompanionLanguage.weave([
                    CompanionLanguage.wrongedLead(seed: seed, lang: lang),
                    lang == .english ? "Your hurt is valid." : "你的委屈是成立的。",
                ]),
                emojis: ["🫂", "🥺", "💙"],
                replyKey: "ctx_wronged"
            )
        }
        if (accumulated.contains("父母") || accumulated.contains("妈妈") || accumulated.contains("爸爸")
            || accumulated.localizedCaseInsensitiveContains("parent") || accumulated.localizedCaseInsensitiveContains("mom") || accumulated.localizedCaseInsensitiveContains("dad")),
           accumulated.contains("吵") || accumulated.contains("骂")
            || accumulated.localizedCaseInsensitiveContains("fight") || accumulated.localizedCaseInsensitiveContains("yelled") {
            return ChatReply(
                CompanionLanguage.pickB(
                    zh: ["和最亲近的人吵架，往往比跟外人吵更伤…你现在心里一定堵得慌。", "家里吵起来，话往往最扎心…你现在还好吗？"],
                    en: ["Fighting with someone close often hurts more than fighting a stranger… are you okay?", "Family arguments cut deep… how are you holding up?"],
                    lang: lang, seed: seed
                ),
                emojis: ["🫂", "🏠", "💙"],
                replyKey: "ctx_family_fight"
            )
        }
        if accumulated.contains("排挤") || accumulated.contains("孤立")
            || accumulated.localizedCaseInsensitiveContains("excluded") || accumulated.localizedCaseInsensitiveContains("left out") {
            return ChatReply(
                CompanionLanguage.pickB(
                    zh: ["被排挤、被孤立…那种痛，真的不好受。这不是你的错。", "落单的感觉最磨人…你不该独自承受这些。"],
                    en: ["Being excluded hurts… and it's not your fault.", "Feeling left out is brutal… you shouldn't carry this alone."],
                    lang: lang, seed: seed
                ),
                emojis: ["🫂", "💙"],
                replyKey: "ctx_bullied"
            )
        }
        return nil
    }

    private func comfortByIntent(
        currentText: String,
        ctx: TurnEmotionalContext,
        session: ConversationSession?,
        seed: Int,
        lang: AppLanguage
    ) -> ChatReply {
        if ctx.effectiveTone == .positive || ctx.effectiveIntent == .joy {
            return celebrateReply(
                currentText: currentText,
                accumulated: ctx.focusText,
                seed: seed,
                lang: lang
            )
        }

        if shouldPrioritizeExhaustion(ctx: ctx, currentText: currentText) {
            return exhaustionScenarioOrPivotReply(
                currentText: currentText,
                accumulated: session?.accumulatedStory ?? ctx.focusText,
                usedKeys: session?.usedReplyKeys ?? [],
                seed: seed,
                turnCount: session?.turnCount ?? 0,
                lang: lang
            )
        }

        if LanguageSignals.isEmotionOnly(currentText, lang: lang) {
            return emotionOpening(
                text: currentText,
                intent: ctx.effectiveIntent,
                tone: ctx.effectiveTone,
                seed: seed,
                lang: lang
            )
        }

        if ctx.topicChanged {
            if LanguageSignals.isHeavyDistressEvent(currentText) {
                return ChatReply(
                    CompanionLanguage.distressHoldReply(seed: seed, lang: lang),
                    emojis: ["🫂", "💙"],
                    replyKey: "distress_hold_intent_\(session?.turnCount ?? 0)"
                )
            }
            let anchor = CompanionLanguage.anchorPhrase(from: currentText, lang: lang)
                ?? CompanionLanguage.lightTouch(on: currentText, lang: lang)
            if let anchor, ctx.currentTone != .positive {
                return ChatReply(
                    CompanionLanguage.continueWithEmpathy(
                        intent: ctx.effectiveIntent,
                        anchor: anchor,
                        seed: seed,
                        turnCount: session?.turnCount ?? 0,
                        lang: lang
                    ),
                    emojis: emojisFor(intent: ctx.effectiveIntent),
                    replyKey: "topic_continue_\(session?.turnCount ?? 0)"
                )
            }
        }

        let threshold = lang == .english ? 24 : 12
        if ctx.focusText.count >= threshold {
            let anchor = CompanionLanguage.anchorPhrase(from: currentText, lang: lang)
            return ChatReply(
                CompanionLanguage.continueWithEmpathy(
                    intent: ctx.effectiveIntent,
                    anchor: anchor,
                    seed: seed,
                    turnCount: session?.turnCount ?? 0,
                    lang: lang
                ),
                emojis: emojisFor(intent: ctx.effectiveIntent),
                replyKey: "ctx_continue_\(session?.turnCount ?? 0)"
            )
        }

        return emotionOpening(
            text: currentText.isEmpty ? ctx.focusText : currentText,
            intent: ctx.effectiveIntent,
            tone: ctx.effectiveTone,
            seed: seed,
            lang: lang
        )
    }

    private func emotionOpening(text: String, intent: EmotionIntent, tone: SentimentTone, seed: Int, lang: AppLanguage) -> ChatReply {
        if tone == .positive || intent == .joy {
            return joyOpening(text: text, seed: seed, lang: lang)
        }

        if intent == .exhaustion || LanguageSignals.expressesExhaustion(text) {
            return exhaustionScenarioOrPivotReply(
                currentText: text,
                accumulated: text,
                usedKeys: [],
                seed: seed,
                turnCount: 0,
                lang: lang
            )
        }

        let touch = CompanionLanguage.lightTouch(on: text, lang: lang)
        let message: String
        switch intent {
        case .frustration, .sadness:
            message = CompanionLanguage.sadnessInvite(seed: seed, touch: touch, lang: lang)
        case .anger:
            message = CompanionLanguage.angerInvite(seed: seed, touch: touch, lang: lang)
        case .anxiety, .fear:
            message = CompanionLanguage.fearInvite(seed: seed, touch: touch, lang: lang)
        default:
            message = CompanionLanguage.neutralInvite(seed: seed, touch: touch, lang: lang)
        }

        return ChatReply(message, emojis: emojisFor(intent: intent), replyKey: "open_\(intent.rawValue)")
    }

    // MARK: - 疲惫：先体贴，不追问原因

    private func shouldPrioritizeExhaustion(ctx: TurnEmotionalContext, currentText: String) -> Bool {
        guard ctx.effectiveTone != .positive else { return false }
        guard ctx.shift != .brightened else { return false }

        if ctx.topicChanged && !LanguageSignals.expressesExhaustion(currentText) {
            return false
        }

        if LanguageSignals.expressesExhaustion(currentText) {
            if ctx.currentTone == .positive { return false }
            return true
        }

        guard LanguageSignals.expressesExhaustion(ctx.focusText) else { return false }
        if ctx.topicChanged { return false }
        if LanguageSignals.hasExamPain(ctx.focusText, tone: ctx.effectiveTone) { return false }
        return ctx.effectiveIntent == .exhaustion
            || isTiredOnlyStory(ctx.focusText)
            || LanguageSignals.hasExhaustionCause(currentText)
    }

    // MARK: - 劳累：场景库优先，接不住则转向开心事

    private func exhaustionScenarioOrPivotReply(
        currentText: String,
        accumulated: String,
        usedKeys: Set<String>,
        seed: Int,
        turnCount: Int,
        lang: AppLanguage
    ) -> ChatReply {
        if let exhaustion = ScenarioLibrary.matchExhaustion(in: accumulated, current: currentText) {
            return ScenarioLibrary.reply(
                for: exhaustion,
                usedKeys: usedKeys,
                seed: seed,
                turnCount: turnCount,
                lang: lang
            )
        }
        return ChatReply(
            CompanionRules.exhaustionPivotReply(lang: lang),
            emojis: ["🫂", "🌿", "😊"],
            replyKey: "exhaustion_pivot_\(turnCount)"
        )
    }

    private func isTiredOnlyStory(_ text: String) -> Bool {
        guard LanguageSignals.expressesExhaustion(text) else { return false }
        guard !LanguageSignals.hasExhaustionCause(text) else { return false }
        let fillers = ["我", "好", "很", "太", "啊", "呀", "今天", "现在", "真的", "就是", "有点", "有些", "，", " ",
                       "i", "am", "im", "so", "very", "today", "now", "really", "just", "a", "bit", ",", " "]
        var stripped = text.lowercased()
        for word in LanguageSignals.exhaustionZH + LanguageSignals.exhaustionEN {
            stripped = stripped.replacingOccurrences(of: word.lowercased(), with: "")
        }
        for filler in fillers {
            stripped = stripped.replacingOccurrences(of: filler, with: "")
        }
        return stripped.trimmingCharacters(in: .whitespacesAndNewlines).count <= 2
    }

    private func emojisFor(intent: EmotionIntent) -> [String] {
        switch intent {
        case .joy: ["😊", "✨"]
        case .anger: ["🫂", "💙"]
        case .exhaustion: ["🫂", "🍵"]
        default: ["🫂", "👂"]
        }
    }

    // MARK: - 情绪崩溃 / 辱骂应对（本地 AI）

    private func profanityBreakdownReply(
        currentText: String,
        accumulated: String,
        session: ConversationSession?,
        usedKeys: Set<String>,
        seed: Int,
        turnCount: Int = 0
    ) -> ChatReply? {
        let lang = session?.userLanguage ?? .chinese
        let effectiveTurn = session?.turnCount ?? turnCount
        let attackStreak = session?.profanityAttackStreak ?? 0
        let boundaryStep = session?.profanityBoundaryStep ?? 0
        let awaitingCalm = session?.awaitingProfanityCalmCheck ?? false

        if ProfanityBreakdownHandler.shouldOfferCalmGuidance(
            currentText: currentText,
            awaitingCalmCheck: awaitingCalm
        ) {
            return ProfanityBreakdownHandler.calmDownGuidanceReply(
                lang: lang,
                seed: seed,
                usedKeys: usedKeys,
                turnCount: effectiveTurn
            )
        }

        guard ProfanityBreakdownHandler.containsProfanity(currentText) else { return nil }

        let tier = ProfanityBreakdownHandler.classify(
            currentText: currentText,
            accumulated: accumulated,
            attackStreak: attackStreak
        )
        guard tier != .none else { return nil }

        return ProfanityBreakdownHandler.reply(
            tier: tier,
            boundaryStep: boundaryStep,
            lang: lang,
            seed: seed,
            usedKeys: usedKeys,
            turnCount: effectiveTurn
        )
    }

    // MARK: - 收尾话术（情绪落地后的自然收束）

    private func closingReply(
        currentText: String,
        session: ConversationSession,
        ctx: TurnEmotionalContext,
        usedKeys: Set<String>,
        seed: Int
    ) -> ChatReply? {
        guard ClosingSignals.shouldUseClosing(
            currentText: currentText,
            session: session,
            ctx: ctx
        ) else { return nil }
        guard let scenario = ClosingSignals.detectScenario(
            in: currentText,
            session: session,
            ctx: ctx
        ) else { return nil }
        let style = ClosingSignals.resolveStyle(
            scenario: scenario,
            currentText: currentText,
            session: session,
            ctx: ctx
        )
        return ClosingLanguage.reply(
            style: style,
            lang: session.userLanguage,
            seed: seed,
            usedKeys: usedKeys
        )
    }

    /// 霸凌场景下用户主动问「怎么办」— 温和给选项，不强迫告老师 / 反抗
    private func bullyingAdviceIfRequested(
        currentText: String,
        accumulated: String,
        usedKeys: Set<String>,
        seed: Int,
        lang: AppLanguage
    ) -> ChatReply? {
        guard LanguageSignals.isSeekingAdvice(currentText) else { return nil }
        let story = accumulated + " " + currentText
        guard LanguageSignals.isSchoolBullyingContext(story) else { return nil }
        return ScenarioLibrary.bullyingAdviceReply(
            lang: lang,
            seed: seed,
            usedKeys: usedKeys,
            story: story
        )
    }

    // MARK: - 重大打击（被辞退等）— 只共情，不追问

    private func heavyDistressReply(
        currentText: String,
        usedKeys: Set<String>,
        seed: Int,
        turnCount: Int,
        lang: AppLanguage
    ) -> ChatReply? {
        guard LanguageSignals.isHeavyDistressEvent(currentText) else { return nil }
        if let scenario = ScenarioLibrary.matchHeavyDistress(in: currentText) {
            return ScenarioLibrary.reply(
                for: scenario,
                usedKeys: usedKeys,
                seed: seed,
                turnCount: turnCount,
                lang: lang
            )
        }
        return ChatReply(
            CompanionLanguage.distressHoldReply(seed: seed, lang: lang),
            emojis: ["🫂", "💙"],
            replyKey: "distress_hold_\(turnCount)"
        )
    }

    private func crisisReply(for text: String, seed: Int, lang: AppLanguage) -> ChatReply? {
        if LanguageSignals.containsAny(LanguageSignals.crisisSevereZH + LanguageSignals.crisisSevereEN, in: text) {
            return ChatReply(
                CompanionLanguage.pickB(
                    zh: [
                        "听到你这么说，我很担心你…如果可能，请找一位信任的人说说。此刻，我先陪着你。",
                        "你这么说，我心里一紧…请先别一个人扛着，找身边信任的人说说，我在这儿。",
                    ],
                    en: [
                        "Hearing you say that worries me… if you can, please reach out to someone you trust. I'm here right now.",
                        "That makes my chest tighten… please don't carry this alone — talk to someone you trust. I'm staying with you.",
                    ],
                    lang: lang, seed: seed
                ),
                emojis: ["🫂", "💙"],
                replyKey: "crisis"
            )
        }
        if LanguageSignals.containsAny(LanguageSignals.crisisHeavyZH + LanguageSignals.crisisHeavyEN, in: text) {
            return ChatReply(
                CompanionLanguage.pickB(
                    zh: [
                        "撑到这一步，真的太难了…先别逼自己好起来，我在这儿。",
                        "已经扛了这么久了…此刻不用想解决办法，先喘口气，我陪着你。",
                    ],
                    en: [
                        "You've held on so long… don't force yourself to feel better yet. I'm here.",
                        "You've been carrying this a while… no need to fix anything right now. Just breathe — I'm with you.",
                    ],
                    lang: lang, seed: seed
                ),
                emojis: ["🫂", "💙", "🌙"],
                replyKey: "crisis_heavy"
            )
        }
        return nil
    }
}

// MARK: - 正面情境

private struct PositiveSituationHandler: Sendable {
    let keywords: [String]
    let followUp: @Sendable (String, Set<String>, Int) -> ChatReply?
    let comfort: @Sendable (String, EmotionIntent, Int) -> ChatReply

    func matches(_ text: String) -> Bool {
        keywords.contains { text.contains($0) || text.localizedCaseInsensitiveContains($0) }
    }

    static let all: [PositiveSituationHandler] = [
        PositiveSituationHandler(
            keywords: ["第一名", "全班第一", "年级第一", "考了第一", "排第一", "first place", "top of the class", "number one", "#1"],
            followUp: { acc, used, seed in
                let lang = AppLanguage.detect(from: acc)
                if acc.contains("开心") || acc.contains("高兴") || acc.localizedCaseInsensitiveContains("happy"),
                   !acc.contains("考试") && !acc.contains("数学") && !acc.contains("语文") && !acc.localizedCaseInsensitiveContains("exam"),
                   !used.contains("ask_joy_detail") {
                    return ChatReply(
                        CompanionLanguage.weave([
                            CompanionLanguage.pickB(
                                zh: ["听着就替你高兴！", "这语气听着就轻快！", "好事呀～"],
                                en: ["So happy for you!", "You sound thrilled!", "Good news!"],
                                lang: lang, seed: seed
                            ),
                            CompanionLanguage.ask(.joyDetail, seed: seed, lang: lang),
                        ]),
                        emojis: ["😊", "👂"],
                        replyKey: "ask_joy_detail"
                    )
                }
                return nil
            },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                let sub = CompanionLanguage.subject(from: acc, lang: lang)
                return ChatReply(
                    CompanionLanguage.celebrateFirst(subject: sub, seed: seed, lang: lang),
                    emojis: ["🎉", "✨", "💪"],
                    replyKey: "comfort_first"
                )
            }
        ),
        PositiveSituationHandler(
            keywords: ["满分", "100分", "最高分", "考得好", "成绩很好", "perfect score", "highest score", "great score"],
            followUp: { _, _, _ in nil },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                let sub = CompanionLanguage.subject(from: acc, lang: lang)
                return ChatReply(
                    CompanionLanguage.celebrateScore(subject: sub, seed: seed, lang: lang),
                    emojis: ["🎉", "✨", "💪"],
                    replyKey: "comfort_high_score"
                )
            }
        ),
        PositiveSituationHandler(
            keywords: ["进步", "提高了", "比上次好", "progress", "improved", "better than before"],
            followUp: { _, _, _ in nil },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                return ChatReply(
                    CompanionLanguage.celebrateProgress(seed: seed, lang: lang),
                    emojis: ["✨", "💪", "😊"],
                    replyKey: "comfort_progress"
                )
            }
        ),
    ]
}

// MARK: - 负面情境

private struct NegativeSituationHandler: Sendable {
    let keywords: [String]
    let followUp: @Sendable (String, Set<String>, Int) -> ChatReply?
    let comfort: @Sendable (String, EmotionIntent, Int) -> ChatReply

    func matches(_ text: String) -> Bool {
        guard ContextualResponder.detectToneStatic(in: text) != .positive else { return false }
        return keywords.contains { text.contains($0) || text.localizedCaseInsensitiveContains($0) }
    }

    static let all: [NegativeSituationHandler] = [
        NegativeSituationHandler(
            keywords: ["会做的", "没做出来", "没做出", "明明会", "本该会", "knew how", "couldn't solve", "couldn't finish", "blanked out"],
            followUp: { acc, used, seed in
                let lang = AppLanguage.detect(from: acc)
                if !mentionsSubject(acc), !used.contains("ask_subject") {
                    return ChatReply(
                        CompanionLanguage.weave([
                            CompanionLanguage.examMissedLead(seed: seed, lang: lang),
                            CompanionLanguage.ask(.examSubject, seed: seed, lang: lang),
                        ]),
                        emojis: ["👂", "🥺"],
                        replyKey: "ask_subject"
                    )
                }
                if mentionsSubject(acc), !mentionsCause(acc), !used.contains("ask_cause") {
                    let sub = subjectName(from: acc, lang: lang)
                    return ChatReply(
                        CompanionLanguage.ask(.examCause(subject: sub), seed: seed, lang: lang),
                        emojis: ["👂", "🫂"],
                        replyKey: "ask_cause"
                    )
                }
                if mentionsSubject(acc), mentionsCause(acc), !used.contains("ask_feeling") {
                    return ChatReply(
                        CompanionLanguage.ask(.examFeeling, seed: seed, lang: lang),
                        emojis: ["👂", "🥺"],
                        replyKey: "ask_feeling"
                    )
                }
                return nil
            },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                let sub = mentionsSubject(acc) ? subjectName(from: acc, lang: lang) : nil
                return ChatReply(
                    CompanionLanguage.comfortExamMissed(subject: sub, seed: seed, lang: lang),
                    emojis: ["🫂", "💪", "✨"],
                    replyKey: "comfort_exam_missed"
                )
            }
        ),
        NegativeSituationHandler(
            keywords: ["真实水平", "没发挥", "发挥失常", "考砸了", "考糟", "没考好", "underperformed", "didn't do well", "bad grade", "choked"],
            followUp: { acc, used, seed in
                let lang = AppLanguage.detect(from: acc)
                if !mentionsSubject(acc), !used.contains("ask_subject") {
                    return ChatReply(
                        CompanionLanguage.weave([
                            CompanionLanguage.examUnderperformLead(seed: seed, lang: lang),
                            CompanionLanguage.ask(.examSubject, seed: seed, lang: lang),
                        ]),
                        emojis: ["👂", "📚"],
                        replyKey: "ask_subject"
                    )
                }
                return nil
            },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                return ChatReply(
                    CompanionLanguage.comfortExamUnder(seed: seed, lang: lang),
                    emojis: ["🫂", "💪", "✨"],
                    replyKey: "comfort_exam_under"
                )
            }
        ),
        NegativeSituationHandler(
            keywords: ["脑子空白", "太紧张", "手抖", "慌", "来不及", "时间不够", "mind went blank", "so nervous", "shaking", "ran out of time"],
            followUp: { acc, used, seed in
                let lang = AppLanguage.detect(from: acc)
                if (acc.contains("考试") || acc.contains("考") || acc.localizedCaseInsensitiveContains("exam")),
                   !mentionsSubject(acc), !used.contains("ask_subject") {
                    return ChatReply(
                        CompanionLanguage.weave([
                            CompanionLanguage.examNervesLead(seed: seed, lang: lang),
                            CompanionLanguage.ask(.examSubject, seed: seed, lang: lang),
                        ]),
                        emojis: ["👂", "🥺"],
                        replyKey: "ask_subject"
                    )
                }
                return nil
            },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                return ChatReply(
                    CompanionLanguage.comfortExamNerves(seed: seed, lang: lang),
                    emojis: ["🫂", "🌿", "💙"],
                    replyKey: "comfort_exam_nerves"
                )
            }
        ),
        NegativeSituationHandler(
            keywords: ["偷拿", "偷了", "被偷", "拿走我的", "动了我的", "stolen", "took my", "without asking"],
            followUp: { acc, used, seed in
                let lang = AppLanguage.detect(from: acc)
                if !used.contains("ask_what") {
                    return ChatReply(
                        CompanionLanguage.weave([
                            CompanionLanguage.stolenLead(seed: seed, lang: lang),
                            CompanionLanguage.ask(.whatItem, seed: seed, lang: lang),
                        ]),
                        emojis: ["👂", "🛡️"],
                        replyKey: "ask_what"
                    )
                }
                return nil
            },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                let item = extractItem(from: acc, lang: lang).map { lang == .english ? "your \($0)" : "你的\($0)" }
                    ?? (lang == .english ? "your things" : "你的东西")
                return ChatReply(
                    CompanionLanguage.pickB(
                        zh: [
                            "\(item)被擅自拿走，边界被跨过了，生气是应该的。",
                            "没经过同意就动\(item)，换谁都会火大。",
                        ],
                        en: [
                            "\(item.capitalized) were taken without asking — your anger makes sense.",
                            "Someone touched \(item) without consent. Anyone would be upset.",
                        ],
                        lang: lang, seed: seed
                    ),
                    emojis: ["🫂", "🛡️", "💙"],
                    replyKey: "comfort_stolen"
                )
            }
        ),
        NegativeSituationHandler(
            keywords: ["冤枉", "误解", "错怪", "不是我做的", "背锅", "wronged", "misunderstood", "blamed me", "not my fault"],
            followUp: { acc, used, seed in
                let lang = AppLanguage.detect(from: acc)
                if !used.contains("ask_who") {
                    return ChatReply(
                        CompanionLanguage.weave([
                            CompanionLanguage.wrongedLead(seed: seed, lang: lang),
                            CompanionLanguage.ask(.who, seed: seed, lang: lang),
                        ]),
                        emojis: ["👂", "🥺"],
                        replyKey: "ask_who"
                    )
                }
                return nil
            },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                return ChatReply(
                    CompanionLanguage.pickB(
                        zh: ["被冤枉、被误解，委屈是真实的。你的感受本身就成立。", "明明不是你做的，却要背这个锅——太不公平了。"],
                        en: ["Being blamed wrongly — your hurt is real and valid.", "It wasn't your fault but you took the fall. That's unfair."],
                        lang: lang, seed: seed
                    ),
                    emojis: ["🫂", "🥺", "💙"],
                    replyKey: "comfort_wronged"
                )
            }
        ),
        NegativeSituationHandler(
            keywords: ["吵架", "争吵", "吵起来", "骂了我", "fight", "argument", "yelled at me", "argued"],
            followUp: { acc, used, seed in
                let lang = AppLanguage.detect(from: acc)
                if !mentionsPerson(acc), !used.contains("ask_who") {
                    return ChatReply(
                        CompanionLanguage.weave([
                            CompanionLanguage.argumentLead(seed: seed, lang: lang),
                            CompanionLanguage.ask(.who, seed: seed, lang: lang),
                        ]),
                        emojis: ["👂", "💙"],
                        replyKey: "ask_who"
                    )
                }
                if mentionsPerson(acc), !used.contains("ask_detail") {
                    return ChatReply(
                        CompanionLanguage.ask(.whatHappened, seed: seed, lang: lang),
                        emojis: ["👂", "🫂"],
                        replyKey: "ask_detail"
                    )
                }
                return nil
            },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                return ChatReply(
                    CompanionLanguage.pickB(
                        zh: ["吵完架心里还堵着…你的生气和委屈，都是真实的。", "争执过后，往往又气又委屈，这两种感受可以同时存在。"],
                        en: ["After a fight, the hurt often lingers… anger and sadness can both be true.", "Arguments leave you tangled up — both anger and hurt make sense."],
                        lang: lang, seed: seed
                    ),
                    emojis: ["🫂", "💙"],
                    replyKey: "comfort_argument"
                )
            }
        ),
        NegativeSituationHandler(
            keywords: ["还是难受", "还是难过", "还是气", "好不了", "没用", "still hurts", "still sad", "still angry", "can't get over"],
            followUp: { _, _, _ in nil },
            comfort: { acc, _, seed in
                let lang = AppLanguage.detect(from: acc)
                if acc.contains("考试") || acc.contains("考") || acc.localizedCaseInsensitiveContains("exam") {
                    return ChatReply(
                        CompanionLanguage.pickB(
                            zh: ["考试的事，心里还是堵…这种「还没过去」的感觉很正常。", "考完了，情绪还没散…这很常见，不用逼自己马上好起来。"],
                            en: ["The exam still sits heavy… that 'not over yet' feeling is normal.", "The test is done but the feelings aren't — that's common. No need to rush healing."],
                            lang: lang, seed: seed
                        ),
                        emojis: ["🫂", "🌿"],
                        replyKey: "comfort_still_exam"
                    )
                }
                return ChatReply(
                    CompanionLanguage.pickB(
                        zh: ["还是难受…有些感受不会一下子消失，这很正常。", "还痛着，对吗？那就先让它在那儿，我陪你待着。"],
                        en: ["Still hurting… some feelings don't fade quickly, and that's okay.", "Still painful, huh? Let it be there for now — I'll stay with you."],
                        lang: lang, seed: seed
                    ),
                    emojis: ["🫂", "💙"],
                    replyKey: "comfort_still_gen"
                )
            }
        ),
    ]
}

extension ContextualResponder {
    static func detectToneStatic(in text: String) -> SentimentTone {
        LanguageSignals.detectSentimentTone(in: text)
    }
}

// MARK: - Helpers

private func mentionsSubject(_ text: String) -> Bool {
    LanguageSignals.mentionsExamSubject(text)
}

private func mentionsCause(_ text: String) -> Bool {
    let zh = ["紧张", "时间", "来不及", "忘了", "脑子空白", "手抖", "压力", "慌", "粗心", "因为"]
    let en = ["nervous", "time", "not enough time", "forgot", "blank", "shaking", "pressure", "panic", "careless", "because"]
    return LanguageSignals.containsAny(zh + en, in: text)
}

private func subjectName(from text: String, lang: AppLanguage) -> String {
    LanguageSignals.examSubjectName(from: text, lang: lang)
}

private func mentionsPerson(_ text: String) -> Bool {
    LanguageSignals.mentionsPerson(text)
}

private func extractItem(from text: String, lang: AppLanguage) -> String? {
    LanguageSignals.extractItem(from: text, lang: lang)
}
