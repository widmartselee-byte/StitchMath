import Foundation
import Combine

/// 作品库。写进 App 沙盒里的一个 JSON 文件，不上传、不同步。
final class StitchLibrary: ObservableObject {
    @Published private(set) var items: [StitchSavedProject] = []

    private struct Archive: Codable {
        var items: [StitchSavedProject]
    }

    private var fileURL: URL {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directory.appendingPathComponent("stitchmath.json")
    }

    init() {
        load()
    }

    // MARK: 增删

    func add(_ project: StitchSavedProject) {
        items.insert(project, at: 0)
        persist()
    }

    func remove(_ project: StitchSavedProject) {
        items.removeAll { $0.id == project.id }
        persist()
    }

    /// 列表滑动删除。按下标倒着删，避免下标错位。
    func removeItems(at offsets: IndexSet) {
        for index in offsets.sorted(by: >) where items.indices.contains(index) {
            items.remove(at: index)
        }
        persist()
    }

    func rename(_ project: StitchSavedProject, to newName: String) {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let index = items.firstIndex(where: { $0.id == project.id }) else {
            return
        }
        items[index].name = trimmed
        persist()
    }

    // MARK: 读写

    private func persist() {
        let archive = Archive(items: items)
        guard let data = try? JSONEncoder().encode(archive) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let archive = try? JSONDecoder().decode(Archive.self, from: data) else {
            return
        }
        items = archive.items
    }
}
