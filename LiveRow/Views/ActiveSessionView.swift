import SwiftUI

struct ActiveSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var sessionManager: SessionManager

    var body: some View {
        let viewModel = ActiveSessionViewModel(sessionManager: sessionManager)

        ZStack {
            AppTheme.backgroundGradient
                .ignoresSafeArea()

            VStack(spacing: 18) {
                HStack {
                    Text("Live Session")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(.white)

                    Spacer()

                    GPSStatusBadge(status: sessionManager.gpsStatus)
                }

                    MetricCard(
                        title: "Elapsed Time",
                        value: viewModel.elapsedTime,
                        unit: nil,
                        isPrimary: true
                    )

                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    MetricCard(
                        title: "Distance",
                        value: viewModel.distance,
                        unit: "m"
                    )

                    MetricCard(
                        title: "Speed",
                        value: viewModel.currentSpeed,
                        unit: "m/s"
                    )

                    MetricCard(
                        title: "Current Split",
                        value: viewModel.currentSplit,
                        unit: "/500m"
                    )

                    MetricCard(
                        title: "Average Split",
                        value: viewModel.averageSplit,
                        unit: "/500m"
                    )
                }

                Spacer(minLength: 12)

                VStack(spacing: 14) {
                    Button {
                        sessionManager.pauseSession()
                    } label: {
                        Label(
                            viewModel.pauseButtonTitle,
                            systemImage: sessionManager.state == .paused ? "play.fill" : "pause.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(SecondaryActionButtonStyle())

                    Button(role: .destructive) {
                        sessionManager.stopSession()
                        dismiss()
                    } label: {
                        Label("Stop", systemImage: "stop.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(StopActionButtonStyle())
                }
            }
            .padding(20)
        }
        .navigationBarBackButtonHidden(true)
    }
}
