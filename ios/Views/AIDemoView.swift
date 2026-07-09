import SwiftUI

struct AIDemoView: View {
    @State private var demoText = "今天过的有点生气，因为有人偷拿了我的游泳包"
    @State private var outputText = "等待输入..."
    @State private var animationStyle: HeartLeafAnimationStyle = .breathing
    @State private var islandMessage = ""

    private let analyzer = EmotionAnalyzer()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("本地话术引擎")
                        .font(.caption)
                        .foregroundStyle(AppTheme.accentBlue)

                    Text("本地情绪识别如何工作")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(AppTheme.primaryText)

                    Text("情绪岛用设备上的关键词规则与场景话术库分析日记，不上传数据。比如你写下「今天还好」，会识别出背后可能藏着的孤独，并轻轻问你：那些没说出口的部分，愿意说说吗？")
                        .font(.subheadline)
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineSpacing(4)
                }

                HStack(alignment: .top, spacing: 24) {
                    demoInputPanel
                    demoOutputPanel
                }

                emotionMappingSection
            }
            .padding(40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    private var demoInputPanel: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("试一试：输入一句心情记录")
                .font(.headline)
                .foregroundStyle(AppTheme.primaryText)

            Text("你的日记")
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)

            TextField("", text: $demoText, axis: .vertical)
                .font(.body)
                .padding(16)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .lineLimit(2...4)

            PrimaryButton("让小助手读懂它") {
                analyzeDemo()
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var demoOutputPanel: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("灵动岛响应")
                .font(.headline)
                .foregroundStyle(AppTheme.primaryText)

            if islandMessage.isEmpty {
                DynamicIslandPreview(animationStyle: .breathing, size: 40)
            } else {
                VStack(spacing: 12) {
                    DynamicIslandPreview(animationStyle: animationStyle, size: 40)
                    Text(islandMessage)
                        .font(.caption)
                        .foregroundStyle(AppTheme.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }

            Text("情绪分析结果")
                .font(.headline)
                .foregroundStyle(AppTheme.primaryText)
                .padding(.top, 8)

            Text(outputText)
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(outputText == "等待输入..." ? AppTheme.secondaryText : .white)
                .padding(16)
                .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
                .background(Color(red: 0.15, green: 0.15, blue: 0.17))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var emotionMappingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("情绪词典与触发词映射")
                .font(.headline)

            VStack(spacing: 0) {
                mappingRow("今天还好", intent: "隐藏的孤独", animation: "心形微缩，叶子轻触边缘")
                Divider()
                mappingRow("有点难过", intent: "低落", animation: "叶子慢慢包裹心形")
                Divider()
                mappingRow("今天开心", intent: "开心", animation: "心形舒展成叶子")
                Divider()
                mappingRow("有点生气", intent: "愤怒", animation: "心形急促跳动，叶子安抚")
                Divider()
                mappingRow("好委屈", intent: "委屈", animation: "心形收紧，叶子靠近")
                Divider()
                mappingRow("好累", intent: "疲惫", animation: "心形缓慢呼吸")
                Divider()
                mappingRow("有点焦虑", intent: "焦虑", animation: "心形轻颤，叶子轻抚")
                Divider()
                mappingRow("还好吧", intent: "中性掩饰", animation: "心形停顿，叶子试探靠近")
            }
            .background(AppTheme.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            HStack {
                Image(systemName: "checkmark.shield.fill")
                    .foregroundStyle(AppTheme.softGreen)
                Text("本地模式全程离线 · 无需联网")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(AppTheme.softGreen)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(AppTheme.softGreen.opacity(0.12))
            .clipShape(Capsule())
        }
    }

    private func mappingRow(_ trigger: String, intent: String, animation: String) -> some View {
        HStack {
            Text(trigger)
                .font(.subheadline.weight(.medium))
                .frame(width: 100, alignment: .leading)
            Text(intent)
                .font(.caption)
                .foregroundStyle(AppTheme.accentBlue)
                .frame(width: 80, alignment: .leading)
            Text(animation)
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func analyzeDemo() {
        let result = analyzer.analyze(demoText)
        animationStyle = result.intent.animationStyle
        islandMessage = analyzer.islandMessage(for: result)
        let response = analyzer.generateDetailedResponse(for: result)
        outputText = """
        {
          "intent": "\(result.intent.rawValue)",
          "confidence": \(String(format: "%.2f", result.confidence)),
          "triggers": [\(result.triggerWords.map { "\"\($0)\"" }.joined(separator: ", "))],
          "cause": \(result.detectedCause.map { "\"\($0)\"" } ?? "null"),
          "contexts": [\(result.contexts.map { "\"\($0.rawValue)\"" }.joined(separator: ", "))],
          "response": "\(response.replacingOccurrences(of: "**", with: ""))",
          "animation": "\(result.intent.animationDescription)"
        }
        """
    }
}
