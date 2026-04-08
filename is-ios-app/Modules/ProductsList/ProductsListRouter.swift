import UIKit

@MainActor
final class ProductsListRouterImpl: ProductsListRouter {
    weak var viewController: UIViewController?

    func openProductDetails(productId: String, session: UserSession) {
        let detailsViewController = UIViewController()
        detailsViewController.view.backgroundColor = .systemBackground
        detailsViewController.title = "Детали"

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "Заглушка деталей\nID: \(productId)"

        detailsViewController.view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: detailsViewController.view.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: detailsViewController.view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: detailsViewController.view.trailingAnchor, constant: -24)
        ])

        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }

    func openAuth() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}
