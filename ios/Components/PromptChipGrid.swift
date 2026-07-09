import SwiftUI

/// 方块状引导词条网格 — 平铺在页面上，无需横向拖动
struct PromptChipGrid: View {
    let chips: [ChatPromptChips.Chip]
    let selectedMessage: String
    let onSelect: (ChatPromptChips.Chip) -> Void
    var compact: Bool = false

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var columns: [GridItem] {
        let minimum: CGFloat = compact ? 88 : (horizontalSizeClass == .regular ? 112 : 96)
        return [GridItem(.adaptive(minimum: minimum, maximum: compact ? 120 : 140), spacing: 10)]
    }

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(chips) { chip in
                Button {
                    onSelect(chip)
                } label: {
                    chipTile(chip)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func chipTile(_ chip: ChatPromptChips.Chip) -> some View {
        let isSelected = selectedMessage == chip.message

        return Text(chip.label)
            .font(compact ? .caption2.weight(.medium) : .caption.weight(.medium))
            .foregroundStyle(isSelected ? .white : AppTheme.primaryText)
            .multilineTextAlignment(.center)
            .lineLimit(compact ? 3 : 4)
            .minimumScaleFactor(0.85)
            .padding(.horizontal, 8)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(isSelected ? AppTheme.accentBlue : AppTheme.cardGray)
            .clipShape(RoundedRectangle(cornerRadius: compact ? 12 : 14))
            .overlay(
                RoundedRectangle(cornerRadius: compact ? 12 : 14)
                    .stroke(isSelected ? AppTheme.accentBlue : Color.gray.opacity(0.15), lineWidth: 1)
            )
    }
}
