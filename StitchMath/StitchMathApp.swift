import SwiftUI

/// 全局状态：作品库和偏好设置都在本机
final class StitchAppState: ObservableObject {
    @Published var library = StitchLibrary()
    @Published var settings = StitchSettings()
}

@main
struct StitchMathApp: App {
    @StateObject private var state = StitchAppState()

    var body: some Scene {
        WindowGroup {
            StitchWizardView()
                .environmentObject(state)
                .tint(StitchPalette.indigo)
        }
    }
}

/// 靛蓝 + 亚麻（和另外几个 App 的配色都不一样）
enum StitchPalette {
    static let indigo = Color(red: 0.24, green: 0.28, blue: 0.45)
    static let linen = Color(red: 0.95, green: 0.93, blue: 0.88)
    static let thread = Color(red: 0.72, green: 0.58, blue: 0.42)
    static let panel = Color(.secondarySystemBackground)
    static let warning = Color(red: 0.55, green: 0.30, blue: 0.20)
}
