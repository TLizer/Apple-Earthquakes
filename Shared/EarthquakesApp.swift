/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app and main window group scene.
*/

import SwiftUI

@main
struct EarthquakesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                viewModel: ContentViewModel(
                    quakesProvider: QuakesProvider.shared,
                    dataSource: QuakesFRCDataSource(
                        context: QuakesProvider.shared.container.viewContext
                    )
                )
            )
        }
    }
}
