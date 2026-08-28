protocol WatchDataSource {
    func fetchWatches() async throws -> [Watch]
}
