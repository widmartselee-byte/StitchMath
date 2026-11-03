import Foundation

/// 偏好设置。密度样片本身不属于设置，它跟着作品走。
struct StitchSettings: Codable, Equatable {
    var units: StitchUnits = .cm
    var weight: StitchWeight = .worsted
    var skein: StitchSkein = .init()
    var safety: StitchSafety = .ten
    /// 结果页是否把克数也显示出来
    var showGrams: Bool = true
    /// 结果页是否把「每 10 cm 针数」再提示一遍
    var showDensityHint: Bool = true

    /// 换线重时把卷长/克重也换成那类线的常见值
    mutating func adoptDefaults(of weight: StitchWeight) {
        self.weight = weight
        skein = weight.defaultSkein()
    }

    /// 把厘米换成当前单位后的数值
    func display(_ cm: Double) -> Double {
        units.fromCm(cm)
    }

    /// 当前单位下的数值 -> 厘米
    func centimetres(_ value: Double) -> Double {
        units.toCm(value)
    }
}
