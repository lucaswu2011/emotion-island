import Foundation

/// 双语自然语言组合 — 根据用户语言返回中文或英文回应
enum CompanionLanguage {

    static func seed(session: ConversationSession?, text: String, usedKeys: Set<String>) -> Int {
        let base = (session?.turnCount ?? 0) * 17 + usedKeys.count * 31 + text.count * 7
        return abs(base + text.hashValue)
    }

    static func pickOne(_ options: [String], seed: Int) -> String {
        guard !options.isEmpty else { return "" }
        return options[seed % options.count]
    }

    static func pickB(zh: [String], en: [String], lang: AppLanguage, seed: Int) -> String {
        pickOne(lang == .chinese ? zh : en, seed: seed)
    }

    static func weave(_ parts: [String]) -> String {
        parts
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
            .replacingOccurrences(of: "  ", with: " ")
    }

    // MARK: - 锚点

    static func lightTouch(on text: String, lang: AppLanguage) -> String? {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return nil }

        if lang == .english {
            if t.localizedCaseInsensitiveContains("first place") || t.localizedCaseInsensitiveContains("number one") {
                return subject(from: t, lang: lang).map { "\($0) came first" } ?? "came first"
            }
            if t.localizedCaseInsensitiveContains("happy") || t.localizedCaseInsensitiveContains("glad") { return "so happy" }
            if t.localizedCaseInsensitiveContains("tired") || t.localizedCaseInsensitiveContains("exhausted") { return "so tired" }
            if t.localizedCaseInsensitiveContains("wronged") || t.localizedCaseInsensitiveContains("unfair") { return "so wronged" }
            if t.localizedCaseInsensitiveContains("angry") || t.localizedCaseInsensitiveContains("mad") { return "so angry" }
            if t.localizedCaseInsensitiveContains("sad") || t.localizedCaseInsensitiveContains("upset") { return "feeling low" }
            if t.localizedCaseInsensitiveContains("stolen") { return "something was taken" }
            if let sub = subject(from: t, lang: lang) { return "that \(sub) exam" }
            if t.count <= 20 { return t }
            if let cut = t.firstIndex(of: ",") { return String(t[..<cut]) }
            return String(t.prefix(16))
        }

        if t.contains("全班第一") || t.contains("第一名") {
            if let sub = subject(from: t, lang: lang) { return "\(sub)拿了第一" }
            return "拿了第一"
        }
        if t.contains("开心") || t.contains("高兴") { return "这么开心" }
        if t.contains("累") { return "这么累" }
        if t.contains("委屈") { return "这么委屈" }
        if t.contains("生气") || t.contains("气") { return "这么气" }
        if t.contains("难过") { return "心里这么难过" }
        if t.contains("没做出来") || t.contains("明明会") { return "会做的题却没写出来" }
        if t.contains("考砸") || t.contains("没考好") { return "考得不如预期" }
        if t.contains("被偷") || t.contains("偷") { return "东西被拿走" }
        if let sub = subject(from: t, lang: lang) { return "\(sub)那场" }
        if t.count <= 10 { return t }
        if let cut = t.firstIndex(of: "，") { return String(t[..<cut]) }
        return String(t.prefix(12))
    }

    static func anchorPhrase(from text: String, lang: AppLanguage) -> String? {
        let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !t.isEmpty else { return nil }

        if lang == .english {
            if t.localizedCaseInsensitiveContains("can't open my eyes") || t.localizedCaseInsensitiveContains("can't open my eye") {
                return "can't even open your eyes"
            }
            if t.localizedCaseInsensitiveContains("thesis") || t.localizedCaseInsensitiveContains("paper") {
                if t.localizedCaseInsensitiveContains("2") || t.localizedCaseInsensitiveContains("late") { return "writing that late" }
                return "working on the paper"
            }
            if t.localizedCaseInsensitiveContains("slept late") || t.localizedCaseInsensitiveContains("went to bed late") {
                return "sleeping so late"
            }
            if t.localizedCaseInsensitiveContains("stay up") || t.localizedCaseInsensitiveContains("stayed up") {
                return "staying up that late"
            }
            if t.localizedCaseInsensitiveContains("overtime") { return "working overtime" }
            if LanguageSignals.expressesExhaustion(t) { return nil }
            return lightTouch(on: t, lang: lang)
        }

        if t.contains("睁不开眼") || t.contains("睁不开眼睛") || t.contains("睁不开") { return "连眼睛都睁不开" }
        if t.contains("论文") && (t.contains("2点") || t.contains("两点") || t.contains("凌晨") || t.contains("很晚")) { return "论文写到那么晚" }
        if t.contains("论文") { return "赶论文" }
        if t.contains("作业") && (t.contains("晚") || t.contains("点")) { return "作业写到那么晚" }
        if t.contains("很晚才睡") || t.contains("睡得很晚") { return "昨晚睡那么晚" }
        if t.contains("熬夜") { return "熬夜熬到这个点" }
        if t.contains("两点") || t.contains("2点") || t.contains("凌晨") { return "熬到那么晚" }
        if t.contains("加班") { return "加班到这个份上" }
        if t.contains("没睡") || t.contains("失眠") { return "睡不够" }
        if t.contains("好累") || t.contains("很累") || t.contains("累死了") { return nil }
        return lightTouch(on: t, lang: lang)
    }

    // MARK: - 开场

    static func joyInvite(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["诶，听着就高兴！今天什么好事？", "开心呀～愿意多讲一点吗？", "真好…是什么让你这么高兴？", "这语气听着就轻快…愿意跟我分享一下吗？"],
            en: ["You sound happy! What happened?", "That's lovely — want to tell me more?", "Something good today?", "I can hear the lightness — share with me?"],
            lang: lang, seed: seed
        )
    }

    static func sadnessInvite(seed: Int, touch: String?, lang: AppLanguage) -> String {
        if lang == .english {
            let lead = touch.map { "\($0)… " } ?? ""
            return pickB(
                zh: [], en: [
                    "\(lead)When things feel heavy, saying it out loud can help a little.",
                    "\(lead)Sounds like today was hard. I'm here — take your time.",
                    "\(lead)That feeling stuck inside is the worst. What's going on?",
                ],
                lang: lang, seed: seed
            )
        }
        let lead = touch.map { "\($0)啊…" } ?? "嗯…"
        return pickOne([
            "\(lead)心里沉的时候，说出来会轻一点。愿意讲讲吗？",
            "\(lead)今天是不是不太好过？我在这儿，慢慢说。",
            "\(lead)这种感受憋着最难受了…怎么了？",
        ], seed: seed)
    }

    static func angerInvite(seed: Int, touch: String?, lang: AppLanguage) -> String {
        if lang == .english {
            return pickB(zh: [], en: [
                "Anger usually has a reason… who crossed the line?",
                "When words cut deep, it stays with you… what happened?",
                "I can feel the heat in that — want to walk me through it?",
            ], lang: lang, seed: seed)
        }
        let lead = touch.map { "\($0)，" } ?? ""
        return pickOne([
            "\(lead)火气上来一定是有原因的…谁惹你了？",
            "\(lead)生气的时候，话往往比刀还利…发生什么了？",
            "\(lead)你这股气我感受到了…愿意讲讲来龙去脉吗？",
        ], seed: seed)
    }

    static func fearInvite(seed: Int, touch: String?, lang: AppLanguage) -> String {
        pickB(
            zh: ["担心的事可以先放一半下来，从最压你的那件说起？", "不用组织得很完整，想到哪说到哪就好。", "我在，不催你…现在最让你慌的是什么？"],
            en: ["You can put half the worry down — start with what's heaviest.", "No need for a neat story. Say whatever comes first.", "I'm here, no rush… what's scaring you most right now?"],
            lang: lang, seed: seed
        )
    }

    static func okayDayReply(lang: AppLanguage) -> String {
        lang == .english
            ? "\"Okay\" is its own kind of good — an ordinary day is a real day."
            : "还行是一种美好，平平淡淡才是真嘛～"
    }

    static func neutralInvite(seed: Int, touch: String?, lang: AppLanguage) -> String {
        if let touch, !touch.isEmpty {
            return pickB(
                zh: ["\(touch)…愿意接着讲吗？", "嗯，\(touch)。后面呢？", "\(touch)啊…我在听。"],
                en: ["\(touch)… want to keep going?", "Mm, \(touch). And then?", "\(touch)… I'm listening."],
                lang: lang, seed: seed
            )
        }
        return pickB(
            zh: ["想到什么就先放下一句，不用组织得很完整。", "不用把故事讲完整，卡在哪就从哪说起。", "慢慢讲，不着急…", "我听着呢，从哪一段开始都行。"],
            en: ["Drop one sentence at a time — it doesn't need to be polished.", "Start wherever you're stuck.", "No rush…", "I'm listening — anywhere is fine to begin."],
            lang: lang, seed: seed
        )
    }

    static func continueWithEmpathy(intent: EmotionIntent, anchor: String?, seed: Int, turnCount: Int, lang: AppLanguage) -> String {
        let s = seed + turnCount * 13
        let a = anchor ?? ""

        switch intent {
        case .exhaustion:
            if !a.isEmpty {
                return pickB(
                    zh: ["\(a)…想想都觉得耗神，今天对自己温柔一点。", "光是\(a)，就够让人垮下来的。", "\(a)啊…身体已经在抗议了，别硬撑。"],
                    en: ["\(a)… just hearing that sounds draining. Be gentle with yourself today.", "\(a) alone is enough to wipe someone out.", "\(a)… your body's telling you to stop pushing."],
                    lang: lang, seed: s
                )
            }
            return pickB(
                zh: ["这段路听着就很耗人，先别逼自己。", "真的辛苦了…能歇就歇一会儿。", "身体在提醒你了，值得被好好对待。"],
                en: ["That sounds exhausting — don't push yourself.", "You've been through a lot… rest if you can.", "Your body is asking to be cared for."],
                lang: lang, seed: s
            )
        case .anger:
            if !a.isEmpty {
                return pickB(
                    zh: ["\(a)…换谁都会火大。", "光是\(a)就够气人的。"],
                    en: ["\(a)… anyone would be furious.", "\(a) alone is infuriating."],
                    lang: lang, seed: s
                )
            }
            return pickB(
                zh: ["这股火气，一定是有来由的。", "生气不代表你不够好，只是说明你在乎。"],
                en: ["That anger came from somewhere real.", "Being angry doesn't make you bad — it means you care."],
                lang: lang, seed: s
            )
        case .sadness, .frustration, .disappointment:
            if !a.isEmpty {
                return pickB(
                    zh: ["\(a)…这种滋味真的不好受。", "光是\(a)，就够让人心里沉一阵的。", "\(a)啊…你不容易。"],
                    en: ["\(a)… that really hurts.", "\(a) alone is enough to weigh on you.", "\(a)… you've had a lot to carry."],
                    lang: lang, seed: s
                )
            }
            return pickB(
                zh: ["心里沉的时候，说出来会轻一点。", "有些感受不用急着消化，先让它在那儿。"],
                en: ["When it's heavy inside, saying it can lighten it a little.", "You don't have to process it all at once."],
                lang: lang, seed: s
            )
        default:
            if !a.isEmpty {
                return pickB(
                    zh: ["\(a)…谢谢你愿意讲给我听。", "嗯，\(a)。"],
                    en: ["\(a)… thank you for telling me.", "Mm, \(a). I hear you."],
                    lang: lang, seed: s
                )
            }
            return pickB(
                zh: ["嗯…继续讲，我听着。", "一句一句来，不用急。"],
                en: ["Keep going — I'm here.", "One sentence at a time, no rush."],
                lang: lang, seed: s
            )
        }
    }

    static func reflectAndValidate(intent: EmotionIntent, snippet: String, seed: Int, lang: AppLanguage) -> String {
        let anchor = anchorPhrase(from: snippet, lang: lang) ?? (snippet.count <= 14 ? snippet : nil)
        return continueWithEmpathy(intent: intent, anchor: anchor, seed: seed, turnCount: 0, lang: lang)
    }

    static func thanksReply(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["不用谢…能陪你一会儿，我也挺开心的。", "嗯，你愿意说这些，对我来说也很重要。", "别客气，我哪儿也不去，还想聊就继续。"],
            en: ["You're welcome… I'm glad I could be here.", "Thank you for trusting me with this.", "Anytime — I'm not going anywhere."],
            lang: lang, seed: seed
        )
    }

    // MARK: - 追问

    enum AskKind: Sendable {
        case examSubject, examCause(subject: String?), examFeeling, joyDetail, who, whatItem, whatHappened
    }

    static func ask(_ kind: AskKind, seed: Int, lang: AppLanguage) -> String {
        switch kind {
        case .examSubject:
            return pickB(
                zh: ["是哪一科呀？", "哪门课的事？", "是数学、语文，还是别的科？"],
                en: ["Which subject was it?", "What class was it about?", "Math, English, or something else?"],
                lang: lang, seed: seed
            )
        case .examCause(let subject):
            let sub = subject ?? (lang == .chinese ? "那场" : "that")
            return pickB(
                zh: ["\(sub)考场上…当时是紧张了，还是时间根本不够？", "\(sub)那时候，是脑子一片空白，还是手跟不上？"],
                en: ["During \(sub)… was it nerves, or not enough time?", "With \(sub)… did your mind go blank, or your hands couldn't keep up?"],
                lang: lang, seed: seed
            )
        case .examFeeling:
            return pickB(
                zh: ["考场上那一刻，你心里是什么感觉？", "走出考场的时候，最先冒出来的是什么情绪？"],
                en: ["In that moment in the exam, what did you feel?", "Right after walking out, what hit you first?"],
                lang: lang, seed: seed
            )
        case .joyDetail:
            return pickB(
                zh: ["是什么好事呀？", "愿意多讲一点吗？我听着呢。", "具体发生什么啦？"],
                en: ["What happened?", "Tell me more — I'm listening.", "What was the good news?"],
                lang: lang, seed: seed
            )
        case .who:
            return pickB(
                zh: ["是和谁的事呀？", "对方是谁？不方便说也没关系。"],
                en: ["Who was it with?", "Who was involved? It's okay if you'd rather not say."],
                lang: lang, seed: seed
            )
        case .whatItem:
            return pickB(
                zh: ["是什么东西被拿了呢？", "被拿走的是什么？"],
                en: ["What was taken?", "What item was it?"],
                lang: lang, seed: seed
            )
        case .whatHappened:
            return pickB(
                zh: ["后来呢？", "再后来发生了什么？"],
                en: ["And then?", "What happened after that?"],
                lang: lang, seed: seed
            )
        }
    }

    // MARK: - 情境

    static func examMissedLead(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["明明会做的题，考场上就是写不出来…那种「本可以」最戳人了。", "会做的题没写出来，事后回想特别不甘。"],
            en: ["You knew the answer but couldn't get it down… that 'I could have' feeling stings.", "Missing questions you knew — that regret hits hard."],
            lang: lang, seed: seed
        )
    }

    static func examUnderperformLead(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["没发挥出真实水平…心里肯定特别堵。", "明明不是这个水平，结果却不理想——这口气很难咽下去。"],
            en: ["Not showing your real level… that frustration sits heavy.", "You know you're capable of more — swallowing that result is hard."],
            lang: lang, seed: seed
        )
    }

    static func examNervesLead(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["考场上紧张到脑子空白…身体比脑子先反应过来了。", "一紧张，平时会的也突然想不起来，太常见了。"],
            en: ["So nervous your mind went blank… your body reacted first.", "Under pressure, even familiar things vanish — it happens to everyone."],
            lang: lang, seed: seed
        )
    }

    static func stolenLead(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["东西被擅自拿走，边界被跨过了，生气完全合理。", "没经过同意就动你的东西，谁都会火大。"],
            en: ["Someone took your things without asking — your anger makes sense.", "Your boundaries were crossed. Anyone would be upset."],
            lang: lang, seed: seed
        )
    }

    static func wrongedLead(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["被冤枉的时候，有口难言…委屈是实打实的。", "明明不是你做的，却要背锅——这太不公平了。"],
            en: ["Being blamed wrongly leaves you speechless… the hurt is real.", "It wasn't your fault but you took the fall — that's unfair."],
            lang: lang, seed: seed
        )
    }

    static func argumentLead(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["吵完架心里往往还堵着，话比刀还利。", "争执过后，生气和委屈常常一起涌上来。"],
            en: ["After a fight, the words often hurt more than the issue.", "Arguments leave both anger and hurt tangled together."],
            lang: lang, seed: seed
        )
    }

    // MARK: - 庆祝

    static func celebrateFirst(subject: String?, seed: Int, lang: AppLanguage) -> String {
        if let subject {
            return pickB(
                zh: ["\(subject)全班第一！这真的很了不起，一定下了不少功夫吧。", "哇，\(subject)拿了第一——这是你应得的，真心为你高兴。"],
                en: ["First in \(subject)! That's incredible — you earned it.", "\(subject) first place! So proud of you — that hard work showed."],
                lang: lang, seed: seed
            )
        }
        return pickB(
            zh: ["第一名！听着就替你高兴，这值得好好庆祝。", "拿了第一，真的很厉害——你的付出有回报了。"],
            en: ["First place! So happy for you — celebrate this.", "You came first — your effort paid off."],
            lang: lang, seed: seed
        )
    }

    static func celebrateScore(subject: String?, seed: Int, lang: AppLanguage) -> String {
        let sub = subject ?? (lang == .chinese ? "这次" : "this time")
        return pickB(
            zh: ["\(sub)考出这么好的成绩，太棒了，你的努力没有白费。", "\(sub)分数这么漂亮，听着就替你开心。"],
            en: ["\(sub) score is amazing — your work paid off.", "Such a great result on \(sub) — I'm happy for you."],
            lang: lang, seed: seed
        )
    }

    static func celebrateProgress(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["有进步就是最值得开心的事，一步一步走来，你都做到了。", "比上次更好，这种一点点往上走的感觉，特别踏实。"],
            en: ["Progress is worth celebrating — you kept going step by step.", "Better than before — that steady climb matters."],
            lang: lang, seed: seed
        )
    }

    static func celebrateGeneric(touch: String?, seed: Int, lang: AppLanguage) -> String {
        if let touch, !touch.isEmpty {
            return pickB(
                zh: ["\(touch)…听着就替你高兴，开心的事值得被记住。", "嗯，\(touch)，真好。"],
                en: ["\(touch)… so happy for you. Worth remembering.", "\(touch) — that's wonderful."],
                lang: lang, seed: seed
            )
        }
        return pickB(
            zh: ["这真是个好消息，听着就替你开心。", "嗯，好事值得被好好记住。"],
            en: ["That's great news — I'm happy for you.", "Good moments are worth holding onto."],
            lang: lang, seed: seed
        )
    }

    static func comfortExamMissed(subject: String?, seed: Int, lang: AppLanguage) -> String {
        let sub = subject ?? (lang == .chinese ? "这场考试" : "this exam")
        return pickB(
            zh: ["\(sub)里会做的题没写出来，不代表你不行，只是一次发挥的问题。", "\(sub)这次不顺，真实水平还在，别因为一次卡点否定自己。"],
            en: ["Missing questions on \(sub) doesn't mean you're not capable — just an off day.", "One rough \(sub) exam doesn't erase your real ability."],
            lang: lang, seed: seed
        )
    }

    static func comfortExamUnder(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["一次没发挥好，真实水平不会因此消失，继续走下去就好。", "发挥失常谁都会遇到，别因为一次结果就把自己看扁。"],
            en: ["One bad performance doesn't erase your ability.", "Everyone chokes sometimes — one result doesn't define you."],
            lang: lang, seed: seed
        )
    }

    static func comfortExamNerves(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["考场上紧张、脑子空白，是压力太大，不是你能力不够。", "一紧张就乱，太正常了——这说明你在乎，不是说明你差。"],
            en: ["Exam nerves and blank minds mean the pressure was high — not that you're incapable.", "Getting flustered just means you care. It doesn't mean you're not good enough."],
            lang: lang, seed: seed
        )
    }

    // MARK: - 疲惫

    static func exhaustionOpening(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: [
                "嗯…听着就觉得你绷紧太久了。先歇一会儿也好。", "累了啊…今天已经够辛苦了，不用硬撑。",
                "听着就心疼…你已经很辛苦了。", "嗯…光听这一句，就觉得你扛了挺久的。",
                "你已经很辛苦了…想说话的时候我在，不想说也没关系。",
            ],
            en: [
                "Sounds like you've been tense for a long time… rest a little if you can.",
                "You're tired… today's been enough. You don't have to push through.",
                "That sounds exhausting — you've carried a lot.",
                "Just hearing that, I can tell you've been holding on for a while.",
                "You've worked hard… talk if you want, silence is fine too.",
            ],
            lang: lang, seed: seed
        )
    }

    static func exhaustionLingering(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: ["嗯…还在累啊。那就先这样待着，不着急。", "我听着呢…不用多说，我哪儿也不去。", "不逼你说什么…此刻能歇一歇就很重要。"],
            en: ["Still tired… that's okay. Just stay here, no rush.", "I'm here — you don't have to say more.", "No pressure to explain… resting right now matters."],
            lang: lang, seed: seed
        )
    }

    static func exhaustionWithContext(context: String, seed: Int, lang: AppLanguage) -> String {
        let anchor = anchorPhrase(from: context, lang: lang) ?? context
        if anchor.count > 20 { return exhaustionFromBeat(.lingering, seed: seed, lang: lang) }
        return pickB(
            zh: ["\(anchor)…光是听着就觉得够耗人的。", "\(anchor)啊，难怪今天这么累。", "\(anchor)，真的辛苦了。"],
            en: ["\(anchor)… that alone sounds draining.", "\(anchor) — no wonder you're wiped out.", "\(anchor)… you've been through a lot."],
            lang: lang, seed: seed
        )
    }

    static func exhaustionFromBeat(_ beat: ExhaustionBeat, seed: Int, lang: AppLanguage) -> String {
        switch beat {
        case .sleepLate:
            return pickB(
                zh: ["昨晚睡那么晚…身体是跟着受委屈的。今天就别太逼自己了。", "睡不够的时候，整个人都会发飘…先对自己温柔一点。"],
                en: ["Sleeping that late… your body's paying for it. Go easy on yourself today.", "When you're short on sleep, everything feels harder — be gentle with yourself."],
                lang: lang, seed: seed
            )
        case .lateNightStudy:
            return pickB(
                zh: ["论文写到那么晚…脑子明明已经很想关机了吧。", "写到两点…这种透支，身体会记住的。今天别对自己太狠。"],
                en: ["Writing that late… your brain must've wanted to shut down.", "Working until 2 AM… that kind of drain adds up. Don't be too hard on yourself today."],
                lang: lang, seed: seed
            )
        case .physical:
            return pickB(
                zh: ["连眼睛都睁不开…先别硬撑了，能眯一会儿就先眯一会儿。", "身体已经在发信号了…此刻什么都不做，也可以。"],
                en: ["Can't even open your eyes… don't push. Nap if you can.", "Your body's sending signals… doing nothing right now is allowed."],
                lang: lang, seed: seed
            )
        case .opening: return exhaustionOpening(seed: seed, lang: lang)
        case .lingering: return exhaustionLingering(seed: seed, lang: lang)
        }
    }

    enum ExhaustionBeat: Sendable {
        case opening, sleepLate, lateNightStudy, physical, lingering
    }

    static func detectExhaustionBeat(in currentText: String, lang: AppLanguage) -> ExhaustionBeat {
        let t = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        let lower = t.lowercased()

        if lang == .english {
            if lower.contains("can't open my eyes") || lower.contains("can't open my eye") || lower.contains("eyes won't open") {
                return .physical
            }
            if lower.contains("thesis") || lower.contains("paper") || lower.contains("essay") {
                return .lateNightStudy
            }
            if (lower.contains("writ") || lower.contains("work")) && (lower.contains("2") || lower.contains("late") || lower.contains("am")) {
                return .lateNightStudy
            }
            if lower.contains("slept late") || lower.contains("went to bed late") || lower.contains("stay up") || lower.contains("stayed up") || lower.contains("insomnia") {
                return .sleepLate
            }
            if LanguageSignals.expressesExhaustion(t) { return .opening }
            return .lingering
        }

        if t.contains("睁不开眼") || t.contains("睁不开眼睛") || t.contains("睁不开") { return .physical }
        if t.contains("论文") || t.contains("毕设") { return .lateNightStudy }
        if (t.contains("写") || t.contains("赶")) && (t.contains("点") || t.contains("晚") || t.contains("凌晨")) { return .lateNightStudy }
        if t.contains("很晚才睡") || t.contains("睡得很晚") || t.contains("熬夜") || t.contains("两点") || t.contains("2点") { return .sleepLate }
        if LanguageSignals.expressesExhaustion(t) { return .opening }
        return .lingering
    }

    static func moodBrightenedReply(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: [
                "咦，听起来心情转好了一些？真好。",
                "嗯，感觉你这边松快多了，替你高兴。",
                "刚才还沉甸甸的，现在听起来轻快多了。",
                "听到你这么说就放心了…愿意讲讲是什么让你好起来的吗？",
            ],
            en: [
                "Sounds like things feel a bit lighter now — that's good.",
                "You seem easier than before — I'm glad.",
                "Things sounded heavy before, but you feel lighter now.",
                "That's a relief to hear… what helped you feel better?",
            ],
            lang: lang, seed: seed
        )
    }

    static func moodDarkenedReply(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: [
                "嗯…好像又沉下来了。我在这儿，慢慢说。",
                "刚才还好好的，现在又难受了是吗…抱抱你。",
                "情绪又绕回来了，不着急，我们接着聊。",
            ],
            en: [
                "Mm… sounds like it got heavy again. I'm here.",
                "Things turned darker again, huh… I'm with you.",
                "The mood dipped again — no rush, we can keep talking.",
            ],
            lang: lang, seed: seed
        )
    }

    static func topicPivotReply(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: [
                "好，我在听，慢慢说。",
                "嗯，我在这儿，不着急。",
            ],
            en: [
                "I'm here — take your time.",
                "I hear you. No need to unpack it all right now.",
            ],
            lang: lang, seed: seed
        )
    }

    /// 重大打击 — 只陪伴，不追问
    static func distressHoldReply(seed: Int, lang: AppLanguage) -> String {
        pickB(
            zh: [
                "这消息太沉了…先缓缓也行，我在这儿，不用急着讲清楚。",
                "听到这个心里一定乱糟糟的。今天不用逼自己消化，我陪着你。",
            ],
            en: [
                "That's a lot to take in… you don't have to unpack it all at once. I'm here.",
                "Hearing that must have knocked the wind out of you. No need to bounce back today — I'm with you.",
            ],
            lang: lang, seed: seed
        )
    }

    static func gameTitleAskReply(seed: Int, lang: AppLanguage, currentText: String) -> String {
        let achievement = GameSignals.hasGamingAchievementContext(currentText)
        let lead = pickB(
            zh: achievement ? [
                "听着就替你上头！",
                "这波可以呀！",
                "哇，听着就带劲！",
            ] : [
                "说起来～",
                "嗯嗯，",
                "打游戏呀，",
            ],
            en: achievement ? [
                "Sounds like you played great!",
                "That's impressive…",
                "You're on fire!",
            ] : [
                "Oh nice —",
                "Gaming, huh —",
                "Sounds fun —",
            ],
            lang: lang, seed: seed
        )
        let ask = pickB(
            zh: [
                "是哪款游戏呀？",
                "你玩的是哪款？",
                "好奇问一下，是什么游戏呢？",
            ],
            en: [
                "Which game was it?",
                "What game are you playing?",
                "Mind telling me which game?",
            ],
            lang: lang, seed: seed + 3
        )
        if achievement, let touch = lightTouch(on: currentText, lang: lang), lang == .chinese {
            return weave([lead, touch + "——" + ask])
        }
        return weave([lead, ask])
    }

    /// 承接情绪或话题转向的短桥接语 — 接在场景回复前
    static func conversationBridge(
        shift: EmotionalShift?,
        topicChanged: Bool,
        currentTone: SentimentTone,
        lang: AppLanguage,
        seed: Int
    ) -> String? {
        if let shift {
            switch shift {
            case .brightened:
                return pickB(
                    zh: [
                        "嗯，感觉转过弯来了。",
                        "这边听起来比刚才轻快多了。",
                    ],
                    en: [
                        "Sounds like things turned a corner.",
                        "This feels lighter than a moment ago.",
                    ],
                    lang: lang, seed: seed
                )
            case .darkened:
                return pickB(
                    zh: [
                        "嗯…这边又沉下来了。",
                        "听到你这么说，也跟着紧了紧。",
                    ],
                    en: [
                        "Mm… this part feels heavier.",
                        "Hearing that — it sounds like things dipped again.",
                    ],
                    lang: lang, seed: seed
                )
            }
        }

        if topicChanged {
            switch currentTone {
            case .positive:
                return pickB(
                    zh: ["好呀，说说这个开心的事。", "嗯，换了个话题，听着就挺轻快。"],
                    en: ["Tell me about this good thing.", "New topic — and you sound lighter."],
                    lang: lang, seed: seed + 3
                )
            case .negative:
                return pickB(
                    zh: ["嗯…我听到了。", "这边听着挺沉的，慢慢说。"],
                    en: ["I hear you.", "This sounds heavy — take your time."],
                    lang: lang, seed: seed + 3
                )
            case .neutral:
                return pickB(
                    zh: ["嗯，我听到了。", "好，我在这儿。"],
                    en: ["I hear you.", "I'm here with you."],
                    lang: lang, seed: seed + 3
                )
            }
        }

        return nil
    }

    static func subject(from text: String, lang: AppLanguage) -> String? {
        if lang == .english {
            return LanguageSignals.examSubjectEN.first(where: { text.localizedCaseInsensitiveContains($0) })?.capitalized
        }
        let subjects = ["数学", "语文", "英语", "物理", "化学", "生物", "历史", "地理", "政治"]
        return subjects.first(where: { text.contains($0) })
    }
}
