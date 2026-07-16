import SwiftUI

struct MetricCard: View {
    let title: String
    let value: String
    let unit: String?
    var isPrimary = false
    var isCompact = false
    var isDashboardCard = false
    var accent = AppTheme.primaryAction

    var body: some View {
        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .fill(accentGradient)
                .frame(width: 5)
                .shadow(color: accent.opacity(0.44), radius: 10, x: 0, y: 0)

            VStack(alignment: .leading, spacing: verticalSpacing) {
                HStack(spacing: 8) {
                    Circle()
                        .fill(accent)
                        .frame(width: 7, height: 7)
                        .shadow(color: accent.opacity(0.7), radius: 6, x: 0, y: 0)

                    Text(title.uppercased())
                        .font(titleFont)
                        .foregroundStyle(AppTheme.secondaryText)
                        .lineLimit(1)
                        .minimumScaleFactor(0.72)
                }

                HStack(alignment: .lastTextBaseline, spacing: 6) {
                    Text(value)
                        .font(.system(size: valueFontSize, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.65)
                        .foregroundStyle(.white)

                    if let unit {
                        Text(unit)
                            .font(unitFont)
                            .foregroundStyle(AppTheme.secondaryText)
                            .lineLimit(1)
                            .minimumScaleFactor(0.72)
                    }
                }

                if isDashboardCard {
                    Spacer(minLength: 0)
                }
            }
            .padding(cardPadding)
        }
        .frame(
            maxWidth: .infinity,
            minHeight: minimumHeight,
            maxHeight: isDashboardCard ? .infinity : nil,
            alignment: .leading
        )
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .background(AppTheme.glassCardGradient, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(alignment: .topTrailing) {
            Rectangle()
                .fill(accent.opacity(0.18))
                .frame(width: 72, height: 1)
                .padding(.trailing, 14)
                .padding(.top, 1)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppTheme.cardBorder, lineWidth: 1)
        )
        .overlay(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppTheme.glassHighlight, lineWidth: 1)
                .mask(
                    LinearGradient(
                        colors: [.white, .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .shadow(color: accent.opacity(0.08), radius: 22, x: 0, y: 0)
        .shadow(color: AppTheme.glassShadow, radius: 18, x: 0, y: 12)
    }

    private var accentGradient: LinearGradient {
        LinearGradient(
            colors: [
                accent.opacity(0.35),
                accent,
                accent.opacity(0.42)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var verticalSpacing: CGFloat {
        if isDashboardCard {
            return 16
        }

        return isCompact ? 7 : 10
    }

    private var titleFont: Font {
        isDashboardCard ? .subheadline.weight(.black) : .caption.weight(.black)
    }

    private var unitFont: Font {
        isDashboardCard ? .title2.weight(.black) : .subheadline.weight(.bold)
    }

    private var cardPadding: CGFloat {
        if isDashboardCard {
            return 20
        }

        return isCompact ? 14 : 18
    }

    private var valueFontSize: CGFloat {
        if isDashboardCard {
            return isPrimary ? 60 : 50
        }

        if isCompact {
            return isPrimary ? 42 : 30
        }

        return isPrimary ? 58 : 35
    }

    private var minimumHeight: CGFloat {
        if isDashboardCard {
            return 0
        }

        if isCompact {
            return isPrimary ? 96 : 78
        }

        return isPrimary ? 132 : 112
    }
}
