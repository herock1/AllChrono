import Foundation

struct AppEnvironment {
    let watchRepository: WatchRepository

    static let live = AppEnvironment(
        watchRepository: DefaultWatchRepository(
            dataSource: LocalJSONWatchDataSource(
                resourceName: "watches",
                bundle: .main
            )
        )
    )

    // Future API setup:
    // DefaultWatchRepository(
    //     dataSource: RemoteWatchDataSource(
    //         client: URLSessionAPIClient(),
    //         endpoint: URL(string: "https://api.example.com/watches")!
    //     )
    // )
}
