import Foundation

struct RemoteWatchDataSource: WatchDataSource {
    let client: APIClient
    let endpoint: URL

    func fetchWatches() async throws -> [Watch] {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return try await client.request(request, as: [Watch].self)
    }
}
