import Foundation

/// 线的粗细分级。只用来给默认卷长/克重，用户随时可以改。
enum StitchWeight: String, Codable, CaseIterable, Identifiable {
    case lace
    case fingering
    case sport
    case dk
    case worsted
    case aran
    case bulky

    var id: String { rawValue }

    var title: String {
        switch self {
        case .lace: return "Lace"
        case .fingering: return "Fingering"
        case .sport: return "Sport"
        case .dk: return "DK"
        case .worsted: return "Worsted"
        case .aran: return "Aran"
        case .bulky: return "Bulky"
        }
    }

    /// 这类线编贴身平针时常见的针密（每 10 cm 针数），只用于提示
    var commonStitchesPerTen: Int {
        switch self {
        case .lace: return 33
        case .fingering: return 28
        case .sport: return 24
        case .dk: return 22
        case .worsted: return 20
        case .aran: return 18
        case .bulky: return 14
        }
    }

    /// 默认一卷多少米
    var defaultSkeinLength: Double {
        switch self {
        case .lace: return 400
        case .fingering: return 400
        case .sport: return 300
        case .dk: return 200
        case .worsted: return 200
        case .aran: return 160
        case .bulky: return 110
        }
    }

    /// 默认一卷多少克
    var defaultSkeinGrams: Double {
        switch self {
        case .lace: return 50
        case .fingering: return 100
        case .sport: return 100
        case .dk: return 100
        case .worsted: return 100
        case .aran: return 100
        case .bulky: return 100
        }
    }

    func defaultSkein() -> StitchSkein {
        StitchSkein(lengthM: defaultSkeinLength, grams: defaultSkeinGrams)
    }
}

/// 一卷线的参数
struct StitchSkein: Equatable, Codable {
    var lengthM: Double = 200
    var grams: Double = 100

    var isValid: Bool { lengthM > 0 && grams > 0 }
}

/// 多买多少，防止收尾不够
enum StitchSafety: Int, Codable, CaseIterable, Identifiable {
    case none = 0
    case ten = 10
    case twenty = 20

    var id: Int { rawValue }

    var title: String { "\(rawValue)%" }

    var factor: Double { 1 + Double(rawValue) / 100 }
}

/// 计算结果：起针、行数、用线量、要买几卷
struct StitchPlan: Equatable {
    var castOn: Int
    var rows: Int
    var metres: Double
    var skeins: Int
    var grams: Double
    /// 因为凑花样多出来的针数（0 表示没有凑）
    var extraStitches: Int

    var totalStitches: Int { castOn * rows }

    /// 经验系数：一针大约消耗 0.072 ×（针宽 + 行高）厘米的线。
    /// 这个系数是拿平针成品反推的，罗纹、麻花会更费线，所以界面上建议留 10% 余量。
    static let yarnFactor = 0.072

    static func make(gauge: StitchGauge,
                     project: StitchProject,
                     skein: StitchSkein,
                     safety: StitchSafety) -> StitchPlan {
        let castOn = project.castOn(for: gauge)
        let rows = project.rowCount(for: gauge)
        let extra = max(0, castOn - project.rawCastOn(for: gauge))

        let stitchWidth = gauge.stitchWidth > 0 ? gauge.stitchWidth : 0.5
        let rowHeight = gauge.rowHeight > 0 ? gauge.rowHeight : 0.4
        let raw = Double(castOn * rows) * yarnFactor * (stitchWidth + rowHeight)
        let metres = raw * safety.factor

        let length = skein.lengthM > 0 ? skein.lengthM : 1
        let skeins = Int((metres / length).rounded(.up))
        let grams = skein.lengthM > 0 ? metres / skein.lengthM * skein.grams : 0

        return StitchPlan(castOn: castOn,
                          rows: rows,
                          metres: metres,
                          skeins: max(skeins, 0),
                          grams: max(grams, 0),
                          extraStitches: extra)
    }
}
