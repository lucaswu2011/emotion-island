import SwiftUI

struct AboutView: View {
    let strings: AppStrings

    private var isEnglish: Bool { strings.language == .english }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.accentBlue.opacity(0.12))
                            .frame(width: 48, height: 48)
                        Image(systemName: "heart.fill")
                            .foregroundStyle(AppTheme.accentBlue)
                    }

                    Text(strings.aboutBadge)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(AppTheme.softGreen)
                        .clipShape(Capsule())
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text(strings.aboutHeading)
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(AppTheme.primaryText)

                    Text(strings.aboutIntro)
                        .font(.body)
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineSpacing(4)
                }

                Divider()

                VStack(alignment: .leading, spacing: 20) {
                    Text(strings.aboutOriginLabel)
                        .font(.caption)
                        .foregroundStyle(AppTheme.accentBlue)

                    Text(strings.aboutOriginTitle)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(AppTheme.primaryText)

                    HStack(alignment: .top, spacing: 16) {
                        Rectangle()
                            .fill(AppTheme.accentBlue)
                            .frame(width: 4)

                        Text(isEnglish
                             ? "\"Once I wanted to say I was lonely, but all I wrote was 'I'm fine today' — because I didn't know where to start.\""
                             : "\"有一次，我特别想表达孤独，但最后只写了'今天还好'——因为不知道从哪说起。\"")
                            .font(.body.italic())
                            .foregroundStyle(AppTheme.primaryText)
                            .lineSpacing(4)
                    }

                    Text(isEnglish
                         ? "That sentence is where Emotion Island began. Companion shouldn't come with conditions — you don't have to perform or improve. Just write one honest line about how you feel right now."
                         : "这句话是情绪岛的起点。陪伴不该附带条件——不需要你完成什么，不需要你变得更好，只需要你愿意写下此刻最真实的一句话。")
                        .font(.body)
                        .foregroundStyle(AppTheme.primaryText)
                        .lineSpacing(6)

                    Text(isEnglish
                         ? "Emotion Island exists for that moment when you don't know where to start."
                         : "情绪岛就是为那个「不知道从哪说起」的瞬间而存在的。")
                        .font(.body.weight(.medium))
                        .foregroundStyle(AppTheme.primaryText)
                }

                philosophySection
                privacySection
            }
            .padding(40)
            .frame(maxWidth: 700, alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }

    private var philosophySection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(strings.aboutPhilosophyLabel)
                .font(.caption)
                .foregroundStyle(AppTheme.accentBlue)

            philosophyCard(
                icon: "moon.stars",
                title: isEnglish ? "Quiet company" : "安静陪伴",
                description: isEnglish
                    ? "No streaks, no rankings, no social feed. Write when you want to."
                    : "没有打卡、没有排行榜、没有社交。你想写的时候才写。"
            )
            philosophyCard(
                icon: "heart.text.clipboard",
                title: isEnglish ? "Gentle response" : "温柔回应",
                description: isEnglish
                    ? "Write \"I'm fine today\" and local keyword rules may gently surface what you didn't say."
                    : "写下「今天还好」，会用关键词规则识别背后可能藏着的孤独，轻轻问你那些没说出口的部分。"
            )
            philosophyCard(
                icon: "hand.raised",
                title: isEnglish ? "No punishment" : "没有惩罚",
                description: isEnglish
                    ? "No blame for \"not keeping up.\" Only warm holding and gentle guidance."
                    : "不会因为「没坚持」而责备你。只有温暖的托住和正向引导。"
            )
        }
    }

    private func philosophyCard(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(AppTheme.accentBlue)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundStyle(AppTheme.secondaryText)
                    .lineSpacing(3)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.cardGray)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private var privacySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(strings.aboutPrivacyLabel)
                .font(.caption)
                .foregroundStyle(AppTheme.accentBlue)

            VStack(alignment: .leading, spacing: 8) {
                privacyItem(isEnglish ? "Data never leaves your device" : "数据永不离开设备")
                privacyItem(isEnglish ? "No upload, share, or sync" : "不上传、不分享、不同步")
                privacyItem(isEnglish ? "Offline script library on device" : "设备端本地话术库离线运行")
                privacyItem(isEnglish ? "Local mode works without network" : "本地模式无需联网")
                privacyItem(isEnglish ? "Optional DeepSeek sends chat only when you choose it" : "可选 DeepSeek 仅在手动切换时联网对话")
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(AppTheme.softGreen.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private func privacyItem(_ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(AppTheme.softGreen)
                .font(.caption)
            Text(text)
                .font(.subheadline)
        }
    }
}
