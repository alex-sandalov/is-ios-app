import Foundation

enum BankProductType: String, Equatable {
    case account
    case card
    case deposit
}

enum ProductStatus: String, Equatable {
    case active
    case blocked
    case closed
}

struct BankProduct: Equatable {
    let id: String
    let type: BankProductType
    let title: String
    let balance: MoneyAmount
    let maskedNumber: String?
    let status: ProductStatus
}
