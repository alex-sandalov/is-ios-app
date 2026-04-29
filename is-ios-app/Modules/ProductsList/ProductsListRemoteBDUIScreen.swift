import Foundation

enum ProductsListRemoteBDUIScreen {
    case complex
    case offer

    var key: String {
        switch self {
        case .complex:
            return "lab8_complex_screen"

        case .offer:
            return "lab8_offer_screen"
        }
    }

    var title: String {
        switch self {
        case .complex:
            return "Remote BDUI"

        case .offer:
            return "Offer"
        }
    }
}
