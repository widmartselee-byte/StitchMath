import SwiftUI

/// 第二步：成品尺寸 + 花样重复，顺手把起针数算出来给用户看。
struct StitchSizeStep: View {
    @Binding var project: StitchProject
    let gauge: StitchGauge
    let units: StitchUnits

    private var straight: Int { project.rawCastOn(for: gauge) }
    private var aligned: Int { project.castOn(for: gauge) }
    private var added: Int { aligned - straight }

    var body: some View {
        VStack(spacing: 12) {
            StitchHint(text: StitchText.sizeIntro)

            StitchCard {
                StitchMeasurementRow(title: StitchText.widthLabel,
                                     centimetres: $project.widthCm,
                                     range: 5...250,
                                     units: units)
                Divider()
                StitchMeasurementRow(title: StitchText.heightLabel,
                                     centimetres: $project.heightCm,
                                     range: 5...250,
                                     units: units)
            }

            StitchCard(title: StitchText.patternSection) {
                StitchCountRow(title: StitchText.repeatStitchesLabel,
                               value: $project.repeatStitches,
                               range: 1...40)
                if project.hasPatternRepeat {
                    Divider()
                    StitchCountRow(title: StitchText.repeatOffsetLabel,
                                   value: $project.repeatOffset,
                                   range: 0...max(0, project.repeatStitches - 1))
                }
                StitchHint(text: StitchText.repeatExplain)
            }

            StitchCard(title: StitchText.castOnLabel) {
                HStack {
                    Text(StitchText.straightCastOn)
                        .font(.subheadline)
                    Spacer()
                    Text("\(straight)")
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                HStack {
                    Text(StitchText.alignedCastOn)
                        .font(.subheadline.weight(.medium))
                    Spacer()
                    Text("\(aligned)")
                        .font(.title3.weight(.semibold))
                        .monospacedDigit()
                        .foregroundStyle(StitchPalette.indigo)
                }
                if added > 0 {
                    StitchHint(text: "+\(added) \(StitchText.addedStitches)")
                }
            }
        }
        .onChange(of: project.repeatStitches) { _, newValue in
            if project.repeatOffset >= newValue {
                project.repeatOffset = 0
            }
        }
    }
}
