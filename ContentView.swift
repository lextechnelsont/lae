import SwiftUI
import Foundation
import UniformTypeIdentifiers

struct ItemType: Codable {
    let identifier: String
    let constantIndex: Int
}

struct AssetMetadata: Codable {
    let uuid: String
    let dataSizeBytes: Int
    let itemType: ItemType
}

enum MetadataElement: Codable {
    case uuid(String)
    case metadata(AssetMetadata)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let str = try? container.decode(String.self) {
            self = .uuid(str)
        } else {
            self = .metadata(try container.decode(AssetMetadata.self))
        }
    }
}

struct SceneFile: Codable {
    let assetData: [String]
    let assetMetadata: [MetadataElement]
}

struct AssetItem: Identifiable {
    let id: String
    let filename: String
    let metadata: AssetMetadata
    let fileURL: URL?
}

class AssetsViewModel: ObservableObject {
    @Published var assets: [AssetItem] = []

    /// Load a scene from a JSON file packaged with the app bundle (defaults to
    /// `Test.json`).
    /*
    func loadScene() {
        guard let url = Bundle.main.url(forResource: "Test", withExtension: "json") else {
            print("Test.json not found")
            return
        }

        loadScene(from: url)
    }*/

    /// Import a scene description from an arbitrary JSON file on disk.
    /// - Parameter url: The location of the JSON file to parse.
    func loadScene(from url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let scene = try JSONDecoder().decode(SceneFile.self, from: data)

            var dataDict: [String: String] = [:]
            for i in stride(from: 0, to: scene.assetData.count, by: 2) {
                guard i + 1 < scene.assetData.count else { continue }
                let id = scene.assetData[i]
                let encoded = scene.assetData[i + 1]
                dataDict[id] = encoded
            }

            var metaDict: [String: AssetMetadata] = [:]
            var index = 0
            while index < scene.assetMetadata.count - 1 {
                if case let .uuid(id) = scene.assetMetadata[index],
                   case let .metadata(meta) = scene.assetMetadata[index + 1] {
                    metaDict[id] = meta
                }
                index += 2
            }

            var items: [AssetItem] = []
            for (id, encoded) in dataDict {
                guard let data = Data(base64Encoded: encoded),
                      let meta = metaDict[id] else { continue }
                let ext = UTType(meta.itemType.identifier)?.preferredFilenameExtension ?? "dat"
                let filename = "\(id).\(ext)"
                let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                do {
                    try data.write(to: fileURL, options: .atomic)
                    items.append(AssetItem(id: id, filename: filename, metadata: meta, fileURL: fileURL))
                } catch {
                    print("Failed to write file for id \(id): \(error)")
                }
            }

            DispatchQueue.main.async {
                self.assets = items
            }
        } catch {
            print("Failed to decode asset data: \(error)")
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = AssetsViewModel()
    @State private var isImporting = false

    var body: some View {
        NavigationView {
            List(viewModel.assets) { asset in
                HStack {
                    Text(asset.filename)
                    Spacer()
                    if let fileURL = asset.fileURL {
                        if #available(iOS 16.0, *) {
                            ShareLink(item: fileURL) {
                                Text("Export")
                            }
                        } else {
                            Button("Export") {
                                share(url: fileURL)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Assets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Import") { isImporting = true }
                }
            }
            .fileImporter(isPresented: $isImporting, allowedContentTypes: [.json]) { result in
                print("readytoHandleImport")
                handleImport(result)
            }
        }
    }

    private func share(url: URL) {
#if canImport(UIKit)
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
#endif
    }

    private func handleImport(_ result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            print("loadstarted")
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                viewModel.loadScene(from: url)
                print("loaddone")
            } else {
                print("Failed to access security scoped resource")
            }
        case .failure(let error):
            print("Failed to import file: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
