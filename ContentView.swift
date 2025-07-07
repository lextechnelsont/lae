import SwiftUI
import Foundation

struct AssetMetadata: Codable {
    let type: String
    let description: String
}

struct AssetResponse: Codable {
    let assetData: [String: String]
    let assetMetadata: [String: AssetMetadata]
}

struct AssetItem: Identifiable {
    let id: String
    let filename: String
    let metadata: AssetMetadata?

    var fileURL: URL? {
        Bundle.main.url(forResource: filename, withExtension: nil)
    }
}

class AssetsViewModel: ObservableObject {
    @Published var assetData: [String: String] = [:]
    @Published var assetMetadata: [String: AssetMetadata] = [:]
    @Published var assets: [AssetItem] = []

    func loadAssets() {
        guard let url = Bundle.main.url(forResource: "Assets", withExtension: "json") else {
            print("Assets.json not found")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(AssetResponse.self, from: data)
            assetData = response.assetData
            assetMetadata = response.assetMetadata
            assets = response.assetData.map { key, value in
                AssetItem(id: key, filename: value, metadata: response.assetMetadata[key])
            }
        } catch {
            print("Failed to decode asset data: \(error)")
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = AssetsViewModel()

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
            .onAppear {
                viewModel.loadAssets()
            }
        }
    }

    private func share(url: URL) {
#if canImport(UIKit)
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true)
#endif
    }
}

#Preview {
    ContentView()
}
