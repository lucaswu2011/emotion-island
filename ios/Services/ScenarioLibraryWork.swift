import Foundation

/// 职场重大打击 — 被辞退、裁员等（先共情，不追问）
extension ScenarioLibrary {

    static let workCrisisNegative: [Template] = [
        Template(
            id: "work_fired",
            keywords: [
                "被炒", "炒鱿鱼", "开除", "辞退", "裁员", "被裁", "解雇", "被解雇", "丢了工作", "失去工作",
                "got fired", "fired by", "fired me", "laid off", "let go", "terminated", "lost my job",
                "boss fired", "got the sack", "made redundant", "got fired by",
            ],
            tone: .negative, priority: 12,
            responses: [
                "被辞退真的太突然了，再生气再委屈都是正常的。先别急着想「是不是我不够好」，这种打击谁扛都难受。",
                "工作没了，心里肯定又空又慌吧。今天不用逼自己振作，先让情绪有个地方落一落。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "🌿"],
            responsesEN: [
                "Getting fired out of nowhere is brutal — anger, shock, all of it makes sense. You don't have to bounce back today.",
                "Losing your job hits hard. No unpacking required — I'm just here with you.",
                "That's a gut punch. However you're feeling right now is allowed.",
            ],
            followUpsEN: [],
            gentleOnly: true
        ),
        Template(
            id: "work_quit_forced",
            keywords: ["逼我离职", "被迫离职", "劝退", "变相裁员", "forced to resign", "pushed out", "constructive dismissal"],
            tone: .negative, priority: 11,
            responses: [
                "明明是被逼着走，还要装作「主动离职」，这种憋屈真的气人。你的感受完全成立。",
                "被变相劝退最伤自尊了，好像错都在你身上。先别急着消化，我陪着你。",
            ],
            followUps: [],
            emojis: ["🫂", "💙", "😔"],
            responsesEN: [
                "Being pushed out but told to call it a \"resignation\" is infuriating. Your anger is valid.",
                "That kind of forced exit wounds your pride — you don't have to process it alone right now.",
            ],
            followUpsEN: [],
            gentleOnly: true
        ),
    ]
}
