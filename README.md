# lae

This SwiftUI sample demonstrates how to decode a JSON file from the app bundle into two dictionaries, `assetData` and `assetMetadata`, and display the listed assets with export functionality.

Run the app to see a list of bundled PDFs or USDZ files. Each item includes an **Export** button that shares the selected file through the system share sheet or, on iOS 16 and later, via `ShareLink`.

Asset definitions are loaded from a JSON file in the bundle. By default the app looks for `Assets.json`, but you can pass another file name to `loadAssets(named:)` if desired. A sample file as well as `Cruise balcony design 3.lexagonscene.json` are included for testing.
