import UIKit

final class ProductsListRouterImpl: ProductsListRouter {
    weak var viewController: UIViewController?

    func openProductDetails(productId: String, session: UserSession) {
        let alert = UIAlertController(
            title: "Product Details",
            message: "Открыть деталку продукта с id: \(productId)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alert, animated: true)
    }

    func openAuth() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
