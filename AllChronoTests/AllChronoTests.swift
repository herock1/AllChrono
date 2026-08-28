import XCTest
@testable import AllChrono

@MainActor
final class AllChronoTests: XCTestCase {
    func testLoadPublishesRepositoryWatches() async {
        let watches = [Watch].fixture
        let viewModel = WatchCatalogViewModel(
            repository: StubWatchRepository(result: .success(watches))
        )

        await viewModel.loadIfNeeded()

        XCTAssertEqual(viewModel.state, WatchCatalogViewModel.ViewState.loaded)
        XCTAssertEqual(viewModel.watches, watches)
        XCTAssertEqual(viewModel.visibleWatches.count, watches.count)
    }

    func testSearchMatchesMakeAndModelCaseInsensitively() async {
        let viewModel = makeLoadedViewModel()
        await viewModel.loadIfNeeded()

        viewModel.searchText = "subMARINER"

        XCTAssertEqual(viewModel.visibleWatches.map(\.id), ["w-1"])
    }

    func testSearchUsesAllWatchesRegardlessOfSelectedBrand() async {
        let viewModel = makeLoadedViewModel()
        await viewModel.loadIfNeeded()

        viewModel.selectBrand("Omega")
        viewModel.searchText = "Submariner"

        XCTAssertEqual(viewModel.visibleWatches.map(\.id), ["w-1"])
    }

    func testSelectingBrandClearsSearchAndShowsOnlyThatBrand() async {
        let viewModel = makeLoadedViewModel()
        await viewModel.loadIfNeeded()
        viewModel.searchText = "Submariner"

        viewModel.selectBrand("Omega")

        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertEqual(viewModel.visibleWatches.map(\.id), ["w-2", "w-3"])
    }

    func testFailedLoadPublishesReadableError() async {
        let viewModel = WatchCatalogViewModel(
            repository: StubWatchRepository(result: .failure(TestError.unavailable))
        )

        await viewModel.loadIfNeeded()

        XCTAssertEqual(viewModel.state, .failed("Catalogue unavailable."))
        XCTAssertTrue(viewModel.watches.isEmpty)
    }

    func testToggleSavedAddsAndRemovesWatch() {
        let viewModel = makeLoadedViewModel()
        let watch = [Watch].fixture[0]

        viewModel.toggleSaved(watch)
        XCTAssertTrue(viewModel.savedWatchIDs.contains(watch.id))

        viewModel.toggleSaved(watch)
        XCTAssertFalse(viewModel.savedWatchIDs.contains(watch.id))
    }

    private func makeLoadedViewModel() -> WatchCatalogViewModel {
        WatchCatalogViewModel(
            repository: StubWatchRepository(result: .success(.fixture))
        )
    }
}

private struct StubWatchRepository: WatchRepository {
    let result: Result<[Watch], Error>

    func fetchWatches() async throws -> [Watch] {
        try result.get()
    }
}

private enum TestError: LocalizedError {
    case unavailable

    var errorDescription: String? { "Catalogue unavailable." }
}

private extension Array where Element == Watch {
    static let fixture = [
        Watch(
            id: "w-1",
            make: "Rolex",
            model: "Submariner Date",
            price: 14_500,
            currency: "USD",
            imageURL: nil
        ),
        Watch(
            id: "w-2",
            make: "Omega",
            model: "Speedmaster Moonwatch",
            price: 8_000,
            currency: "USD",
            imageURL: nil
        ),
        Watch(
            id: "w-3",
            make: "Omega",
            model: "Seamaster",
            price: 6_200,
            currency: "USD",
            imageURL: nil
        )
    ]
}
