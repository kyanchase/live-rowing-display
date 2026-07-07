import SwiftUI

struct MetricCard: View {
    let title: String
    let value: String
    let unit: String?
    var isPrimary = false
    var isCompact = false

    var body: some View {
        VStack(alignment: .leading, spacing: isCompact ? 5 : 8) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.secondaryText)

            HStack(alignment: .lastTextBaseline, spacing: 6) {
                Text(value)
                    .font(.system(size: valueFontSize, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .foregroundStyle(.white)

                if let unit {
                    Text(unit)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: minimumHeight, alignment: .leading)
        .padding(isCompact ? 12 : 18)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppTheme.cardBorder, lineWidth: 1)
        )
    }

    private var valueFontSize: CGFloat {
        if isCompact {
            return isPrimary ? 40 : 28
        }

        return isPrimary ? 56 : 34
    }

    private var minimumHeight: CGFloat {
        if isCompact {
            return isPrimary ? 96 : 78
        }

        return isPrimary ? 132 : 112
    }
}
