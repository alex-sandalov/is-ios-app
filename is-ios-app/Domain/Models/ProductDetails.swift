import Foundation

struct ProductDetails: Equatable {
    let id: String
    let type: BankProductType
    let title: String
    let balance: MoneyAmount
    let maskedNumber: String?
    let status: ProductStatus
    let openedAt: Date?
    let recentOperations: [OperationPreview]
}
