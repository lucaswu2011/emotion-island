import Foundation

/// 场景话术库 — 根据用户内容与态度匹配模板，多轮不重复
enum ScenarioLibrary {

    struct Template: Sendable {
        let id: String
        let keywords: [String]
        let tone: SentimentTone
        let priority: Int
        let responses: [String]
        let followUps: [String]
        let emojis: [String]
        /// 英文主回复；为空时英文界面回退到 `responses`
        let responsesEN: [String]
        /// 英文引导语；为空时回退到 `followUps`
        let followUpsEN: [String]
        /// 为 true 时不自动拼接 followUp（重大打击类场景）
        let gentleOnly: Bool
        /// 为 true 时仅输出安抚主回复，绝不拼接引导反问（校园霸凌等）
        let comfortOnly: Bool

        init(
            id: String,
            keywords: [String],
            tone: SentimentTone,
            priority: Int,
            responses: [String],
            followUps: [String],
            emojis: [String],
            responsesEN: [String] = [],
            followUpsEN: [String] = [],
            gentleOnly: Bool = false,
            comfortOnly: Bool = false
        ) {
            self.id = id
            self.keywords = keywords
            self.tone = tone
            self.priority = priority
            self.responses = responses
            self.followUps = followUps
            self.emojis = emojis
            self.responsesEN = responsesEN
            self.followUpsEN = followUpsEN
            self.gentleOnly = gentleOnly
            self.comfortOnly = comfortOnly
        }

        func responses(for lang: AppLanguage) -> [String] {
            if lang == .english, !responsesEN.isEmpty { return responsesEN }
            return responses
        }

        func followUps(for lang: AppLanguage) -> [String] {
            if lang == .english, !followUpsEN.isEmpty { return followUpsEN }
            return followUps
        }

        func matchScore(in text: String) -> Int {
            let hits = keywords.filter { text.localizedCaseInsensitiveContains($0) }.count
            guard hits > 0 else { return 0 }
            return hits * 10 + priority
        }
    }

    // MARK: - 匹配

    static func match(
        in accumulated: String,
        current: String,
        tone: SentimentTone,
        currentOnly: Bool = false
    ) -> Template? {
        var matchTone = resolveMatchTone(accumulated: accumulated, current: current, tone: tone)
        var useCurrentOnly = currentOnly

        if LanguageSignals.isExamFailThread(accumulated: accumulated, current: current) {
            matchTone = .negative
            useCurrentOnly = false
        }

        if let bullying = matchSchoolBullying(in: accumulated, current: current) {
            return bullying
        }

        if GameSignals.isRankGrindDurationAnswer(current),
           GameSignals.isRankUpThread(accumulated + " " + current),
           let grind = bestMatch(
               in: accumulated,
               current: current,
               pool: allPositiveScenarios(),
               currentOnly: true
           ),
           grind.template.id == "game_rank_grind_time" {
            return grind.template
        }

        if let primary = bestMatch(
            in: accumulated,
            current: current,
            pool: pool(for: matchTone),
            currentOnly: useCurrentOnly
        ) {
            if matchTone != .neutral || primary.score >= 18 {
                return primary.template
            }
            if matchTone == .neutral {
                let fallbacks = [
                    bestMatch(in: accumulated, current: current, pool: allNegativeScenarios(), currentOnly: useCurrentOnly),
                    bestMatch(in: accumulated, current: current, pool: allPositiveScenarios(), currentOnly: useCurrentOnly),
                ].compactMap { $0 }
                if let best = fallbacks.max(by: { $0.score < $1.score }), best.score >= 18 {
                    return best.template
                }
            }
            return primary.template
        }

        // 陈述句常被判为中性，且没有弱中性场景命中
        if matchTone == .neutral {
            let fallbacks = [
                bestMatch(in: accumulated, current: current, pool: allNegativeScenarios(), currentOnly: useCurrentOnly),
                bestMatch(in: accumulated, current: current, pool: allPositiveScenarios(), currentOnly: useCurrentOnly),
            ].compactMap { $0 }
            if let best = fallbacks.max(by: { $0.score < $1.score }), best.score >= 18 {
                return best.template
            }
        }

        return nil
    }

    private static func resolveMatchTone(
        accumulated: String,
        current: String,
        tone: SentimentTone
    ) -> SentimentTone {
        if GameSignals.isRankGrindDurationAnswer(current),
           GameSignals.isRankUpThread(accumulated + " " + current) {
            return .positive
        }
        if GameSignals.isRankUpThread(current),
           !GameSignals.hasGachaDistress(current),
           tone == .neutral {
            return .positive
        }
        return tone
    }

    /// 「还行」模块 — 平平淡淡、不好不坏的中性平稳状态
    static func matchOkay(
        in accumulated: String,
        current: String,
        lang: AppLanguage
    ) -> Template? {
        let story = accumulated + " " + current
        guard OkayMoodSignals.isOkayMood(current, language: lang)
            || OkayMoodSignals.isOkayMood(story, language: lang) else {
            return nil
        }
        return bestMatch(
            in: accumulated,
            current: current,
            pool: okayNeutral,
            currentOnly: false
        )?.template
    }

    /// 劳累场景 — 有疲惫信号时优先于泛化回复
    static func matchExhaustion(in accumulated: String, current: String) -> Template? {
        let story = accumulated + " " + current
        guard LanguageSignals.expressesExhaustion(story) || LanguageSignals.hasExhaustionCause(story) else {
            return nil
        }
        return bestMatch(
            in: accumulated,
            current: current,
            pool: exhaustionNegative,
            currentOnly: false
        )?.template
    }

    /// 被辞退、裁员等重大打击 — 不受语气/话题切换干扰，优先匹配
    static func matchHeavyDistress(in text: String) -> Template? {
        if let bullying = bestMatch(
            in: text,
            current: text,
            pool: schoolBullyingNegative,
            currentOnly: true
        )?.template {
            return bullying
        }
        if let dv = bestMatch(
            in: text,
            current: text,
            pool: domesticViolenceNegative,
            currentOnly: true
        )?.template {
            return dv
        }
        return bestMatch(
            in: text,
            current: text,
            pool: workCrisisNegative,
            currentOnly: true
        )?.template
    }

    /// 霸凌高敏感场景 — 优先于通用负向匹配
    static func matchSchoolBullying(in accumulated: String, current: String) -> Template? {
        let story = accumulated + " " + current
        guard LanguageSignals.isSchoolBullyingContext(story) else { return nil }

        if let matched = bestMatch(
            in: accumulated,
            current: current,
            pool: schoolBullyingNegative.filter { $0.id != "bully_generic_hold" },
            currentOnly: false
        )?.template {
            return matched
        }

        return schoolBullyingNegative.first { $0.id == "bully_generic_hold" }
    }

    private static func pool(for tone: SentimentTone) -> [Template] {
        switch tone {
        case .positive: allPositiveScenarios()
        case .negative: allNegativeScenarios()
        case .neutral: allNeutralScenarios()
        }
    }

    private static func bestMatch(
        in accumulated: String,
        current: String,
        pool: [Template],
        currentOnly: Bool
    ) -> (template: Template, score: Int)? {
        let combined = accumulated + " " + current
        var best: (Template, Int)?
        for scenario in pool {
            if GameSignals.shouldSuppressNegativeGamingScenario(
                id: scenario.id,
                accumulated: accumulated,
                current: current
            ) {
                continue
            }
            if scenario.id == "exam_good_subject_generic" || scenario.id == "exam_fail_subject_generic",
               LanguageSignals.mentionsExamSubject(combined) {
                continue
            }
            if scenario.id.hasPrefix("exam_good_"), LanguageSignals.hasExamFailureContext(combined) {
                continue
            }
            let score: Int
            if currentOnly {
                score = scenario.matchScore(in: current)
            } else {
                score = max(scenario.matchScore(in: current), scenario.matchScore(in: combined) - 2)
            }
            guard score > 0 else { continue }
            if best == nil || score > best!.1 { best = (scenario, score) }
        }
        guard let best else { return nil }
        return (best.0, best.1)
    }

    static func reply(
        for scenario: Template,
        usedKeys: Set<String>,
        seed: Int,
        turnCount: Int,
        lang: AppLanguage = .chinese,
        userStory: String = ""
    ) -> ChatReply {
        let base = "sc_\(scenario.id)"
        let pool = scenario.responses(for: lang)
        let skipFollowUp = scenario.comfortOnly
        let customFollowPool = (!skipFollowUp && scenario.gentleOnly) ? scenario.followUps(for: lang) : []
        let usedResponses = pool.indices.filter { isKeyUsed("\(base)_r\($0)", in: usedKeys) }
        let usedCustomFollowUps = customFollowPool.indices.filter {
            isKeyUsed(FollowUpGuides.customGuideKey(tone: scenario.tone, index: $0), in: usedKeys)
        }

        // 主回复还没用完 → 选一条未用过的
        if usedResponses.count < pool.count {
            let idx = pickUnused(from: pool.count, used: usedResponses, seed: seed)
            var text = pool[idx]
            var keys = ["\(base)_r\(idx)"]

            // 约 2/3 轮次轻轻带一句引导；霸凌等 comfortOnly 场景绝不反问
            if !skipFollowUp, (seed + turnCount) % 3 != 0 {
                if scenario.gentleOnly,
                   !customFollowPool.isEmpty,
                   usedCustomFollowUps.count < customFollowPool.count {
                    let fIdx = pickUnused(from: customFollowPool.count, used: usedCustomFollowUps, seed: seed + 7)
                    text = CompanionLanguage.weave([text, customFollowPool[fIdx]])
                    keys.append(FollowUpGuides.customGuideKey(tone: scenario.tone, index: fIdx))
                } else if !scenario.gentleOnly,
                          let guide = FollowUpGuides.universalGuide(
                              for: scenario.tone,
                              lang: lang,
                              seed: seed + 7,
                              usedKeys: usedKeys
                          ) {
                    text = CompanionLanguage.weave([text, guide.text])
                    keys.append(guide.key)
                }
            }

            return ChatReply(text, emojis: scenario.emojis, replyKey: keys.joined(separator: "|"))
        }

        // 主回复用完了 → 换引导语（comfortOnly 场景跳过，直接轮换主回复）
        if !skipFollowUp, scenario.gentleOnly, usedCustomFollowUps.count < customFollowPool.count {
            let fIdx = pickUnused(from: customFollowPool.count, used: usedCustomFollowUps, seed: seed)
            return ChatReply(
                customFollowPool[fIdx],
                emojis: scenario.emojis,
                replyKey: FollowUpGuides.customGuideKey(tone: scenario.tone, index: fIdx)
            )
        }

        if !scenario.gentleOnly,
           let guide = FollowUpGuides.universalGuide(
               for: scenario.tone,
               lang: lang,
               seed: seed,
               usedKeys: usedKeys
           ) {
            return ChatReply(
                guide.text,
                emojis: scenario.emojis,
                replyKey: guide.key
            )
        }

        // 全部用过 → 按 seed 轮换，但换 replyKey 后缀避免引擎跳过
        let idx = seed % max(pool.count, 1)
        return ChatReply(
            pool[idx],
            emojis: scenario.emojis,
            replyKey: "\(base)_r\(idx)_t\(turnCount)"
        )
    }

    private static func pickUnused(from count: Int, used: [Int], seed: Int) -> Int {
        let available = (0..<count).filter { !used.contains($0) }
        guard !available.isEmpty else { return seed % max(count, 1) }
        return available[seed % available.count]
    }

    private static func isKeyUsed(_ key: String, in usedKeys: Set<String>) -> Bool {
        usedKeys.contains(key) || usedKeys.contains(where: { $0.hasPrefix(key + "_t") })
    }

    // MARK: - 正向 · 学业成长

    static let positiveScenariosCore: [Template] = [
        Template(
            id: "exam_good",
            keywords: ["期末", "模考", "考得好", "考得特别好", "进步", "名次", "成绩出来", "高分", "第一名", "全班第一"],
            tone: .positive, priority: 8,
            responses: [
                "哇！光看文字都感受到你的开心啦！这段时间早起背书、刷题熬的夜果然都有回报，你超棒的。",
                "太厉害啦！肯定是你平时偷偷攒了好多努力，一下子就爆发出来了对不对～",
            ],
            followUps: ["是哪门科目考得最超出预期呀？", "准备怎么奖励努力的自己？"],
            emojis: ["🎉", "✨", "💪"]
        ),
        Template(
            id: "exam_pass",
            keywords: ["考研上岸", "上岸", "教资", "过了", "录取", "offer", "笔试", "面试通过", "考上"],
            tone: .positive, priority: 9,
            responses: [
                "天呐恭喜你！那些熬到凌晨的夜晚、背了又忘的知识点，终于都变成好消息来找你了。",
                "太棒啦！这一路的忐忑和辛苦都值了，你完全配得上这份好结果～",
            ],
            followUps: ["备考的时候有没有印象特别深的瞬间？", "接下来最想先做什么庆祝？"],
            emojis: ["🎉", "🌟", "🎊"]
        ),
        Template(
            id: "homework_praise",
            keywords: ["论文", "被老师", "表扬", "最高分", "作业", "当众", "认可", "老师夸"],
            tone: .positive, priority: 7,
            responses: [
                "好厉害！你的认真和用心果然被看到了，被认可的感觉一定超爽吧～",
                "被当众肯定也太有成就感了！这就是对你用心打磨的最好奖励呀。",
            ],
            followUps: ["老师具体夸了哪个部分呀？", "你为这个作业花了不少心思吧？"],
            emojis: ["😊", "✨", "📚"]
        ),

        // MARK: 正向 · 职场

        Template(
            id: "project_win",
            keywords: ["项目落地", "项目顺利", "签下", "大客户", "反馈特别好", "方案通过"],
            tone: .positive, priority: 8,
            responses: [
                "太牛了！那些改方案改到凌晨的日子都没白费，你的能力完全扛得住呀。",
                "恭喜恭喜！悬了这么久的心终于可以放下了，这波必须给自己记一大功。",
            ],
            followUps: ["项目里最让你有成就感的是哪部分？", "拿下客户的关键是什么呀？"],
            emojis: ["🎉", "💼", "✨"]
        ),
        Template(
            id: "almost_late",
            keywords: ["差一秒", "卡点", "打上卡", "差点迟到", "极限", "踩点"],
            tone: .positive, priority: 6,
            responses: [
                "哈哈这是什么职场极限挑战！卡点成功的快乐堪比中了小奖对吧～",
                "也太惊险了！一路狂奔赶过来的吧，赶紧坐下来喘口气，今天开局就赢了。",
            ],
            followUps: ["路上是不是跑着过来的？", "为了不迟到你都做过什么努力？"],
            emojis: ["😅", "✨", "🏃"]
        ),
        Template(
            id: "leave_on_time",
            keywords: ["准点下班", "准时下班", "摸鱼", "准时走", "提前下班"],
            tone: .positive, priority: 6,
            responses: [
                "天呐这是什么神仙工作日！准时下班的快乐谁懂啊，赶紧去吃点好的犒劳自己～",
                "哈哈摸鱼成功也是职场小胜利！紧绷的弦松一松，整个人都舒服多了吧。",
            ],
            followUps: ["下班打算去做点什么开心的事？", "摸鱼的时候都干嘛啦？"],
            emojis: ["😊", "🌿", "🎉"]
        ),
        Template(
            id: "promotion",
            keywords: ["升职", "加薪", "涨薪", "新offer", "新 offer", "心仪公司"],
            tone: .positive, priority: 9,
            responses: [
                "恭喜你开启职场新阶段！你的能力和付出终于匹配到了更好的机会，太值得了。",
                "哇这也太棒了！纠结忐忑的等待都有了最好的结果，接下来可以大步往前走啦。",
            ],
            followUps: ["新岗位最让你期待的是什么？", "打算怎么庆祝这个好消息？"],
            emojis: ["🎉", "💼", "🌟"]
        ),

        // MARK: 正向 · 日常小确幸

        Template(
            id: "good_food",
            keywords: ["好吃", "火锅", "奶茶", "美食", "太香", "惊艳", "好喝"],
            tone: .positive, priority: 5,
            responses: [
                "美食就是最高级的治愈！吃到好吃的东西，一整天的心情都跟着亮起来了对不对～",
                "听着都觉得幸福！好吃的东西就是要慢慢品尝，把这份甜牢牢记住呀。",
            ],
            followUps: ["是什么好吃的让你这么惊艳？", "是和朋友一起去吃的吗？"],
            emojis: ["😋", "✨", "🍜"]
        ),
        Template(
            id: "got_wanted_item",
            keywords: ["抢到", "蹲了好久", "心仪", "终于买到", "到手", "合身"],
            tone: .positive, priority: 6,
            responses: [
                "如愿以偿的感觉也太好了吧！喜欢了这么久的东西拿到手，肯定开心到转圈吧～",
                "太棒啦！心心念念的东西终于到手，这份快乐能持续好几天呢。",
            ],
            followUps: ["拿到手第一感觉怎么样？", "你第一眼为什么喜欢它呀？"],
            emojis: ["🎁", "✨", "😊"]
        ),
        Template(
            id: "little_moment",
            keywords: ["天气", "小猫", "小狗", "可爱", "阳光", "舒服", "风一吹"],
            tone: .positive, priority: 4,
            responses: [
                "好天气就是免费的礼物呀！晒晒太阳吹吹风，整个人的心情都跟着舒展了～",
                "偶遇小猫咪也太幸运了吧！软乎乎的小家伙，是不是瞬间心都化了。",
            ],
            followUps: ["有没有拍好看的照片呀？", "小猫有没有跟你互动呀？"],
            emojis: ["🌸", "☀️", "🐱"]
        ),
        Template(
            id: "good_sleep_joy",
            keywords: ["睡到天亮", "自然醒", "睡饱", "好觉", "一觉"],
            tone: .positive, priority: 5,
            responses: [
                "睡饱的感觉真的太治愈了！整个人都充满电了对不对～",
                "能睡个好觉简直是顶级幸福！今天肯定一整天都精力满满吧。",
            ],
            followUps: ["今天醒来第一感觉是什么？", "睡饱了打算做点什么？"],
            emojis: ["😊", "🌙", "✨"]
        ),

        // MARK: 正向 · 人际

        Template(
            id: "friends_fun",
            keywords: ["朋友", "闺蜜", "聚会", "聊了一整晚", "好久不见", "玩得超开心"],
            tone: .positive, priority: 6,
            responses: [
                "和同频的人待在一起真的太治愈了！不用刻意找话题，怎么待着都舒服～",
                "好久不见也完全不生疏的感觉真好呀，见面的快乐能抵消好多疲惫呢。",
            ],
            followUps: ["你们今天都去干嘛啦？", "有没有聊到什么有意思的事？"],
            emojis: ["🫂", "😊", "✨"]
        ),
        Template(
            id: "gift_surprise",
            keywords: ["礼物", "惊喜", "寄来", "纪念日", "对象准备"],
            tone: .positive, priority: 7,
            responses: [
                "被人放在心上的感觉也太暖了吧！拆开礼物的时候肯定心跳都变快了～",
                "好幸福呀！这份突如其来的心意，比礼物本身更让人开心对不对。",
            ],
            followUps: ["收到的是什么礼物呀？", "你当时第一反应是什么？"],
            emojis: ["🎁", "💕", "✨"]
        ),

        // MARK: 正向 · 自我突破

        Template(
            id: "exercise_win",
            keywords: ["连续运动", "跑步", "突破", "打卡", "健身", "坚持一周"],
            tone: .positive, priority: 6,
            responses: [
                "太有毅力了吧！坚持下来的你超酷的，身体肯定也慢慢变舒服了对不对～",
                "恭喜你又解锁了新的自己！每一次突破都是在给生活攒底气呀。",
            ],
            followUps: ["运动完最明显的感受是什么？", "是什么让你坚持下来的呀？"],
            emojis: ["💪", "✨", "🏃"]
        ),
        Template(
            id: "new_skill",
            keywords: ["学会", "搞懂", "做蛋糕", "新技能", "第一次", "终于会"],
            tone: .positive, priority: 6,
            responses: [
                "也太厉害了吧！从不会到会的过程虽然麻烦，但学会的瞬间成就感拉满～",
                "太棒啦！又给自己解锁了一个新技能，慢慢变厉害的感觉真好。",
            ],
            followUps: ["学的时候有没有遇到什么小挫折？", "接下来想解锁什么新技能呀？"],
            emojis: ["✨", "🎉", "🌟"]
        ),
    ]

    // MARK: - 负向场景

    static let negativeScenariosCore: [Template] = [
        // 学业压力
        Template(
            id: "exam_fail",
            keywords: ["考砸", "没考好", "失利", "没用", "努力了好久", "不如预期", "考差了"],
            tone: .negative, priority: 8,
            responses: [
                "抱抱你，努力过后却没拿到想要的结果，肯定特别失落委屈吧。没关系的，一次考试定义不了你的全部呀。",
                "我懂这种落差感，明明已经拼尽全力了，结果却不如人意，换谁都会难过的。先好好哭一会也没关系的。",
            ],
            followUps: ["是哪门科目没发挥好呀？", "现在最让你难受的是什么？"],
            emojis: ["🫂", "💙", "🌿"]
        ),
        Template(
            id: "deadline_panic",
            keywords: ["deadline", "没头绪", "写不完", "堆成山", "交不了", "写不出来", "快疯了"],
            tone: .negative, priority: 9,
            responses: [
                "deadline 压着又没思路的感觉真的太窒息了，先别急，深呼吸一下，咱们拆成一小块一小块来好不好。",
                "堆成山的任务看着就头疼，一直硬扛着肯定特别累吧。不如先歇十分钟，喝口水缓一缓呀。",
            ],
            followUps: ["卡在哪一部分最久呀？", "距离截止还有多久呀？"],
            emojis: ["🫂", "📚", "🍵"]
        ),
        Template(
            id: "exam_anxiety",
            keywords: ["考研", "焦虑", "睡不着", "一想到考试", "好慌", "备考压力"],
            tone: .negative, priority: 8,
            responses: [
                "背着这么大的压力往前走，肯定特别累吧。其实你已经走了很远了，不用逼自己时刻都绷紧弦的。",
                "我懂这种坐立不安的感觉，越想做好就越容易焦虑。但你已经在很努力地准备了，这就已经很棒了呀。",
            ],
            followUps: ["最近每天都学到很晚吗？", "焦虑的时候一般会做什么呀？"],
            emojis: ["🫂", "🌿", "💙"]
        ),

        // 职场
        Template(
            id: "late_scolded",
            keywords: ["迟到", "被领导", "当众", "扣全勤", "地铁晚点", "挨说"],
            tone: .negative, priority: 8,
            responses: [
                "当众被说肯定又尴尬又委屈吧，本来迟到就慌，还要挨说，一整天的心情都受影响了。",
                "好不容易赶过来还是迟到，还被扣了全勤，也太倒霉了吧。换谁都会郁闷好久的。",
            ],
            followUps: ["是路上遇到什么意外了吗？", "现在心情平复一点了吗？"],
            emojis: ["🫂", "💙", "😔"]
        ),
        Template(
            id: "overtime",
            keywords: ["加班", "熬到", "连续加班", "十点", "十一点", "深夜才下班"],
            tone: .negative, priority: 7,
            responses: [
                "连轴转也太辛苦了，身体和精神都在硬扛吧。忙完这段一定要好好歇一歇，你已经很努力了。",
                "加班到这么晚，肯定又累又饿吧。先别想工作了，回去洗个热水澡好好躺一躺呀。",
            ],
            followUps: ["这阵子是项目特别赶吗？", "有没有抽空好好吃顿饭呀？"],
            emojis: ["🫂", "🍵", "🌙"]
        ),
        Template(
            id: "boss_criticism",
            keywords: ["被领导骂", "方案", "一无是处", "搞砸", "差错", "都是我的锅"],
            tone: .negative, priority: 8,
            responses: [
                "被狠狠否定的感觉肯定特别难受，明明已经花了很多心思，换谁都会委屈的。",
                "先别急着怪自己呀，出问题本来就不是一个人的原因。你现在肯定又慌又难受吧。",
            ],
            followUps: ["领导主要说哪方面有问题呀？", "你之前为这个方案花了不少心思吧？"],
            emojis: ["🫂", "💙", "🌿"]
        ),
        Template(
            id: "workplace_conflict",
            keywords: ["甩锅", "同事", "人际关系", "办公室", "背锅", "复杂"],
            tone: .negative, priority: 7,
            responses: [
                "平白无故背锅也太委屈了吧，明明不是你的错，还要受这份气，换谁都会气不过的。",
                "职场里的弯弯绕绕真的很消耗人，要应付工作还要处理关系，光想想都觉得累。",
            ],
            followUps: ["具体是发生什么事了呀？", "有没有人能帮你证明呀？"],
            emojis: ["🫂", "🛡️", "💙"]
        ),
        Template(
            id: "job_burnout",
            keywords: ["不想上班", "煎熬", "没意义", "麻木", "倦怠", "厌班"],
            tone: .negative, priority: 7,
            responses: [
                "我懂这种提不起劲的感觉，每天重复一样的事，看不到盼头，整个人都被耗空了似的。",
                "倦怠太正常了，谁都有不想上班的时候。你已经坚持这么久了，偶尔摆烂一下也没关系的。",
            ],
            followUps: ["是哪件事让你突然这么想呀？", "最近有没有什么想做但没时间做的事？"],
            emojis: ["🫂", "🌿", "💙"]
        ),

        // 日常糟心
        Template(
            id: "lost_broken",
            keywords: ["丢了", "弄丢", "摔碎", "钱包", "身份证", "心疼死了", "刚买的"],
            tone: .negative, priority: 7,
            responses: [
                "啊好心疼！刚买的东西就摔坏了，肯定又懊恼又难受吧，换谁都要郁闷好久。",
                "丢了重要的东西肯定又慌又烦，先别急，好好想想最后是在哪放的，慢慢找。",
            ],
            followUps: ["最后一次见到它是在哪呀？", "有没有什么办法可以补救呀？"],
            emojis: ["🫂", "💙", "😔"]
        ),
        Template(
            id: "delivery_issue",
            keywords: ["外卖", "超时", "洒了", "快递", "弄丢", "等了好久"],
            tone: .negative, priority: 6,
            responses: [
                "饿肚子等了这么久，结果还洒了，也太影响心情了吧。本来就盼着这口吃的呢。",
                "等了好久的快递说没就没，期待落空的感觉也太难受了。先找客服问问怎么处理吧。",
            ],
            followUps: ["你点的是什么好吃的呀？", "快递里是什么东西呀？"],
            emojis: ["🫂", "😔", "💙"]
        ),
        Template(
            id: "travel_mishap",
            keywords: ["没带伞", "落汤鸡", "地铁故障", "淋雨", "挤得要死", "突发"],
            tone: .negative, priority: 6,
            responses: [
                "好好的出门遇上这种事，也太倒霉了吧。浑身湿乎乎的肯定特别难受，赶紧换身衣服别感冒了。",
                "本来好好的行程全被打乱了，又急又烦的，换谁都会心情不好。",
            ],
            followUps: ["现在找到躲雨的地方了吗？", "后来有没有顺利赶到目的地呀？"],
            emojis: ["🫂", "💙", "🌧️"]
        ),
        Template(
            id: "body_unwell",
            keywords: ["头疼", "失眠", "长痘", "昏沉", "不舒服", "三点才睡"],
            tone: .negative, priority: 6,
            responses: [
                "睡不好真的太折磨人了，整个人都不在状态，干什么都提不起劲对吧。",
                "头疼的时候干什么都难受，有没有好好歇一歇呀？别硬扛着，身体最重要。",
            ],
            followUps: ["是因为什么睡不着呀？", "有没有吃点药或者喝点热水？"],
            emojis: ["🫂", "🍵", "💙"]
        ),

        // 人际情感
        Template(
            id: "friend_fight",
            keywords: ["和朋友吵", "最好的朋友", "不理解我", "闹矛盾", "吵架了"],
            tone: .negative, priority: 8,
            responses: [
                "和在意的人吵架真的太难受了，一边生气一边又难过，心里堵得慌对吧。",
                "不被理解的感觉真的很委屈，明明你已经很认真地表达了，对方却接不住你的情绪。",
            ],
            followUps: ["是因为什么事吵起来的呀？", "你现在更生气还是更难过呀？"],
            emojis: ["🫂", "💙", "🥺"]
        ),
        Template(
            id: "misunderstood",
            keywords: ["误解", "背后", "乱讲", "误会", "冤枉", "闲言碎语"],
            tone: .negative, priority: 7,
            responses: [
                "平白无故被误解、被乱讲，也太委屈太生气了吧。明明你什么都没做错，还要受这些闲言碎语。",
                "不了解真相就乱评价的人真的很过分，被冤枉的感觉就像吞了苍蝇一样难受。",
            ],
            followUps: ["你有没有试着解释过呀？", "是什么事让大家误会你了？"],
            emojis: ["🫂", "🛡️", "💙"]
        ),
        Template(
            id: "family_conflict",
            keywords: ["和我妈", "和我爸", "家人", "大吵", "催我", "不懂我"],
            tone: .negative, priority: 8,
            responses: [
                "最亲的人却不理解自己，肯定特别寒心吧。明明是最该站在你这边的人，却反而给你添压力。",
                "被家人催的时候真的又烦又无奈，他们总觉得是为你好，却没问过你想要什么。",
            ],
            followUps: ["是因为什么事吵起来的呀？", "你有没有跟他们说过你的想法？"],
            emojis: ["🫂", "🏠", "💙"]
        ),
        Template(
            id: "breakup",
            keywords: ["分手", "失恋", "空落落", "忽略我", "对象", "感情不顺"],
            tone: .negative, priority: 9,
            responses: [
                "抱抱你，一段认真投入的感情结束，肯定像心里缺了一块似的。难过就哭出来，不用硬撑着。",
                "不被在意的感觉真的太委屈了，你明明值得被好好对待的呀。别憋着，难受就跟我说说。",
            ],
            followUps: ["在一起多久了呀？", "现在最让你难受的是什么？"],
            emojis: ["🫂", "💙", "🌙"]
        ),

        // 情绪内耗
        Template(
            id: "self_doubt",
            keywords: ["没用", "什么都做不好", "比别人差", "自我否定", "配不上"],
            tone: .negative, priority: 7,
            responses: [
                "别这么说自己呀，你只是暂时没看到自己的闪光点而已。你已经在很努力地生活了，这就已经很棒了。",
                "我懂这种无力感，好像怎么做都达不到自己的期待。但你不用事事都完美的，不完美的你也很好呀。",
            ],
            followUps: ["是发生什么事让你这么想呀？", "你最近是不是压力太大了？"],
            emojis: ["🫂", "🌿", "💙"]
        ),
        Template(
            id: "future_lost",
            keywords: ["迷茫", "未来", "看不清", "不知道要干嘛", "焦虑得睡不着"],
            tone: .negative, priority: 7,
            responses: [
                "看不清方向的时候真的很慌，好像怎么走都不对。其实不用逼自己立刻就有答案的，慢慢走慢慢找就好。",
                "对未来焦虑太正常了，大家都是摸着石头过河。你不用一下子就规划好全部，走好当下的每一步就够了。",
            ],
            followUps: ["最近是遇到什么选择了吗？", "你最担心的是哪方面呀？"],
            emojis: ["🫂", "🌿", "💙"]
        ),
        Template(
            id: "idle_tired",
            keywords: ["什么都不想", "躺着发呆", "没做什么却", "提不起劲", "空落落"],
            tone: .negative, priority: 6,
            responses: [
                "这种空落落的疲惫感最磨人了，不是身体累，是心里提不起劲。没关系的，不想做就不做，歇够了再说。",
                "情绪也会有没电的时候呀，不用逼自己时刻都元气满满。允许自己摆烂一会，充充电再出发。",
            ],
            followUps: ["这种状态持续多久了呀？", "有没有什么事以前能让你开心起来？"],
            emojis: ["🫂", "🍵", "🌿"]
        ),
        Template(
            id: "sudden_sad",
            keywords: ["突然委屈", "忍不住掉", "突然好想哭", "莫名", "眼泪"],
            tone: .negative, priority: 7,
            responses: [
                "没关系的，不用非要找个理由才能难过。情绪攒久了就是会突然涌上来，哭出来就舒服多了。",
                "我懂这种莫名的低落，好像所有小事都凑到一起了，压得人喘不过气。想哭就哭，我陪着你呢。",
            ],
            followUps: ["有没有什么小事触发了呀？", "要不要我陪你聊点别的转移一下注意力？"],
            emojis: ["🫂", "💙", "🌙"]
        ),
    ]
}
