import Foundation

protocol APIClient {
    func request<Response: Decodable>(
        _ request: URLRequest,
        as type: Response.Type
    ) async throws -> Response
}

struct URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
    }

    func request<Response: Decodable>(
        _ request: URLRequest,
        as type: Response.Type
    ) async throws -> Response {
        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw APIError.invalidResponse
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
}

enum APIError: LocalizedError {
    case invalidResponse
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server returned an invalid response."
        case .decodingFailed:
            return "The watch data could not be read."
        }
    }
}
