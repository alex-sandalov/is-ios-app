import Foundation

enum ProductsListRemoteBDUIScreen {
    case financeCenter
    case premium

    var key: String {
        switch self {
        case .financeCenter:
            return "beta_bank_finance_center"

        case .premium:
            return "beta_bank_premium"
        }
    }

    var title: String {
        switch self {
        case .financeCenter:
            return "Финансовый центр"

        case .premium:
            return "Премиум"
        }
    }
}
