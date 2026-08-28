struct DefaultWatchRepository: WatchRepository {
    private let dataSource: WatchDataSource

    init(dataSource: WatchDataSource) {
        self.dataSource = dataSource
    }

    func fetchWatches() async throws -> [Watch] {
        try await dataSource.fetchWatches()
    }
}
