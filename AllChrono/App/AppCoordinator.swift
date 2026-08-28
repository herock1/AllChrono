import SwiftUI
import Combine

@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []

    func showDetails(for watch: Watch) {
        path.append(.watchDetails(watch))
    }

    func popToCatalog() {
        path.removeAll()
    }
}

enum AppRoute: Hashable {
    case watchDetails(Watch)
}

struct AppCoordinatorView: View {
    let environment: AppEnvironment
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            WatchCatalogView(
                viewModel: WatchCatalogViewModel(
                    repository: environment.watchRepository
                ),
                onSelectWatch: coordinator.showDetails
            )
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case let .watchDetails(watch):
                    WatchDetailView(watch: watch)
                }
            }
        }
        .environmentObject(coordinator)
    }
}
