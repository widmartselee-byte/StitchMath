import SwiftUI

/// 第一步：把样片上数到的针数/行数填进来。
struct StitchGaugeStep: View {
    @Binding var gauge: StitchGauge
    let units: StitchUnits

    var body: some View {
        VStack(spacing: 12) {
            StitchHint(text: StitchText.gaugeIntro)

            StitchCard(title: StitchText.swatchMeasuredOver) {
                Picker(StitchText.swatchMeasuredOver, selection: $gauge.measuredAcrossInches) {
                    Text(StitchText.swatchTenCm).tag(false)
                    Text(StitchText.swatchFourInches).tag(true)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
            }

            StitchCard(title: StitchText.densitySection) {
                StitchCountRow(title: StitchText.stitchesLabel,
                               value: $gauge.stitches,
                               range: 0...90)
                Divider()
                StitchCountRow(title: StitchText.rowsLabel,
                               value: $gauge.rows,
                               range: 0...140)
            }

            if gauge.isValid {
                StitchCard {
                    StitchDensityRow(title: StitchText.densityStitches,
                                     value: gauge.stitchesPer(units),
                                     units: units)
                    StitchDensityRow(title: StitchText.densityRows,
                                     value: gauge.rowsPer(units),
                                     units: units)
                    StitchHint(text: "1 stitch ≈ \(StitchFormat.number(gauge.stitchWidth * 10, decimals: 1)) mm wide, 1 row ≈ \(StitchFormat.number(gauge.rowHeight * 10, decimals: 1)) mm high")
                }
            } else {
                StitchCard {
                    Text(StitchText.densityWarning)
                        .font(.callout)
                        .foregroundStyle(StitchPalette.warning)
                }
            }

            StitchCard(title: StitchText.gaugeTipTitle) {
                StitchHint(text: StitchText.gaugeTip)
            }
        }
    }
}
