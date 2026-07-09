import SwiftUI

struct DynamicIslandPill: View {
    let message: String
    let icon: String
    let iconColor: Color
    var showMetadata: Bool = false
    var metadata: String = ""
    var style: PillStyle = .dark

    enum PillStyle {
        case dark
        case light
    }

    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(iconColor)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(style == .dark ? .white : AppTheme.primaryText)
                    .lineLimit(2)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background {
                if style == .dark {
                    Capsule().fill(Color.black)
                } else {
                    Capsule()
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, y: 2)
                }
            }

            if showMetadata {
                Text(metadata)
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundStyle(AppTheme.secondaryText)
            }
        }
    }
}

struct DynamicIslandPreview: View {
    let animationStyle: HeartLeafAnimationStyle
    let size: CGFloat

    var body: some View {
        ZStack {
            Capsule()
                .fill(Color.black)
                .frame(width: size * 2.2, height: size * 0.7)

            HeartLeafAnimation(style: animationStyle, size: size * 0.35)
        }
    }
}
