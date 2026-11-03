import SwiftUI

/// 整个 App 的壳：一条进度条 + 四步内容 + 底部翻页。
/// 与前两个 App 不同，这里没有 TabView，也没有把全部输入挤在一页上。
struct StitchWizardView: View {
    @EnvironmentObject private var state: StitchAppState

    @State private var step = 0
    @State private var gauge = StitchGauge()
    @State private var project = StitchProject()
    @State private var weight: StitchWeight = .worsted
    @State private var skein = StitchSkein()
    @State private var safety: StitchSafety = .ten

    @State private var showInfo = false
    @State private var showLibrary = false

    private let totalSteps = 4

    private var plan: StitchPlan {
        StitchPlan.make(gauge: gauge, project: project, skein: skein, safety: safety)
    }

    private var title: String {
        switch step {
        case 0: return StitchText.stepGauge
        case 1: return StitchText.stepSize
        case 2: return StitchText.stepYarn
        default: return StitchText.stepResult
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                progressBar
                ScrollView {
                    content
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                        .padding(.bottom, 30)
                }
                footer
            }
            .background(StitchPalette.linen.opacity(0.45))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showLibrary = true
                        } label: {
                            Label(StitchText.libraryTitle, systemImage: "square.stack")
                        }
                        Button {
                            showInfo = true
                        } label: {
                            Label(StitchText.infoTitle, systemImage: "info.circle")
                        }
                        Divider()
                        Button(role: .destructive) {
                            restart()
                        } label: {
                            Label(StitchText.startOver, systemImage: "arrow.counterclockwise")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
            .sheet(isPresented: $showInfo) {
                StitchInfoSheet()
            }
            .sheet(isPresented: $showLibrary) {
                StitchLibrarySheet(onLoad: { saved in
                    load(saved)
                    showLibrary = false
                })
            }
            .onAppear(perform: adoptSettingsOnce)
        }
    }

    // MARK: 顶部进度

    private var progressBar: some View {
        VStack(spacing: 6) {
            ProgressView(value: Double(step + 1), total: Double(totalSteps))
                .tint(StitchPalette.indigo)
            HStack {
                Text(StitchText.stepCounter(step + 1))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                Text(title)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(StitchPalette.indigo)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 8)
    }

    // MARK: 四步内容

    @ViewBuilder
    private var content: some View {
        switch step {
        case 0:
            StitchGaugeStep(gauge: $gauge, units: state.settings.units)
        case 1:
            StitchSizeStep(project: $project, gauge: gauge, units: state.settings.units)
        case 2:
            StitchYarnStep(weight: $weight, skein: $skein, safety: $safety,
                           gauge: gauge, plan: plan, units: state.settings.units)
        default:
            StitchResultView(plan: plan,
                             gauge: gauge,
                             project: $project,
                             weight: weight,
                             skein: skein,
                             safety: safety,
                             units: state.settings.units,
                             showGrams: state.settings.showGrams,
                             showDensityHint: state.settings.showDensityHint,
                             onRestart: restart)
        }
    }

    // MARK: 底部翻页

    private var footer: some View {
        HStack(spacing: 12) {
            if step > 0 {
                Button {
                    withAnimation(.easeInOut(duration: 0.18)) { step -= 1 }
                } label: {
                    Label(StitchText.back, systemImage: "chevron.left")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }

            Button {
                advance()
            } label: {
                Text(primaryTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(step == 0 && !gauge.isValid)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }

    private var primaryTitle: String {
        switch step {
        case 0, 1: return StitchText.next
        case 2: return StitchText.seeResult
        default: return StitchText.startOver
        }
    }

    // MARK: 动作

    private func advance() {
        if step >= totalSteps - 1 {
            restart()
        } else {
            withAnimation(.easeInOut(duration: 0.18)) { step += 1 }
        }
    }

    private func restart() {
        withAnimation(.easeInOut(duration: 0.2)) {
            step = 0
            gauge = StitchGauge()
            project = StitchProject()
            weight = state.settings.weight
            skein = state.settings.skein
            safety = state.settings.safety
        }
    }

    private func adoptSettingsOnce() {
        weight = state.settings.weight
        skein = state.settings.skein
        safety = state.settings.safety
    }

    private func load(_ saved: StitchSavedProject) {
        gauge = saved.gauge
        project = saved.project
        weight = saved.weight
        skein = saved.skein
        safety = saved.safety
        withAnimation(.easeInOut(duration: 0.2)) { step = 3 }
    }
}

/// 关于 + 设置。放在这个文件里，因为它只从这个壳打开。
struct StitchInfoSheet: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var state: StitchAppState

    var body: some View {
        NavigationStack {
            Form {
                Section(StitchText.informationSection) {
                    Text(StitchText.informationBody)
                        .font(.callout)
                }

                Section(StitchText.methodSection) {
                    Text(StitchText.methodBody)
                        .font(.callout)
                }

                Section(StitchText.settingsSection) {
                    Picker(StitchText.unitsLabel, selection: $state.settings.units) {
                        ForEach(StitchUnits.allCases) { unit in
                            Text(unit.title).tag(unit)
                        }
                    }
                    Toggle(StitchText.showGramsLabel, isOn: $state.settings.showGrams)
                    Toggle(StitchText.densityHintLabel, isOn: $state.settings.showDensityHint)
                }

                Section(StitchText.privacySection) {
                    Text(StitchText.privacyBody)
                        .font(.callout)
                }

                Section(StitchText.disclaimerSection) {
                    Text(StitchText.disclaimerBody)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Section {
                    HStack {
                        Text(StitchText.appName)
                        Spacer()
                        Text(StitchText.versionLine)
                            .foregroundStyle(.secondary)
                    }
                    .font(.footnote)
                }
            }
            .navigationTitle(StitchText.infoTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(StitchText.done) { dismiss() }
                }
            }
        }
    }
}

#Preview {
    StitchWizardView().environmentObject(StitchAppState())
}
