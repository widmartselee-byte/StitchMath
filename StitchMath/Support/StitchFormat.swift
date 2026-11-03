import Foundation

/// 数字格式化。全部显式指定格式，避免跟着系统语言飘。
enum StitchFormat {

    /// 50.0 -> "50"，50.4 -> "50.4"
    static func number(_ value: Double, decimals: Int = 1) -> String {
        guard decimals > 0 else { return String(format: "%.0f", value) }
        let scale = pow(10.0, Double(decimals))
        let rounded = (value * scale).rounded() / scale
        if abs(rounded - rounded.rounded()) < 0.05 {
            return String(format: "%.0f", rounded)
        }
        return String(format: "%.\(decimals)f", rounded)
    }

    /// 带千分位，用于针数、米数这类可能上千的数
    static func grouped(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value.rounded())) ?? "0"
    }

    /// 994 -> "994 m"，1240 -> "1.24 km"
    static func metres(_ value: Double) -> String {
        if value >= 1000 {
            return String(format: "%.2f km", value / 1000)
        }
        return "\(grouped(value)) m"
    }

    /// 克数
    static func grams(_ value: Double) -> String {
        "\(grouped(value)) g"
    }

    /// 密度：22.0 -> "22"，21.4 -> "21.4"
    static func density(_ value: Double) -> String {
        number(value, decimals: 1)
    }

    /// 长度按当前单位显示
    static func length(_ centimetres: Double, in units: StitchUnits) -> String {
        number(units.fromCm(centimetres), decimals: 1) + " " + units.title
    }

    /// 短日期
    static func dateShort(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
