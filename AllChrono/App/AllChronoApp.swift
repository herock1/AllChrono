import SwiftUI

@main
struct AllChronoApp: App {
    private let environment = AppEnvironment.live

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(environment: environment)
        }
    }
}
