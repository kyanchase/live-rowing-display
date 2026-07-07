import SwiftUI

struct PreviousSessionsView: View {
    @EnvironmentObject private var sessionManager: SessionManager

    var body: some View {
        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()

            if sessionManager.completedSessions.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "clock.arrow.circlepath")
                        .font(.system(size: 42, weight: .semibold))
                        .foregroundStyle(AppTheme.secondaryText)

                    Text("No Previous Sessions")
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(sessionManager.completedSessions) { session in
                            PreviousSessionRow(session: session)
                        }
                    }
                    .padding(20)
                }
            }
        }
        .navigationTitle("Previous Sessions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct PreviousSessionRow: View {
    let session: RowSession

    private var averageSplit: TimeInterval? {
        SplitCalculator.averageSplitSeconds(
            distanceMeters: session.distanceMeters,
            elapsedTime: session.elapsedTime
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(RowFormatting.sessionDate(session.startedAt))
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)

            HStack(spacing: 12) {
                HistoryMetric(
                    title: "Meters",
                    value: RowFormatting.distanceMeters(session.distanceMeters)
                )

                HistoryMetric(
                    title: "Avg Split",
                    value: RowFormatting.split(averageSplit)
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppTheme.cardBorder, lineWidth: 1)
        )
    }
}

private struct HistoryMetric: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased())
                .font(.caption.weight(.semibold))
                .foregroundStyle(AppTheme.secondaryText)

            Text(value)
                .font(.title3.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
