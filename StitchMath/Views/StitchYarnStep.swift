import SwiftUI

/// 第三步：线的粗细 + 一卷多长，顺手给出用线量和要买几卷。
struct StitchYarnStep: View {
    @Binding var weight: StitchWeight
    @Binding var skein: StitchSkein
    @Binding var safety: StitchSafety
    let gauge: StitchGauge
    let plan: StitchPlan
    let units: StitchUnits

    var body: some View {
        VStack(spacing: 12) {
            StitchHint(text: StitchText.yarnIntro)

            StitchCard(title: StitchText.weightLabel) {
                Picker(StitchText.weightLabel, selection: $weight) {
                    ForEach(StitchWeight.allCases) { item in
                        Text(item.title).tag(item)
                    }
                }
                .pickerStyle(.menu)
                .labelsHidden()

                HStack {
                    Text(StitchText.typicalDensity)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(weight.commonStitchesPerTen) / 10 cm")
                        .font(.caption)
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
            }

            StitchCard(title: StitchText.skeinSection) {
                Stepper(value: $skein.lengthM, in: 25...1200, step: 5) {
                    HStack {
                        Text(StitchText.skeinLength)
                        Spacer()
                        Text(StitchFormat.metres(skein.lengthM))
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }
                Divider()
                Stepper(value: $skein.grams, in: 10...500, step: 5) {
                    HStack {
                        Text(StitchText.skeinGrams)
                        Spacer()
                        Text(StitchFormat.grams(skein.grams))
                            .monospacedDigit()
                            .foregroundStyle(.secondary)
                    }
                }
            }

            StitchCard(title: StitchText.safetySection) {
                Picker(StitchText.safetySection, selection: $safety) {
                    ForEach(StitchSafety.allCases) { item in
                        Text(item.title).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                StitchHint(text: StitchText.safetyNote)
            }

            StitchStatTile(title: StitchText.estimatedYarn,
                           value: StitchFormat.metres(plan.metres),
                           footnote: "\(StitchText.buyLabel) \(plan.skeins) \(StitchText.skeinsUnit)",
                           emphasised: true)

            if !skein.isValid {
                StitchCard {
                    Text("Skein length and weight must both be above zero.")
                        .font(.callout)
                        .foregroundStyle(StitchPalette.warning)
                }
            }
        }
        .onChange(of: weight) { _, newValue in
            skein = newValue.defaultSkein()
        }
    }
}
