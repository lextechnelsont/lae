# lae

This SwiftUI sample demonstrates how to decode a JSON file from the app bundle into two dictionaries, `assetData` and `assetMetadata`, and display the listed assets with export functionality.

Run the app to see a list of bundled PDFs or USDZ files. Each item includes an **Export** button that shares the selected file through the system share sheet or, on iOS 16 and later, via `ShareLink`.

The JSON file should be named `Scene.json` and located in the app bundle. A sample file is provided in this repository.
