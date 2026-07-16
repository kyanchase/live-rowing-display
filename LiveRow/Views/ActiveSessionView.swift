import SwiftUI

struct ActiveSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var sessionManager: SessionManager
    @AppStorage("portraitMetricSlot0") private var portraitMetricSlot0 = SessionMetricOption.elapsedTime.rawValue
    @AppStorage("portraitMetricSlot1") private var portraitMetricSlot1 = SessionMetricOption.distance.rawValue
    @AppStorage("portraitMetricSlot2") private var portraitMetricSlot2 = SessionMetricOption.currentSpeed.rawValue
    @AppStorage("portraitMetricSlot3") private var portraitMetricSlot3 = SessionMetricOption.currentSplit.rawValue
    @AppStorage("portraitMetricSlot4") private var portraitMetricSlot4 = SessionMetricOption.strokeRate.rawValue
    @AppStorage("landscapeMetricSlot0") private var landscapeMetricSlot0 = SessionMetricOption.elapsedTime.rawValue
    @AppStorage("landscapeMetricSlot1") private var landscapeMetricSlot1 = SessionMetricOption.distance.rawValue
    @AppStorage("landscapeMetricSlot2") private var landscapeMetricSlot2 = SessionMetricOption.currentSplit.rawValue
    @AppStorage("landscapeMetricSlot3") private var landscapeMetricSlot3 = SessionMetricOption.strokeRate.rawValue
    @State private var selectedMetricSlot: MetricSlotTarget?
    @State private var isControlTrayExpanded = false

    var body: some View {
        let viewModel = ActiveSessionViewModel(sessionManager: sessionManager)

        GeometryReader { proxy in
            let isLandscape = proxy.size.width > proxy.size.height

            ZStack {
                AppTheme.backgroundGradient
                    .ignoresSafeArea()

                AppTheme.dashboardGlow
                    .ignoresSafeArea()

                if isLandscape {
                    landscapeContent(viewModel: viewModel)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                } else {
                    portraitContent(viewModel: viewModel)
                        .padding(20)
                }

                if let selectedMetricSlot {
                    metricPickerOverlay(for: selectedMetricSlot, isLandscape: isLandscape)
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

            portraitMetricCard(at: 0, viewModel: viewModel, isPrimary: true)

            portraitMetricGrid(viewModel: viewModel)

            Spacer(minLength: 12)

            controls(viewModel: viewModel)
        }
    }

    private func landscapeContent(viewModel: ActiveSessionViewModel) -> some View {
        ZStack(alignment: .topTrailing) {
            landscapeMetricGrid(viewModel: viewModel)

            collapsibleControls(viewModel: viewModel)
        }
    }

    private func portraitMetricGrid(viewModel: ActiveSessionViewModel) -> some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {
            ForEach(1..<5, id: \.self) { index in
                portraitMetricCard(at: index, viewModel: viewModel)
            }
        }
    }

    private func landscapeMetricGrid(viewModel: ActiveSessionViewModel) -> some View {
        VStack(spacing: 10) {
            ForEach(0..<2, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<2, id: \.self) { column in
                        let index = row * 2 + column
                        let metric = metric(for: .landscape(index))

                        MetricCard(
                            title: metric.title,
                            value: metric.value(from: viewModel),
                            unit: metric.unit,
                            isPrimary: metric == .elapsedTime,
                            isCompact: true,
                            isDashboardCard: true,
                            accent: metric.accent
                        )
                        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                        .onLongPressGesture {
                            showMetricPicker(for: .landscape(index))
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

    private func portraitMetricCard(
        at index: Int,
        viewModel: ActiveSessionViewModel,
        isPrimary: Bool = false
    ) -> some View {
        let metric = metric(for: .portrait(index))

        return MetricCard(
            title: metric.title,
            value: metric.value(from: viewModel),
            unit: metric.unit,
            isPrimary: isPrimary || metric == .elapsedTime,
            accent: metric.accent
        )
        .contentShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .onLongPressGesture {
            showMetricPicker(for: .portrait(index))
        }
    }

    private func metricPickerOverlay(for slot: MetricSlotTarget, isLandscape: Bool) -> some View {
        ZStack(alignment: isLandscape ? .center : .bottom) {
            Color.black.opacity(0.48)
                .ignoresSafeArea()
                .onTapGesture {
                    hideMetricPicker()
                }

            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Choose Metric")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)

                        Text(metric(for: slot).title)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(metric(for: slot).accent)
                    }

                    Spacer()

                    Button {
                        hideMetricPicker()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.subheadline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(AppTheme.controlBackground, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }

                if isLandscape {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ],
                        spacing: 10
                    ) {
                        metricPickerButtons(for: slot)
                    }
                } else {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 10),
                            GridItem(.flexible(), spacing: 10)
                        ],
                        spacing: 10
                    ) {
                        metricPickerButtons(for: slot)
                    }
                }
            }
            .padding(16)
            .frame(maxWidth: isLandscape ? 620 : .infinity)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .background(AppTheme.glassCardGradient, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
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
            .shadow(color: Color.black.opacity(0.44), radius: 24, x: 0, y: 16)
            .padding(isLandscape ? 24 : 16)
            .transition(.scale(scale: 0.96).combined(with: .opacity))
        }
    }

    private func metricPickerButtons(for slot: MetricSlotTarget) -> some View {
        ForEach(SessionMetricOption.allCases) { option in
            let isSelected = metric(for: slot) == option

            Button {
                setMetric(option, for: slot)
                hideMetricPicker()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: option.systemImage)
                        .font(.headline.weight(.semibold))
                        .frame(width: 22)

                    Text(option.title)
                        .font(.subheadline.weight(.bold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.76)

                    Spacer(minLength: 0)

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.subheadline.weight(.bold))
                    }
                }
                .foregroundStyle(isSelected ? .black : .white)
                .padding(.horizontal, 12)
                .frame(height: 48)
                .background(
                    isSelected ? option.accent.opacity(0.95) : Color.white.opacity(0.08),
                    in: RoundedRectangle(cornerRadius: 8, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(isSelected ? option.accent.opacity(0.58) : AppTheme.cardBorder, lineWidth: 1)
                )
                .shadow(color: isSelected ? option.accent.opacity(0.20) : .clear, radius: 12, x: 0, y: 0)
            }
            .buttonStyle(.plain)
        }
    }

    private func collapsibleControls(viewModel: ActiveSessionViewModel) -> some View {
        VStack(alignment: .trailing, spacing: 10) {
            Button {
                withAnimation(.spring(response: 0.24, dampingFraction: 0.86)) {
                    isControlTrayExpanded.toggle()
                }
            } label: {
                HStack(spacing: 9) {
                    Image(systemName: sessionManager.state == .paused ? "play.fill" : "pause.fill")
                        .font(.subheadline.weight(.black))

                    Text("Session")
                        .font(.subheadline.weight(.black))

                    Image(systemName: isControlTrayExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption.weight(.black))
                        .foregroundStyle(AppTheme.secondaryText)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .frame(height: 44)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .background(AppTheme.glassCardGradient, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(AppTheme.cardBorder, lineWidth: 1)
                )
                .shadow(color: AppTheme.glassShadow, radius: 14, x: 0, y: 8)
            }

            if isControlTrayExpanded {
                controls(viewModel: viewModel)
                    .frame(width: 176)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
    }

    private func metric(for slot: MetricSlotTarget) -> SessionMetricOption {
        switch slot {
        case .portrait(let index):
            switch index {
            case 0:
                return SessionMetricOption(rawValue: portraitMetricSlot0) ?? .elapsedTime
            case 1:
                return SessionMetricOption(rawValue: portraitMetricSlot1) ?? .distance
            case 2:
                return SessionMetricOption(rawValue: portraitMetricSlot2) ?? .currentSpeed
            case 3:
                return SessionMetricOption(rawValue: portraitMetricSlot3) ?? .currentSplit
            default:
                return SessionMetricOption(rawValue: portraitMetricSlot4) ?? .strokeRate
            }
        case .landscape(let index):
            switch index {
            case 0:
                return SessionMetricOption(rawValue: landscapeMetricSlot0) ?? .elapsedTime
            case 1:
                return SessionMetricOption(rawValue: landscapeMetricSlot1) ?? .distance
            case 2:
                return SessionMetricOption(rawValue: landscapeMetricSlot2) ?? .currentSplit
            default:
                return SessionMetricOption(rawValue: landscapeMetricSlot3) ?? .strokeRate
            }
        }
    }

    private func setMetric(_ metric: SessionMetricOption, for slot: MetricSlotTarget) {
        switch slot {
        case .portrait(let index):
            switch index {
            case 0:
                portraitMetricSlot0 = metric.rawValue
            case 1:
                portraitMetricSlot1 = metric.rawValue
            case 2:
                portraitMetricSlot2 = metric.rawValue
            case 3:
                portraitMetricSlot3 = metric.rawValue
            default:
                portraitMetricSlot4 = metric.rawValue
            }
        case .landscape(let index):
            switch index {
            case 0:
                landscapeMetricSlot0 = metric.rawValue
            case 1:
                landscapeMetricSlot1 = metric.rawValue
            case 2:
                landscapeMetricSlot2 = metric.rawValue
            default:
                landscapeMetricSlot3 = metric.rawValue
            }
        }
    }

    private func showMetricPicker(for slot: MetricSlotTarget) {
        withAnimation(.spring(response: 0.24, dampingFraction: 0.88)) {
            selectedMetricSlot = slot
        }
    }

    private func hideMetricPicker() {
        withAnimation(.spring(response: 0.22, dampingFraction: 0.9)) {
            selectedMetricSlot = nil
        }
    }
}

private enum MetricSlotTarget: Identifiable {
    case portrait(Int)
    case landscape(Int)

    var id: String {
        switch self {
        case .portrait(let index):
            return "portrait-\(index)"
        case .landscape(let index):
            return "landscape-\(index)"
        }
    }
}

private enum SessionMetricOption: String, CaseIterable, Identifiable {
    case elapsedTime
    case distance
    case currentSpeed
    case currentSplit
    case averageSplit
    case strokeRate

    var id: String { rawValue }

    var title: String {
        switch self {
        case .elapsedTime:
            return "Elapsed Time"
        case .distance:
            return "Distance"
        case .currentSpeed:
            return "Speed"
        case .currentSplit:
            return "Current Split"
        case .averageSplit:
            return "Average Split"
        case .strokeRate:
            return "Stroke Rate"
        }
    }

    var unit: String? {
        switch self {
        case .elapsedTime:
            return nil
        case .distance:
            return "m"
        case .currentSpeed:
            return "m/s"
        case .currentSplit, .averageSplit:
            return "/500m"
        case .strokeRate:
            return "spm"
        }
    }

    var systemImage: String {
        switch self {
        case .elapsedTime:
            return "timer"
        case .distance:
            return "point.topleft.down.curvedto.point.bottomright.up"
        case .currentSpeed:
            return "speedometer"
        case .currentSplit:
            return "flag.checkered"
        case .averageSplit:
            return "chart.line.uptrend.xyaxis"
        case .strokeRate:
            return "metronome"
        }
    }

    var accent: Color {
        switch self {
        case .elapsedTime:
            return AppTheme.primaryAction
        case .distance:
            return AppTheme.performanceBlue
        case .currentSpeed:
            return AppTheme.performanceOrange
        case .currentSplit:
            return AppTheme.performanceViolet
        case .averageSplit:
            return Color(red: 0.30, green: 0.92, blue: 0.68)
        case .strokeRate:
            return Color(red: 1.00, green: 0.40, blue: 0.62)
        }
    }

    @MainActor
    func value(from viewModel: ActiveSessionViewModel) -> String {
        switch self {
        case .elapsedTime:
            return viewModel.elapsedTime
        case .distance:
            return viewModel.distance
        case .currentSpeed:
            return viewModel.currentSpeed
        case .currentSplit:
            return viewModel.currentSplit
        case .averageSplit:
            return viewModel.averageSplit
        case .strokeRate:
            return viewModel.strokeRate
        }
    }
}
