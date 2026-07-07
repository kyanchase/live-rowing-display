import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var sessionManager: SessionManager
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 28) {
                    Spacer()

                    VStack(spacing: 8) {
                        Text(viewModel.appName)
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text(viewModel.subtitle)
                            .font(.headline)
                            .foregroundStyle(AppTheme.secondaryText)
                    }

                    Spacer()

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
                        Button {
                        } label: {
                            Label("Previous Sessions", systemImage: "clock.arrow.circlepath")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(SecondaryActionButtonStyle())
                        .disabled(true)

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
    }
}
