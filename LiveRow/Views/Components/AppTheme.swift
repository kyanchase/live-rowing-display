import SwiftUI

enum AppTheme {
    static let primaryAction = Color(red: 0.64, green: 1.00, blue: 0.36)
    static let performanceBlue = Color(red: 0.19, green: 0.76, blue: 1.00)
    static let performanceOrange = Color(red: 1.00, green: 0.55, blue: 0.22)
    static let performanceViolet = Color(red: 0.62, green: 0.45, blue: 1.00)
    static let performanceRed = Color(red: 1.00, green: 0.24, blue: 0.22)
    static let secondaryText = Color.white.opacity(0.64)
    static let cardBackground = Color(red: 0.07, green: 0.08, blue: 0.08).opacity(0.9)
    static let controlBackground = Color.white.opacity(0.10)
    static let cardBorder = Color.white.opacity(0.16)
    static let glassHighlight = Color.white.opacity(0.24)
    static let glassShadow = Color.black.opacity(0.34)

    static let glassCardGradient = LinearGradient(
        colors: [
            Color.white.opacity(0.13),
            Color.white.opacity(0.055),
            Color.black.opacity(0.18)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let primaryActionGradient = LinearGradient(
        colors: [
            Color(red: 0.78, green: 1.00, blue: 0.52),
            primaryAction,
            Color(red: 0.42, green: 0.82, blue: 0.32)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let backgroundGradient = LinearGradient(
        colors: [
            Color(red: 0.015, green: 0.018, blue: 0.020),
            Color(red: 0.035, green: 0.052, blue: 0.052),
            Color(red: 0.005, green: 0.010, blue: 0.010)
        ],
        startPoint: .top,
        endPoint: .bottom
    )

    static let dashboardGlow = RadialGradient(
        colors: [
            performanceBlue.opacity(0.16),
            Color.clear
        ],
        center: .topTrailing,
        startRadius: 40,
        endRadius: 520
    )
}
