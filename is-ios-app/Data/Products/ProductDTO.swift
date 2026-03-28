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

extension ProductDTO {
    func toDomain() throws -> BankProduct {
        guard let productType = BankProductType(rawValue: type) else {
            throw NetworkError.decoding
        }

        guard let productStatus = ProductStatus(rawValue: status) else {
            throw NetworkError.decoding
        }

        guard let decimalValue = Decimal(string: balance.value) else {
            throw NetworkError.decoding
        }

        return BankProduct(
            id: id,
            type: productType,
            title: title,
            balance: MoneyAmount(
                value: decimalValue,
                currency: balance.currency
            ),
            maskedNumber: maskedNumber,
            status: productStatus
        )
    }
}
