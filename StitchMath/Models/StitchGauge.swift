import Foundation

/// 长度单位。密度、尺寸的换算都走这里，避免视图里出现裸数字。
enum StitchUnits: String, Codable, CaseIterable, Identifiable {
    case cm
    case inch

    var id: String { rawValue }

    var title: String {
        switch self {
        case .cm: return "cm"
        case .inch: return "in"
        }
    }

    /// 1 单位等于多少厘米
    var centimetres: Double {
        switch self {
        case .cm: return 1
        case .inch: return 2.54
        }
    }

    /// 厘米 -> 当前单位
    func fromCm(_ value: Double) -> Double {
        centimetres > 0 ? value / centimetres : value
    }

    /// 当前单位 -> 厘米
    func toCm(_ value: Double) -> Double {
        value * centimetres
    }

    /// 当前单位下「一格」对应的厘米宽度（用于显示 10 cm / 4 in 这类刻度）
    var swatchStep: Double { 10 * centimetres }
}

/// 密度样片：在某段宽度里数到的针数与行数。
/// 所有换算都先归一到「每厘米」，显示时再按单位换回去。
struct StitchGauge: Equatable, Codable {
    /// 量的是 4 英寸样片（10.16 cm）还是 10 cm 样片
    var measuredAcrossInches: Bool = false
    var stitches: Int = 22
    var rows: Int = 30

    /// 样片宽度（厘米）
    var swatchCm: Double { measuredAcrossInches ? 10.16 : 10 }

    var stitchesPerCm: Double { swatchCm > 0 ? Double(stitches) / swatchCm : 0 }
    var rowsPerCm: Double { swatchCm > 0 ? Double(rows) / swatchCm : 0 }

    /// 每 10 cm 的针数 / 行数（大多数图解用这个说法）
    var stitchesPerTen: Double { stitchesPerCm * 10 }
    var rowsPerTen: Double { rowsPerCm * 10 }

    /// 一针的宽度（厘米）
    var stitchWidth: Double { stitchesPerCm > 0 ? 1 / stitchesPerCm : 0 }
    /// 一行的行高（厘米）
    var rowHeight: Double { rowsPerCm > 0 ? 1 / rowsPerCm : 0 }

    /// 按指定单位表达的密度
    func stitchesPer(_ unit: StitchUnits) -> Double { stitchesPerCm * unit.centimetres }
    func rowsPer(_ unit: StitchUnits) -> Double { rowsPerCm * unit.centimetres }

    /// 是否是有效密度（数到 0 针时不做计算）
    var isValid: Bool { stitches > 0 && rows > 0 }
}
