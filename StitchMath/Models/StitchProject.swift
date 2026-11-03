import Foundation

/// 作品尺寸 + 花样重复。
/// 起针数不是「想要的宽度 × 密度」就完事的：花样一重复 8 针、两边各留 2 边针，
/// 起针数就必须是 8 的倍数加 2。
struct StitchProject: Equatable, Codable {
    var name: String = ""
    /// 成品宽度（厘米）
    var widthCm: Double = 50
    /// 成品高度（厘米）
    var heightCm: Double = 60
    /// 花样一重复几针；1 表示没有花样限制
    var repeatStitches: Int = 1
    /// 边针（余数）。8 针一重复 + 2 边针 → repeatStitches 8, repeatOffset 2
    var repeatOffset: Int = 0

    var hasPatternRepeat: Bool { repeatStitches > 1 }

    /// 纯粹按密度算出来的起针数（未凑花样）
    func rawCastOn(for gauge: StitchGauge) -> Int {
        let value = widthCm * gauge.stitchesPerCm
        return max(1, Int(value.rounded()))
    }

    /// 凑到花样允许的起针数
    func castOn(for gauge: StitchGauge) -> Int {
        StitchProject.aligned(rawCastOn(for: gauge),
                              repeatStitches: repeatStitches,
                              offset: repeatOffset)
    }

    /// 行数（按高度 × 行密度）
    func rowCount(for gauge: StitchGauge) -> Int {
        let value = heightCm * gauge.rowsPerCm
        return max(1, Int(value.rounded()))
    }

    /// 把针数往上凑到最近的合法值：n ≡ offset (mod repeatStitches)
    static func aligned(_ base: Int, repeatStitches: Int, offset: Int) -> Int {
        let start = max(base, 1)
        guard repeatStitches > 1 else { return start }
        let off = min(max(offset, 0), repeatStitches - 1)
        var n = max(start, repeatStitches)
        var guardCount = 0
        while ((n - off) % repeatStitches + repeatStitches) % repeatStitches != 0,
              guardCount < 2000 {
            n += 1
            guardCount += 1
        }
        return n
    }

    /// 因为凑花样多出来多少针
    func extraStitches(for gauge: StitchGauge) -> Int {
        castOn(for: gauge) - rawCastOn(for: gauge)
    }
}
