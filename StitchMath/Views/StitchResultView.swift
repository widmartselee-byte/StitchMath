import SwiftUI

/// 第四步：把所有结果摊开，并且可以存进作品库。
struct StitchResultView: View {
    let plan: StitchPlan
    let gauge: StitchGauge
    @Binding var project: StitchProject
    let weight: StitchWeight
    let skein: StitchSkein
    let safety: StitchSafety
    let units: StitchUnits
    let showGrams: Bool
    let showDensityHint: Bool
    let onRestart: () -> Void

    @EnvironmentObject private var state: StitchAppState

    @State private var showNaming = false
    @State private var draftName = ""
    @State private var justSaved = false

    var body: some View {
        VStack(spacing: 12) {
            StitchStatTile(title: StitchText.castOnLabel,
                           value: "\(plan.castOn)",
                           footnote: StitchText.stitchesUnit,
                           emphasised: true)

            HStack(spacing: 12) {
                StitchStatTile(title: StitchText.rowsLabelResult,
                               value: "\(plan.rows)",
                               footnote: StitchText.rowsUnit)
                StitchStatTile(title: StitchText.yarnNeededLabel,
                               value: StitchFormat.metres(plan.metres))
            }

            HStack(spacing: 12) {
                StitchStatTile(title: StitchText.buyLabel,
                               value: "\(plan.skeins)",
                               footnote: StitchText.skeinsUnit)
                StitchStatTile(title: StitchText.totalWeight,
                               value: showGrams ? StitchFormat.grams(plan.grams) : "—",
                               footnote: weight.title)
            }

            if plan.extraStitches > 0 {
                StitchCard {
                    StitchHint(text: "Cast-on includes +\(plan.extraStitches) \(StitchText.stitchesUnit) so the pattern repeat lands evenly.")
                }
            }

            if showDensityHint {
                StitchCard(title: StitchText.densitySection) {
                    StitchHint(text: "\(StitchFormat.density(gauge.stitchesPer(units))) \(StitchText.densityStitches) · \(StitchFormat.density(gauge.rowsPer(units))) \(StitchText.densityRows)")
                }
            }

            StitchCard(title: StitchText.saveSection) {
                Button {
                    draftName = project.name.isEmpty ? defaultName() : project.name
                    showNaming = true
                } label: {
                    Label(StitchText.save, systemImage: "tray.and.arrow.down")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                if justSaved {
                    Text("Saved.")
                        .font(.caption)
                        .foregroundStyle(StitchPalette.indigo)
                }

                StitchHint(text: StitchText.saveExplain)
            }

            Button {
                onRestart()
            } label: {
                Text(StitchText.startOver)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .alert(StitchText.saveSection, isPresented: $showNaming) {
            TextField(StitchText.namePlaceholder, text: $draftName)
            Button(StitchText.save) { save() }
            Button(StitchText.cancel, role: .cancel) { }
        }
    }

    private func defaultName() -> String {
        "\(StitchFormat.number(units.fromCm(project.widthCm), decimals: 0))×\(StitchFormat.number(units.fromCm(project.heightCm), decimals: 0)) \(units.title) \(weight.title)"
    }

    private func save() {
        let trimmed = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = trimmed.isEmpty ? defaultName() : trimmed
        project.name = name
        let saved = StitchSavedProject.make(name: name,
                                            weight: weight,
                                            gauge: gauge,
                                            project: project,
                                            skein: skein,
                                            safety: safety,
                                            plan: plan)
        state.library.add(saved)
        justSaved = true
    }
}

/// 作品库：点一行就把它载回向导。
struct StitchLibrarySheet: View {
    @EnvironmentObject private var state: StitchAppState
    @Environment(\.dismiss) private var dismiss
    let onLoad: (StitchSavedProject) -> Void

    var body: some View {
        NavigationStack {
            List {
                if state.library.items.isEmpty {
                    Text(StitchText.libraryEmpty)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(state.library.items) { item in
                        Button {
                            onLoad(item)
                        } label: {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.name)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(StitchPalette.indigo)
                                Text(item.sizeLine)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                Text(item.summary)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                                    .monospacedDigit()
                                Text(StitchFormat.dateShort(item.createdAt))
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .onDelete { offsets in
                        state.library.removeItems(at: offsets)
                    }
                }
            }
            .navigationTitle(StitchText.libraryTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(StitchText.done) { dismiss() }
                }
            }
            .safeAreaInset(edge: .bottom) {
                if !state.library.items.isEmpty {
                    Text(StitchText.librarySwipeHint)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .padding(.vertical, 6)
                }
            }
        }
    }
}
