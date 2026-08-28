import Foundation
import Combine

@MainActor
final class WatchCatalogViewModel: ObservableObject {
    enum ViewState: Equatable {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var state: ViewState = .idle
    @Published private(set) var watches: [Watch] = []
    @Published var searchText = ""
    @Published var selectedBrand: String?
    @Published var savedWatchIDs: Set<Watch.ID> = []

    private let repository: WatchRepository

    init(repository: WatchRepository) {
        self.repository = repository
    }

    var brands: [String] {
        Array(Set(watches.map(\.make))).sorted()
    }

    var visibleWatches: [Watch] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        if !query.isEmpty {
            return watches.filter { watch in
                watch.make.localizedCaseInsensitiveContains(query)
                    || watch.model.localizedCaseInsensitiveContains(query)
            }
        }

        guard let selectedBrand else { return watches }
        return watches.filter { $0.make == selectedBrand }
    }

    func loadIfNeeded() async {
        guard state == .idle else { return }
        await load()
    }

    func retry() async {
        await load()
    }

    func selectBrand(_ brand: String?) {
        searchText = ""
        selectedBrand = brand
    }

    func toggleSaved(_ watch: Watch) {
        if savedWatchIDs.contains(watch.id) {
            savedWatchIDs.remove(watch.id)
        } else {
            savedWatchIDs.insert(watch.id)
        }
    }

    private func load() async {
        state = .loading
        do {
            watches = try await repository.fetchWatches()
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
