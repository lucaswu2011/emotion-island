import SwiftUI

struct ContentView: View {
    @State private var viewModel = AppViewModel()
    /// 每次打开 App 先选语言，避免沿用上次的英文界面
    @State private var languageGatePassed = false

    var body: some View {
        Group {
            if !languageGatePassed {
                LanguageSelectionView(
                    suggestedLanguage: viewModel.appLanguage
                ) { language in
                    viewModel.selectLanguage(language)
                    languageGatePassed = true
                }
            } else {
                mainFlow
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
        .environment(viewModel)
        .alert(viewModel.strings.savedAlertTitle, isPresented: $viewModel.showSaveConfirmation) {
            Button(viewModel.strings.savedAlertOK) {
                viewModel.reset()
            }
        } message: {
            Text(viewModel.strings.savedAlertMessage)
        }
    }

    private var mainFlow: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            WelcomeView(
                strings: viewModel.strings,
                language: viewModel.appLanguage,
                onSelectLanguage: { viewModel.selectLanguage($0) },
                onStart: {
                    viewModel.navigate(to: .diaryInput)
                },
                onAbout: {
                    viewModel.navigate(to: .about)
                },
                onHistory: {
                    viewModel.navigate(to: .moodDiary)
                },
                onFullHistory: {
                    viewModel.navigate(to: .diaryHistory)
                }
            )
            .navigationDestination(for: AppScreen.self) { screen in
                destination(for: screen)
            }
        }
    }

    @ViewBuilder
    private func destination(for screen: AppScreen) -> some View {
        let s = viewModel.strings
        let lang = viewModel.appLanguage

        switch screen {
        case .welcome:
            EmptyView()

        case .diaryInput:
            DiaryInputView(
                strings: s,
                text: $viewModel.diaryText,
                onSubmit: {
                    guard !viewModel.diaryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    viewModel.analyzeCurrentText()
                    viewModel.navigate(to: .moodSelection)
                },
                onDemo: {
                    viewModel.navigate(to: .aiDemo)
                }
            )

        case .moodSelection:
            MoodSelectionView(
                strings: s,
                language: lang,
                text: $viewModel.diaryText,
                analysisResult: viewModel.analysisResult,
                islandMessage: viewModel.analysisResult.map {
                    viewModel.analyzer.islandMessage(for: $0, lang: lang)
                } ?? s.companionListening,
                onAnalyze: {
                    viewModel.analyzeCurrentText()
                },
                onContinue: {
                    viewModel.startConversation()
                    viewModel.navigate(to: .companionChat)
                }
            )

        case .companionChat:
            if let result = viewModel.analysisResult {
                CompanionChatView(
                    strings: s,
                    initialResult: result,
                    viewModel: viewModel,
                    onFinish: {
                        viewModel.navigate(to: .recognitionSummary)
                    }
                )
            } else {
                ContentUnavailableView(
                    s.chatUnavailableTitle,
                    systemImage: "bubble.left.and.exclamationmark",
                    description: Text(s.chatUnavailableBody)
                )
            }

        case .aiDemo:
            AIDemoView()
                .navigationTitle(s.aiDemoTitle)
                .navigationBarTitleDisplayMode(.inline)

        case .emotionCaught:
            if let result = viewModel.analysisResult {
                EmotionCaughtView(
                    result: result,
                    detailedResponse: viewModel.analyzer.generateDetailedResponse(for: result, lang: lang),
                    islandMessage: viewModel.analyzer.islandMessage(for: result, lang: lang),
                    onContinue: {
                        viewModel.navigate(to: .recognitionSummary)
                    }
                )
            }

        case .recognitionSummary:
            if let result = viewModel.analysisResult {
                RecognitionSummaryView(
                    strings: s,
                    language: lang,
                    result: result,
                    detailedResponse: summaryResponse,
                    onBack: {
                        viewModel.popToDiary()
                    },
                    onSave: {
                        viewModel.saveCurrentRecord()
                    }
                )
            }

        case .diaryHistory:
            DiaryHistoryView(strings: s, language: lang, records: viewModel.dataStore.records)

        case .moodDiary:
            MoodDiaryView(
                strings: s,
                language: lang,
                moodDiaryStore: viewModel.moodDiaryStore,
                onOpenFullHistory: {
                    viewModel.navigate(to: .diaryHistory)
                }
            )

        case .about:
            AboutView(strings: s)
                .navigationTitle(s.aboutTitle)
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var summaryResponse: String {
        if let lastAssistant = viewModel.conversation.messages.last(where: { $0.role == .assistant }) {
            return lastAssistant.text
        }
        if let result = viewModel.analysisResult {
            return viewModel.analyzer.generateDetailedResponse(for: result, lang: viewModel.appLanguage)
        }
        return ""
    }
}

#Preview {
    ContentView()
}
