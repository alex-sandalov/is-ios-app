import Foundation

struct ProductDomainMapper {
    func map(_ dto: ProductDTO) throws -> BankProduct {
        guard let productType = BankProductType(rawValue: dto.type) else {
            throw NetworkError.decoding
        }

        guard let productStatus = ProductStatus(rawValue: dto.status) else {
            throw NetworkError.decoding
        }

        guard let decimalValue = Decimal(string: dto.balance.value) else {
            throw NetworkError.decoding
        }

        return BankProduct(
            id: dto.id,
            type: productType,
            title: dto.title,
            balance: MoneyAmount(
                value: decimalValue,
                currency: dto.balance.currency
            ),
            maskedNumber: dto.maskedNumber,
            status: productStatus
        )
    }
}
