import Foundation

/// 界面文案 — 根据用户选择的语言显示
struct AppStrings {
    let language: AppLanguage

    // MARK: - 语言选择

    var languageSelectionTitle: String {
        language == .english ? "Choose your language" : "选择你的语言"
    }

    var languageSelectionSubtitle: String {
        language == .english
            ? "You can write in either language later."
            : "之后你可以用任意语言倾诉。"
    }

    // MARK: - 欢迎页

    var appName: String { language == .english ? "Emotion Island" : "情绪岛" }

    var welcomeLine1: String {
        language == .english ? "Write one line about how you feel." : "写下一句此刻的心情。"
    }

    var welcomeLine2: String {
        language == .english
            ? "If you don't know where to start, this quiet island is here to hold what you haven't said yet."
            : "如果不知道从何说起，这里有一个安静的小岛，愿意接住你所有没说出口的话。"
    }

    var featureLeaf: String { language == .english ? "Heart to leaf" : "心形化作叶子" }
    var featureAI: String { language == .english ? "Gentle AI companion" : "隐藏的AI小助手" }
    var featureLocal: String { language == .english ? "Runs locally" : "本地运行，不上云" }

    var startWriting: String {
        language == .english ? "Start writing today" : "开始写下今天的心情"
    }

    var privacyWelcome: String {
        language == .english
            ? "All data stays on your device. Local script library runs offline — nothing uploaded by default."
            : "所有数据仅保存在你的设备上，本地话术库离线处理，默认不上传任何内容"
    }

    var myRecords: String { language == .english ? "Full records" : "详细记录" }

    var moodDiary: String { language == .english ? "Mood diary" : "情绪日记" }

    var moodDiaryTitle: String { language == .english ? "14-day mood diary" : "情绪日记" }

    var moodDiarySubtitle: String {
        language == .english
            ? "A quiet diary of how your days felt"
            : "普普通通的日记，记下每天的心情起伏"
    }

    var moodDiaryRetention: String {
        language == .english
            ? "Keeps the last 14 days · stickers from each visit"
            : "仅保留最近 14 天 · 每次倾诉贴上一枚心情"
    }

    var moodDiaryEmptyPage: String {
        language == .english ? "Blank page for now…" : "这一页还空着…"
    }

    var moodDiaryFullHistory: String {
        language == .english ? "View full chat records" : "查看完整对话记录"
    }
    var aboutApp: String { language == .english ? "About Emotion Island" : "关于情绪岛" }

    // MARK: - 日记输入

    var diaryCaption: String { language == .english ? "Emotion diary" : "情绪日记" }
    var todayISay: String { language == .english ? "Today, I want to say…" : "今天，我想说..." }
    var diaryPlaceholder: String {
        language == .english ? "One honest line about right now" : "写下此刻最真实的一句话"
    }

    var diaryHint1: String { language == .english ? "One line is enough." : "写下一句话就好。" }
    var diaryHint2: String {
        language == .english
            ? "What you leave unsaid might still be gently caught."
            : "有些没说出口的部分，也许会被轻轻接住。"
    }

    var trySample: String {
        language == .english ? "Try: \"I'm a little sad\"" : "+ 试试输入'我有点难过'"
    }

    var sampleSadText: String {
        language == .english ? "I'm a little sad" : "我有点难过"
    }

    var learnAI: String {
        language == .english ? "How local emotion rules work" : "了解本地情绪识别如何工作"
    }

    var continueButton: String { language == .english ? "Continue" : "继续" }
    var privacyDiary: String {
        language == .english
            ? "Stored locally only · Offline emotion rules & script library"
            : "数据仅存在本地 · 情绪规则与场景话术库离线运行"
    }

    // MARK: - 心情选择

    var moodContinueChat: String {
        language == .english ? "Continue with companion" : "继续和小助手聊聊"
    }

    var moodFeelingLabel: String {
        language == .english ? "I feel…" : "我现在感觉…"
    }

    var companionListening: String {
        language == .english ? "Companion is listening" : "小助手在听"
    }

    // MARK: - 聊天

    var chatTitle: String { language == .english ? "Chat with companion" : "和小助手聊聊" }
    var saveAndReview: String { language == .english ? "Save & review" : "保存并查看详情" }
    var chatTurnPrefix: String { language == .english ? "Turn" : "第" }
    var chatTurnSuffix: String { language == .english ? " · listening" : " 轮 · 小助手在听" }

    func chatTurnLabel(_ count: Int) -> String {
        language == .english ? "Turn \(count) · listening" : "第 \(count) 轮 · 小助手在听"
    }

    var chatPrivacy: String {
        language == .english
            ? "Unlimited turns · Saved locally · Nothing uploaded"
            : "对话无轮次限制 · 仅保存在本地 · 不上传任何内容"
    }

    var chatPrivacyDeepSeek: String {
        language == .english
            ? "Messages sent to DeepSeek · Key stored on device only"
            : "对话会发送至 DeepSeek · API Key 仅存本机"
    }

    var aiProviderTitle: String {
        language == .english ? "Companion AI" : "小助手 AI"
    }

    var aiProviderLocalDesc: String {
        language == .english ? "Script library · fully offline" : "本地话术库 · 完全离线"
    }

    var aiProviderDeepSeekDesc: String {
        language == .english ? "Smarter chat · needs network" : "更智能对话 · 需要网络"
    }

    var deepSeekAPIKeyTitle: String {
        language == .english ? "Replace API Key (optional)" : "更换 API Key（可选）"
    }

    var deepSeekAPIKeyHint: String {
        language == .english
            ? "Optional: replace the built-in key. Leave blank to use default."
            : "可选：更换内置 Key。留空则继续使用预设 Key。"
    }

    var deepSeekAPIKeyPlaceholder: String {
        language == .english ? "sk-..." : "sk-..."
    }

    var deepSeekKeySave: String {
        language == .english ? "Save Key" : "保存 Key"
    }

    var deepSeekKeyRequired: String {
        language == .english
            ? "Enter your DeepSeek API Key to use cloud AI."
            : "使用 DeepSeek 需要先填写 API Key。"
    }

    var aiThinking: String {
        language == .english ? "Companion is thinking…" : "小助手正在想怎么接话…"
    }

    var networkRequiredForDeepSeek: String {
        language == .english
            ? "DeepSeek requires an internet connection. Switched to local AI."
            : "DeepSeek 需要联网使用，已自动切换为本地 AI。"
    }

    var networkOfflineHint: String {
        language == .english ? "No network — DeepSeek unavailable" : "当前无网络，无法使用 DeepSeek"
    }

    var chatPlaceholderEmotion: String {
        language == .english ? "Say whatever comes to mind…" : "想到哪，就说到哪…"
    }

    var chatPlaceholderUnfolding: String {
        language == .english ? "Take your time, I'm here…" : "慢慢讲，我听着…"
    }

    var chatPlaceholderComfort: String {
        language == .english ? "If there's more, I'm still here…" : "如果还有话，我在这儿…"
    }

    var chatPlaceholderDistress: String {
        language == .english ? "Keep going — no need to polish your words…" : "继续讲吧，不用整理语言…"
    }

    var statusNoRush: String {
        language == .english ? "🫂 No rush — say what comes to mind" : "🫂 不用急，想到哪就说到哪"
    }

    var statusListening: String {
        language == .english ? "👂 I'm here — take your time" : "👂 慢慢讲，我在这儿"
    }

    var statusOverwhelming: String {
        language == .english ? "🫂 No pressure to feel better" : "🫂 不催你，也不赶你"
    }

    var statusVenting: String {
        language == .english ? "👂 No need to bounce back yet" : "👂 不用急着好起来，我听着"
    }

    var statusDefault: String {
        language == .english ? "🫂 I'm here with you" : "🫂 慢慢讲就好，我在这儿"
    }

    var longSessionFooter: String {
        language == .english
            ? "You've shared a lot… there's always room here for you"
            : "你已经讲了很多…这里永远有空位给你"
    }

    var chatUnavailableTitle: String {
        language == .english ? "Can't start chat" : "暂时无法开始对话"
    }

    var chatUnavailableBody: String {
        language == .english ? "Go back and write how you feel first." : "请返回上一页，先写下你的心情。"
    }

    // MARK: - 总结

    var summaryCaughtMoment: String {
        language == .english ? "The moment you were held" : "情绪被接住的瞬间"
    }

    var summaryEmotion: String { language == .english ? "Emotion detected" : "识别到的情绪" }
    var summaryTriggers: String { language == .english ? "Trigger words" : "触发词" }
    var summaryResponseStyle: String { language == .english ? "Response style" : "回应方式" }
    var summaryStorage: String { language == .english ? "Data storage" : "数据存储" }
    var summaryStorageValue: String { language == .english ? "Local only · never uploaded" : "仅本地 · 不上传" }

    var backToDiary: String { language == .english ? "Back to diary" : "返回日记" }
    var saveRecord: String { language == .english ? "Save record" : "保存记录" }

    // MARK: - 历史

    var historyTitle: String { language == .english ? "My mood records" : "我的心情记录" }
    var historyEmptyTitle: String { language == .english ? "No saved records yet" : "还没有保存的记录" }
    var historyEmptyBody: String {
        language == .english
            ? "Write your first line — Emotion Island will gently catch it."
            : "写下第一句心情，情绪岛会帮你温柔接住。"
    }

    var historyUser: String { language == .english ? "Me" : "我" }
    var historyAssistant: String { language == .english ? "Bot" : "助手" }

    func historyMessageCount(_ count: Int) -> String {
        language == .english ? "…\(count) messages total" : "…共 \(count) 条对话"
    }

    // MARK: - 关于

    var aboutTitle: String { language == .english ? "About" : "关于" }
    var aboutBadge: String { language == .english ? "● Local · no internet needed" : "● 本地运行 · 无需联网" }
    var aboutHeading: String {
        language == .english ? "About Emotion Island" : "关于情绪岛项目"
    }

    var aboutIntro: String {
        language == .english
            ? "A quiet emotion diary — record how each day feels, and let unsaid words be gently held."
            : "一个安静的情绪日记——记录每天的心情状态，让那些说不出口的话，被温柔接住。"
    }

    var aboutOriginLabel: String { language == .english ? "Origin" : "缘起" }
    var aboutOriginTitle: String {
        language == .english ? "It started with \"I'm fine today\"" : "从一句 \"今天还好\" 开始"
    }

    var aboutPhilosophyLabel: String { language == .english ? "Design" : "设计理念" }
    var aboutPrivacyLabel: String { language == .english ? "Privacy" : "隐私承诺" }

    // MARK: - 通用

    var savedAlertTitle: String { language == .english ? "Saved locally" : "已保存到本地" }
    var savedAlertOK: String { language == .english ? "OK" : "好的" }
    var savedAlertMessage: String {
        language == .english
            ? "This record stays on your device only. Nothing is uploaded."
            : "这条心情记录只存在你的设备上，不会上传任何内容。"
    }

    var aiDemoTitle: String { language == .english ? "Local engine demo" : "本地话术引擎演示" }
}
