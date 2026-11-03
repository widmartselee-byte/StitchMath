import SwiftUI

/// 带加减的整数行（针数、行数、花样重复都复用它）
struct StitchCountRow: View {
    let title: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    var unit: String = ""

    var body: some View {
        Stepper(value: $value, in: range) {
            HStack {
                Text(title)
                Spacer()
                Text(unit.isEmpty ? "\(value)" : "\(value) \(unit)")
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
    }
}

/// 尺寸行：内部一律存厘米，滑杆跟着当前单位走
struct StitchMeasurementRow: View {
    let title: String
    @Binding var centimetres: Double
    let range: ClosedRange<Double>       // 厘米范围
    let units: StitchUnits

    private var sliderValue: Binding<Double> {
        Binding(
            get: { units.fromCm(centimetres) },
            set: { centimetres = units.toCm($0) }
        )
    }

    private var displayRange: ClosedRange<Double> {
        units.fromCm(range.lowerBound)...units.fromCm(range.upperBound)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(title)
                Spacer()
                Text(StitchFormat.length(centimetres, in: units))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
            Slider(value: sliderValue, in: displayRange, step: units == .cm ? 1 : 0.5)
        }
    }
}

/// 密度行：显示「每 10 cm 多少针」，跟着单位换
struct StitchDensityRow: View {
    let title: String
    let value: Double
    let units: StitchUnits

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(StitchFormat.density(value) + " / \(StitchFormat.number(10 * units.centimetres, decimals: 0)) cm")
                .monospacedDigit()
                .foregroundStyle(StitchPalette.indigo)
        }
    }
}

/// 结果页与步骤页里的小方块
struct StitchStatTile: View {
    let title: String
    let value: String
    var footnote: String = ""
    var emphasised: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(emphasised ? .system(size: 28, weight: .semibold, design: .rounded)
                                 : .title3.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(emphasised ? StitchPalette.indigo : Color.primary)
            if !footnote.isEmpty {
                Text(footnote)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 14).fill(StitchPalette.panel))
    }
}

/// 说明性文字块，避免每处都写一遍修饰符
struct StitchHint: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }
}

/// 步骤页里统一的分组卡片
struct StitchCard<Content: View>: View {
    var title: String
    let content: Content

    init(title: String = "", @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !title.isEmpty {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            content
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 16).fill(StitchPalette.panel))
    }
}
