import SwiftUI

struct GPSStatusBadge: View {
    let status: GPSStatus

    var body: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)

            Text(status.displayName)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 7)
        .background(AppTheme.controlBackground, in: Capsule())
    }

    private var color: Color {
        switch status {
        case .ready:
            .green
        case .weak, .searching:
            .yellow
        case .denied:
            .red
        case .notDetermined:
            .gray
        }
    }
}
