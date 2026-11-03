import Foundation

/// 存下来的一个作品。所有输入都留着，方便下次直接改尺寸重算。
struct StitchSavedProject: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var createdAt: Date = Date()

    var weight: StitchWeight
    var gauge: StitchGauge
    var project: StitchProject
    var skein: StitchSkein
    var safety: StitchSafety

    var castOn: Int
    var rows: Int
    var metres: Double
    var skeins: Int

    /// 列表里的一行小字
    var summary: String {
        "\(castOn) sts · \(rows) rows · \(StitchFormat.metres(metres)) · \(skeins) skein\(skeins == 1 ? "" : "s")"
    }

    /// 尺寸那行
    var sizeLine: String {
        "\(StitchFormat.number(project.widthCm)) × \(StitchFormat.number(project.heightCm)) cm · \(weight.title)"
    }

    static func make(name: String,
                     weight: StitchWeight,
                     gauge: StitchGauge,
                     project: StitchProject,
                     skein: StitchSkein,
                     safety: StitchSafety,
                     plan: StitchPlan) -> StitchSavedProject {
        StitchSavedProject(name: name,
                           weight: weight,
                           gauge: gauge,
                           project: project,
                           skein: skein,
                           safety: safety,
                           castOn: plan.castOn,
                           rows: plan.rows,
                           metres: plan.metres,
                           skeins: plan.skeins)
    }
}
