import Foundation

struct AssetMetadata: Codable {
    let type: String
    let description: String
}

struct AssetResponse: Codable {
    let assetData: [String: String]
    let assetMetadata: [String: AssetMetadata]
}

func loadAssets(named fileName: String) throws -> AssetResponse {
    let url = URL(fileURLWithPath: fileName)
    let data = try Data(contentsOf: url)
    return try JSONDecoder().decode(AssetResponse.self, from: data)
}

let file = CommandLine.arguments.dropFirst().first ?? "Assets.json"
if let response = try? loadAssets(named: file) {
    print("Loaded assetData keys: \(response.assetData.keys.joined(separator: ", "))")
    print("Loaded assetMetadata keys: \(response.assetMetadata.keys.joined(separator: ", "))")
} else {
    print("Failed to load file")
}
