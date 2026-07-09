import SwiftUI

struct CompanionChatView: View {
    let strings: AppStrings
    let initialResult: EmotionAnalysisResult
    @Bindable var viewModel: AppViewModel
    let onFinish: () -> Void

    @State private var inputText = ""
    @FocusState private var inputFocused: Bool
    @State private var apiKeyDraft = ""

    private var session: ConversationSession { viewModel.conversation }

    var body: some View {
        VStack(spacing: 0) {
            chatHeader

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 20) {
                        sessionStatusBanner

                        if let error = viewModel.aiErrorMessage {
                            statusPill(error, color: Color.orange.opacity(0.12))
                        } else if viewModel.companionAIProvider == .deepSeek, !viewModel.isNetworkOnline {
                            statusPill(strings.networkOfflineHint, color: Color.orange.opacity(0.12))
                        }

                        ForEach(session.messages) { message in
                            ChatBubble(message: message)
                                .id(message.id)
                        }

                        if viewModel.isAwaitingAIReply {
                            TypingIndicatorBubble(text: strings.aiThinking)
                                .id("typing-indicator")
                        }

                        if session.isLongSession {
                            longSessionFooter
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .onChange(of: session.messages.count) { _, _ in
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: viewModel.isAwaitingAIReply) { _, isTyping in
                    if isTyping {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("typing-indicator", anchor: .bottom)
                        }
                    }
                }
            }

            chatInputBar
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(red: 0.98, green: 0.98, blue: 0.99))
        .navigationTitle(strings.chatTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                aiProviderMenu
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(strings.saveAndReview, action: onFinish)
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
        }
        .sheet(isPresented: $viewModel.showDeepSeekKeyPrompt) {
            deepSeekKeySheet
        }
        .onAppear {
            apiKeyDraft = viewModel.deepSeekAPIKey
            if session.messages.isEmpty {
                viewModel.startConversation()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                inputFocused = true
            }
        }
    }

    private var aiProviderMenu: some View {
        Menu {
            ForEach(CompanionAIProvider.allCases, id: \.self) { provider in
                Button {
                    viewModel.selectCompanionAIProvider(provider)
                } label: {
                    if viewModel.companionAIProvider == provider {
                        Label(provider.displayName(language: viewModel.appLanguage), systemImage: "checkmark")
                    } else {
                        Text(provider.displayName(language: viewModel.appLanguage))
                    }
                }
                .disabled(provider == .deepSeek && !viewModel.isNetworkOnline)
            }

            if viewModel.companionAIProvider == .deepSeek {
                Divider()
                Button(strings.deepSeekAPIKeyTitle) {
                    apiKeyDraft = viewModel.deepSeekAPIKey
                    viewModel.showDeepSeekKeyPrompt = true
                }
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: viewModel.companionAIProvider.iconName)
                    .font(.caption.weight(.semibold))
                Text(viewModel.companionAIProvider.shortLabel(language: viewModel.appLanguage))
                    .font(.caption.weight(.medium))
                Image(systemName: "chevron.down")
                    .font(.caption2)
            }
            .foregroundStyle(AppTheme.accentBlue)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(AppTheme.accentBlue.opacity(0.08))
            .clipShape(Capsule())
        }
    }

    private var deepSeekKeySheet: some View {
        NavigationStack {
            Form {
                Section {
                    SecureField(strings.deepSeekAPIKeyPlaceholder, text: $apiKeyDraft)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                } footer: {
                    Text(strings.deepSeekAPIKeyHint)
                        .font(.caption)
                }
            }
            .navigationTitle(strings.deepSeekAPIKeyTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(viewModel.appLanguage == .english ? "Cancel" : "取消") {
                        viewModel.showDeepSeekKeyPrompt = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(strings.deepSeekKeySave) {
                        viewModel.saveDeepSeekAPIKey(apiKeyDraft)
                    }
                    .disabled(apiKeyDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private var sessionStatusBanner: some View {
        Group {
            if session.disclosureStage == .emotionOnly || session.disclosureStage == .droppingHints {
                statusPill(strings.statusNoRush, color: AppTheme.softGreen.opacity(0.12))
            } else if session.disclosureStage == .unfolding {
                statusPill(strings.statusListening, color: Color.white)
            } else if session.distressLevel >= .overwhelming {
                statusPill(strings.statusOverwhelming, color: AppTheme.accentBlue.opacity(0.08))
            } else if session.isVentingHard {
                statusPill(strings.statusVenting, color: AppTheme.softGreen.opacity(0.12))
            } else if session.phase == .listening {
                statusPill(strings.statusDefault, color: Color.white)
            }
        }
    }

    private func statusPill(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(AppTheme.secondaryText)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(color)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.03), radius: 4, y: 2)
    }

    private var longSessionFooter: some View {
        VStack(spacing: 8) {
            Text("🌿")
                .font(.title2)
            Text(strings.longSessionFooter)
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 16)
    }

    private var chatHeader: some View {
        VStack(spacing: 12) {
            DynamicIslandPill(
                message: viewModel.chatIslandMessage,
                icon: session.dominantIntent.islandIcon,
                iconColor: ResponseFormatter.islandIconColor(for: session.dominantIntent),
                style: .light
            )

            HStack {
                AssistantBadge(language: viewModel.appLanguage)
                Spacer()
                if session.userTurnCount > 0 {
                    Text(strings.chatTurnLabel(session.userTurnCount))
                        .font(.caption2)
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color.white)
    }

    private var chatInputBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 12) {
                TextField(placeholderText, text: $inputText, axis: .vertical)
                    .lineLimit(1...8)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(AppTheme.cardGray)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .focused($inputFocused)
                    .onSubmit { sendMessage() }

                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 36))
                        .foregroundStyle(
                            canSend
                                ? AppTheme.accentBlue
                                : Color.gray.opacity(0.3)
                        )
                }
                .disabled(!canSend)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)

            PrivacyFooter(
                icon: viewModel.companionAIProvider == .deepSeek ? "network" : "lock.fill",
                text: viewModel.companionAIProvider == .deepSeek ? strings.chatPrivacyDeepSeek : strings.chatPrivacy
            )
            .padding(.bottom, 8)
        }
    }

    private var placeholderText: String {
        switch session.disclosureStage {
        case .emotionOnly, .droppingHints:
            return strings.chatPlaceholderEmotion
        case .unfolding:
            return strings.chatPlaceholderUnfolding
        case .readyForComfort:
            if session.distressLevel >= .high {
                return strings.chatPlaceholderDistress
            }
            return strings.chatPlaceholderComfort
        }
    }

    private var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && !viewModel.isAwaitingAIReply
    }

    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard canSend else { return }
        viewModel.sendChatMessage(text)
        inputText = ""
        inputFocused = true
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let last = session.messages.last {
            withAnimation(.easeOut(duration: 0.3)) {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }
}

// MARK: - 正在输入

private struct TypingIndicatorBubble: View {
    let text: String
    @State private var phase = 0.0

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            ZStack {
                Circle()
                    .fill(AppTheme.accentBlue.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: "leaf.fill")
                    .font(.caption)
                    .foregroundStyle(AppTheme.softGreen)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(AppTheme.secondaryText.opacity(0.5))
                            .frame(width: 6, height: 6)
                            .offset(y: sin(phase + Double(index) * 0.8) * 3)
                    }
                }
                Text(text)
                    .font(.caption)
                    .foregroundStyle(AppTheme.secondaryText)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: .black.opacity(0.05), radius: 4, y: 2)

            Spacer(minLength: 36)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: false)) {
                phase = .pi * 2
            }
        }
    }
}

// MARK: - 聊天气泡

private struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if message.role == .assistant {
                assistantAvatar
            } else {
                Spacer(minLength: 36)
            }

            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 10) {
                Text(message.text)
                    .font(.body)
                    .foregroundStyle(message.role == .user ? .white : AppTheme.primaryText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(message.role == .user ? AppTheme.accentBlue : Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: .black.opacity(message.role == .assistant ? 0.05 : 0), radius: 4, y: 2)

                if message.role == .assistant, !message.emojis.isEmpty {
                    EmojiStrip(emojis: message.emojis)
                }
            }
            .frame(maxWidth: 440, alignment: message.role == .user ? .trailing : .leading)

            if message.role == .user {
                userAvatar
            } else {
                Spacer(minLength: 36)
            }
        }
    }

    private var assistantAvatar: some View {
        ZStack {
            Circle()
                .fill(AppTheme.accentBlue.opacity(0.12))
                .frame(width: 36, height: 36)
            Image(systemName: "leaf.fill")
                .font(.caption)
                .foregroundStyle(AppTheme.softGreen)
        }
    }

    private var userAvatar: some View {
        ZStack {
            Circle()
                .fill(Color.gray.opacity(0.12))
                .frame(width: 36, height: 36)
            Image(systemName: "person.fill")
                .font(.caption)
                .foregroundStyle(AppTheme.secondaryText)
        }
    }
}

// MARK: - 表情条

struct EmojiStrip: View {
    let emojis: [String]
    @State private var appeared = false

    var body: some View {
        HStack(spacing: 10) {
            ForEach(Array(emojis.enumerated()), id: \.offset) { index, emoji in
                Text(emoji)
                    .font(.system(size: 36))
                    .scaleEffect(appeared ? 1 : 0.2)
                    .opacity(appeared ? 1 : 0)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.55).delay(Double(index) * 0.1),
                        value: appeared
                    )
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(AppTheme.cardGray.opacity(0.6))
        .clipShape(Capsule())
        .onAppear { appeared = true }
        .onChange(of: emojis) { _, _ in
            appeared = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                appeared = true
            }
        }
    }
}
