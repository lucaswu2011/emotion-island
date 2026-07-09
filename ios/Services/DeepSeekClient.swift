import Foundation

/// DeepSeek Chat API（OpenAI 兼容格式）
struct DeepSeekClient: Sendable {

    enum ClientError: LocalizedError {
        case missingAPIKey
        case invalidResponse
        case emptyContent
        case httpError(status: Int, message: String)
        case decodeFailed

        var errorDescription: String? {
            switch self {
            case .missingAPIKey:
                return "未设置 DeepSeek API Key"
            case .invalidResponse:
                return "DeepSeek 返回格式异常"
            case .emptyContent:
                return "DeepSeek 未返回内容"
            case .httpError(let status, let message):
                return "DeepSeek 请求失败（\(status)）：\(message)"
            case .decodeFailed:
                return "无法解析 DeepSeek 响应"
            }
        }
    }

    private static let endpoint = URL(string: "https://api.deepseek.com/chat/completions")!
    private static let model = "deepseek-chat"
    private static let maxHistory = 24

    func complete(
        apiKey: String,
        messages: [ChatMessage],
        language: AppLanguage,
        intent: EmotionIntent
    ) async throws -> String {
        let trimmedKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedKey.isEmpty else { throw ClientError.missingAPIKey }

        var payloadMessages: [[String: String]] = [
            ["role": "system", "content": CompanionSystemPrompt.build(language: language, intent: intent)],
        ]

        let recent = messages.suffix(Self.maxHistory)
        for message in recent {
            let role = message.role == .user ? "user" : "assistant"
            let text = message.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty else { continue }
            payloadMessages.append(["role": role, "content": text])
        }

        let body: [String: Any] = [
            "model": Self.model,
            "messages": payloadMessages,
            "temperature": 0.85,
            "max_tokens": 600,
            "stream": false,
        ]

        var request = URLRequest(url: Self.endpoint)
        request.httpMethod = "POST"
        request.timeoutInterval = 45
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(trimmedKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw ClientError.httpError(status: -1, message: error.localizedDescription)
        }

        guard let http = response as? HTTPURLResponse else {
            throw ClientError.invalidResponse
        }

        guard (200...299).contains(http.statusCode) else {
            let message = Self.errorMessage(from: data) ?? String(data: data, encoding: .utf8) ?? "Unknown error"
            throw ClientError.httpError(status: http.statusCode, message: message)
        }

        guard let parsed = try? JSONDecoder().decode(DeepSeekAPIResponse.self, from: data),
              let content = parsed.choices.first?.message.content?.trimmingCharacters(in: .whitespacesAndNewlines),
              !content.isEmpty else {
            throw ClientError.emptyContent
        }

        return Self.sanitize(content)
    }

    private static func sanitize(_ text: String) -> String {
        var result = text
        result = result.replacingOccurrences(of: "**", with: "")
        result = result.replacingOccurrences(of: "__", with: "")
        if result.count > 900 {
            result = String(result.prefix(900))
        }
        return result.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func errorMessage(from data: Data) -> String? {
        struct ErrorBody: Decodable {
            struct Detail: Decodable {
                let message: String?
            }
            let error: Detail?
        }
        return (try? JSONDecoder().decode(ErrorBody.self, from: data))?.error?.message
    }
}

private struct DeepSeekAPIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let content: String?
        }
        let message: Message
    }
    let choices: [Choice]
}

enum CompanionAIReplyFormatter {
    static func emojis(intent: EmotionIntent, tone: SentimentTone) -> [String] {
        switch tone {
        case .positive:
            return ["😊", "✨"]
        case .negative:
            switch intent {
            case .anger: return ["🫂", "💙"]
            case .exhaustion: return ["🫂", "🍵"]
            default: return ["🫂", "💙"]
            }
        case .neutral:
            return ["🌿", "👂"]
        }
    }
}
