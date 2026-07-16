import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()

                AppTheme.dashboardGlow
                    .ignoresSafeArea()

                VStack(spacing: 22) {
                    HStack {
                        Text(viewModel.appName)
                            .font(.system(size: 46, weight: .black, design: .rounded))
                            .foregroundStyle(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.82)

                        Spacer()

                        Text("READY")
                            .font(.caption.weight(.black))
                            .foregroundStyle(AppTheme.primaryAction)
                            .padding(.horizontal, 10)
                            .frame(height: 30)
                            .background(AppTheme.primaryAction.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(AppTheme.primaryAction.opacity(0.34), lineWidth: 1)
                            )
                    }

                    HomeOverviewPanel(latestSession: sessionManager.completedSessions.first)

                    Spacer(minLength: 0)

                    NavigationLink {
                        ActiveSessionView()
                            .environmentObject(sessionManager)
                    } label: {
                        Label("Start Session", systemImage: "play.fill")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PrimaryActionButtonStyle())
                    .simultaneousGesture(TapGesture().onEnded {
                        sessionManager.startSession()
                    })

                    VStack(spacing: 14) {
                        NavigationLink {
                            PreviousSessionsView()
                                .environmentObject(sessionManager)
                        } label: {
                            Label("Previous Sessions", systemImage: "clock.arrow.circlepath")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(SecondaryActionButtonStyle())

                        Button {
                        } label: {
                            Label("Settings", systemImage: "gearshape.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(SecondaryActionButtonStyle())
                        .disabled(true)
                    }
                }
                .padding(24)
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

private struct HomeOverviewPanel: View {
    let latestSession: RowSession?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if let latestSession {
                previousSessionContent(latestSession)
            } else {
                readyContent
            }
        }
        .padding(18)
        .background(AppTheme.cardBackground, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .background(AppTheme.glassCardGradient, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(AppTheme.cardBorder, lineWidth: 1)
        )
        .overlay(alignment: .topTrailing) {
            Rectangle()
                .fill(AppTheme.primaryAction.opacity(0.18))
                .frame(width: 130, height: 1)
                .padding(.trailing, 16)
        }
        .shadow(color: AppTheme.glassShadow, radius: 20, x: 0, y: 12)
    }

    private var readyContent: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("READY TO ROW")
                        .font(.caption.weight(.black))
                        .foregroundStyle(AppTheme.primaryAction)

                    Text("Start a session when your phone is mounted.")
                        .font(.title3.weight(.black))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "figure.rower")
                    .font(.system(size: 38, weight: .black))
                    .foregroundStyle(AppTheme.primaryAction)
            }

            HStack(spacing: 12) {
                HomeSignal(title: "DISPLAY", value: "Set", accent: AppTheme.performanceBlue)
                HomeSignal(title: "GPS", value: "Ready", accent: AppTheme.primaryAction)
                HomeSignal(title: "HISTORY", value: "Empty", accent: AppTheme.performanceViolet)
            }
        }
    }

    private func previousSessionContent(_ session: RowSession) -> some View {
        let averageSplit = SplitCalculator.averageSplitSeconds(
            distanceMeters: session.distanceMeters,
            elapsedTime: session.elapsedTime
        )

        return VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("LAST SESSION")
                        .font(.caption.weight(.black))
                        .foregroundStyle(AppTheme.primaryAction)

                    Text(RowFormatting.sessionDate(session.startedAt))
                        .font(.headline.weight(.black))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.76)
                }

                Spacer()

                Text(RowFormatting.time(session.elapsedTime))
                    .font(.system(size: 40, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(.white)
            }

            HStack(spacing: 12) {
                HomeSignal(
                    title: "DIST",
                    value: "\(RowFormatting.distanceMeters(session.distanceMeters)) m",
                    accent: AppTheme.performanceBlue
                )

                HomeSignal(
                    title: "SPLIT",
                    value: RowFormatting.split(averageSplit),
                    accent: AppTheme.performanceViolet
                )

                HomeSignal(
                    title: "TOP SPD",
                    value: RowFormatting.speed(session.maximumSpeedMetersPerSecond),
                    accent: AppTheme.performanceOrange
                )
            }
        }
    }
}

private struct HomeSignal: View {
    let title: String
    let value: String
    let accent: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(spacing: 6) {
                Circle()
                    .fill(accent)
                    .frame(width: 6, height: 6)
                    .shadow(color: accent.opacity(0.7), radius: 6, x: 0, y: 0)

                Text(title)
                    .font(.caption2.weight(.black))
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Text(value)
                .font(.headline.weight(.black))
                .monospacedDigit()
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
