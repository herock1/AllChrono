import Foundation

extension AppEnvironment {
    static let preview = AppEnvironment(
        watchRepository: DefaultWatchRepository(
            dataSource: PreviewWatchDataSource()
        )
    )
}

private struct PreviewWatchDataSource: WatchDataSource {
    func fetchWatches() async throws -> [Watch] {
        [
            Watch(id: "1", make: "Vacheron Constantin", model: "Patrimony", price: 34_640, currency: "USD", imageURL: nil),
            Watch(id: "2", make: "Audemars Piguet", model: "Royal Oak 15500", price: 118_210, currency: "USD", imageURL: nil),
            Watch(id: "3", make: "Tudor", model: "Royal", price: 2_270, currency: "USD", imageURL: nil),
            Watch(id: "4", make: "Omega", model: "De Ville Prestige", price: 5_980, currency: "USD", imageURL: nil)
        ]
    }
}
