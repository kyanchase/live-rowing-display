import SwiftUI

struct ActiveSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var sessionManager: SessionManager

    var body: some View {
        let viewModel = ActiveSessionViewModel(sessionManager: sessionManager)

        GeometryReader { proxy in
            let isLandscape = proxy.size.width > proxy.size.height

            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()

                if isLandscape {
                    landscapeContent(viewModel: viewModel)
                        .padding(16)
                } else {
                    portraitContent(viewModel: viewModel)
                        .padding(20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func header() -> some View {
        HStack {
            Text("Live Session")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)

            Spacer()

            GPSStatusBadge(status: sessionManager.gpsStatus)
        }
    }

    private func portraitContent(viewModel: ActiveSessionViewModel) -> some View {
        VStack(spacing: 18) {
            header()

            MetricCard(
                title: "Elapsed Time",
                value: viewModel.elapsedTime,
                unit: nil,
                isPrimary: true
            )

            metricGrid(viewModel: viewModel, isCompact: false)

            Spacer(minLength: 12)

            controls(viewModel: viewModel)
        }
    }

    private func landscapeContent(viewModel: ActiveSessionViewModel) -> some View {
        VStack(spacing: 12) {
            header()

            HStack(alignment: .top, spacing: 12) {
                MetricCard(
                    title: "Elapsed Time",
                    value: viewModel.elapsedTime,
                    unit: nil,
                    isPrimary: true,
                    isCompact: true
                )
                .frame(maxWidth: 230)

                metricGrid(viewModel: viewModel, isCompact: true)

                controls(viewModel: viewModel)
                    .frame(width: 180)
            }

            Spacer(minLength: 0)
        }
    }

    private func metricGrid(viewModel: ActiveSessionViewModel, isCompact: Bool) -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: isCompact ? 10 : 12),
                GridItem(.flexible(), spacing: isCompact ? 10 : 12)
            ],
            spacing: isCompact ? 10 : 12
        ) {
            MetricCard(
                title: "Distance",
                value: viewModel.distance,
                unit: "m",
                isCompact: isCompact
            )

            MetricCard(
                title: "Speed",
                value: viewModel.currentSpeed,
                unit: "m/s",
                isCompact: isCompact
            )

            MetricCard(
                title: "Current Split",
                value: viewModel.currentSplit,
                unit: "/500m",
                isCompact: isCompact
            )

            MetricCard(
                title: "Stroke Rate",
                value: viewModel.strokeRate,
                unit: "spm",
                isCompact: isCompact
            )
        }
    }

    private func controls(viewModel: ActiveSessionViewModel) -> some View {
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
            .disabled(sessionManager.state != .paused)
            .opacity(sessionManager.state == .paused ? 1 : 0.45)
        }
    }
}
