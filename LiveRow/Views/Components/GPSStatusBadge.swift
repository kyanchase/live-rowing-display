import SwiftUI

struct GPSStatusBadge: View {
    let status: GPSStatus

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: iconName)
            Text(status.displayName)
        }
        .font(.caption.weight(.semibold))
        .foregroundStyle(.white)
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(backgroundColor.opacity(0.25), in: Capsule())
        .overlay(
            Capsule()
                .stroke(backgroundColor.opacity(0.45), lineWidth: 1)
        )
    }

    private var iconName: String {
        switch status {
        case .ready:
            "location.fill"
        case .weak:
            "location.slash.fill"
        case .searching, .notDetermined:
            "location"
        case .denied:
            "exclamationmark.triangle.fill"
        }
    }

    private var backgroundColor: Color {
        switch status {
        case .ready:
            AppTheme.primaryAction
        case .weak, .searching, .notDetermined:
            .yellow
        case .denied:
            .red
        }
    }
}
