import Foundation

struct ProductDTO: Decodable {
    let id: String
    let type: String
    let title: String
    let balance: ProductBalanceDTO
    let maskedNumber: String?
    let status: String
}

struct ProductBalanceDTO: Decodable {
    let value: String
    let currency: String
}
