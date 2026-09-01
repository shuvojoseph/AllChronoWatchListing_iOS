import Foundation

struct Watch: Codable, Identifiable, Equatable {
    let id: String
    let make: String
    let model: String
    let price: Int
    let currency: String
    let imageUrl: String
}
