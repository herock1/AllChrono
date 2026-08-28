import Foundation

struct LocalJSONWatchDataSource: WatchDataSource {
    let resourceName: String
    let bundle: Bundle
    private let decoder = JSONDecoder()

    func fetchWatches() async throws -> [Watch] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw LocalDataError.resourceNotFound(resourceName)
        }

        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode([Watch].self, from: data)
        } catch let error as LocalDataError {
            throw error
        } catch {
            throw LocalDataError.unreadableData(error)
        }
    }
}

enum LocalDataError: LocalizedError {
    case resourceNotFound(String)
    case unreadableData(Error)

    var errorDescription: String? {
        switch self {
        case let .resourceNotFound(name):
            return "The bundled resource \(name).json was not found."
        case .unreadableData:
            return "The bundled watch data could not be read."
        }
    }
}
