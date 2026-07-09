import SwiftUI

struct HeartLeafAnimation: View {
    let style: HeartLeafAnimationStyle
    var size: CGFloat = 24

    @State private var breathing = false
    @State private var trembling = false
    @State private var leafOffset: CGFloat = 0
    @State private var heartScale: CGFloat = 1
    @State private var morphProgress: CGFloat = 0
    @State private var wrapProgress: CGFloat = 0
    @State private var angerPulse = false

    var body: some View {
        ZStack {
            switch style {
            case .breathing:
                heartView()
                    .scaleEffect(breathing ? 1.1 : 0.9)

            case .contractAndTouch:
                heartView()
                    .scaleEffect(heartScale)
                leafView
                    .offset(x: leafOffset, y: size * CGFloat(-0.3))
                    .opacity(leafOffset > 0 ? 1.0 : 0.0)

            case .leafWrapsHeart:
                leafView
                    .scaleEffect(CGFloat(1) + wrapProgress * 0.4)
                    .rotationEffect(.degrees(wrapProgress * 15))
                heartView()
                    .scaleEffect(CGFloat(1) - wrapProgress * 0.1)

            case .heartUnfoldsToLeaf:
                if morphProgress < 0.5 {
                    heartView()
                        .scaleEffect(CGFloat(1) + morphProgress * 0.3)
                        .opacity(Double(CGFloat(1) - morphProgress * 2))
                }
                leafView
                    .scaleEffect(morphProgress)
                    .opacity(Double(morphProgress))

            case .trembleAndStroke:
                heartView()
                    .offset(x: trembling ? 1.5 : CGFloat(-1.5))
                leafView
                    .offset(x: size * 0.5)
                    .opacity(Double(leafOffset))

            case .pauseAndApproach:
                heartView()
                    .scaleEffect(heartScale)
                leafView
                    .offset(x: leafOffset - size)
                    .opacity(Double(0.4 + leafOffset / size * 0.6))

            case .angerPulseAndCalm:
                heartView(color: .orange)
                    .scaleEffect(angerPulse ? 1.2 : 0.95)
                leafView
                    .offset(y: angerPulse ? size * CGFloat(-0.15) : size * 0.1)
                    .opacity(angerPulse ? 0.9 : 0.5)
            }
        }
        .frame(width: size * 2, height: size * 1.5)
        .onAppear { startAnimation() }
        .onChange(of: style) { _, _ in startAnimation() }
    }

    private func heartView(color: Color = .pink) -> some View {
        Image(systemName: "heart.fill")
            .font(.system(size: size))
            .foregroundStyle(color)
    }

    private var leafView: some View {
        Image(systemName: "leaf.fill")
            .font(.system(size: size * 0.9))
            .foregroundStyle(AppTheme.softGreen)
    }

    private func startAnimation() {
        breathing = false
        trembling = false
        leafOffset = 0
        heartScale = 1
        morphProgress = 0
        wrapProgress = 0
        angerPulse = false

        switch style {
        case .breathing:
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                breathing = true
            }

        case .contractAndTouch:
            withAnimation(.easeInOut(duration: 0.6)) {
                heartScale = 0.85
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.5)) {
                leafOffset = size * 0.6
            }

        case .leafWrapsHeart:
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                wrapProgress = 1
            }

        case .heartUnfoldsToLeaf:
            withAnimation(.easeInOut(duration: 1.5)) {
                morphProgress = 1
            }

        case .trembleAndStroke:
            withAnimation(.easeInOut(duration: 0.1).repeatForever(autoreverses: true)) {
                trembling = true
            }
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                leafOffset = 1
            }

        case .pauseAndApproach:
            withAnimation(.easeInOut(duration: 0.4)) {
                heartScale = 0.95
            }
            withAnimation(.easeInOut(duration: 1.0).delay(0.5).repeatForever(autoreverses: true)) {
                leafOffset = size * 0.8
            }

        case .angerPulseAndCalm:
            withAnimation(.easeInOut(duration: 0.35).repeatForever(autoreverses: true)) {
                angerPulse = true
            }
        }
    }
}
