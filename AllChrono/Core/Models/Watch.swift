import Foundation

struct Watch: Codable, Identifiable, Hashable {
    let id: String
    let make: String
    let model: String
    let price: Decimal
    let currency: String
    let imageURL: URL?

    enum CodingKeys: String, CodingKey {
        case id, make, model, price, currency
        case imageURL = "imageUrl"
    }

    var displayPrice: String {
        price.formatted(
            .currency(code: currency)
                .precision(.fractionLength(0))
        )
    }
}
