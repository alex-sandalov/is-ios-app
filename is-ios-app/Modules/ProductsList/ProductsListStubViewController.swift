import UIKit

final class ProductsListStubViewController: UIViewController, ProductsListView {
    var presenter: ProductsListPresenter?

    private let titleLabel = UILabel()
    private let stateLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Мои продукты"
        view.backgroundColor = .systemBackground

        setupViews()
        setupLayout()
        setupActions()

        presenter?.didLoad()
    }

    func render(_ state: ProductsListViewState) {
        switch state {
        case .idle:
            activityIndicator.stopAnimating()
            retryButton.isHidden = true
            stateLabel.text = "Ожидание загрузки"

        case .loading:
            activityIndicator.startAnimating()
            retryButton.isHidden = true
            stateLabel.text = "Загрузка..."

        case .content(let items):
            activityIndicator.stopAnimating()
            retryButton.isHidden = true
            stateLabel.text = items
                .map { item in
                    [
                        item.title,
                        item.subtitle,
                        item.amountText,
                        item.statusText
                    ]
                    .compactMap { $0 }
                    .joined(separator: " | ")
                }
                .joined(separator: "\n")

        case .empty(let message):
            activityIndicator.stopAnimating()
            retryButton.isHidden = false
            stateLabel.text = message

        case .error(let message):
            activityIndicator.stopAnimating()
            retryButton.isHidden = false
            stateLabel.text = message
        }
    }

    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.text = "Список продуктов"

        stateLabel.font = .systemFont(ofSize: 16, weight: .regular)
        stateLabel.textColor = .secondaryLabel
        stateLabel.numberOfLines = 0

        retryButton.setTitle("Повторить", for: .normal)
        retryButton.isHidden = true

        view.addSubview(titleLabel)
        view.addSubview(stateLabel)
        view.addSubview(retryButton)
        view.addSubview(activityIndicator)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            activityIndicator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            stateLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 24),
            stateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            retryButton.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 20),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupActions() {
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }

    @objc
    private func didTapRetry() {
        presenter?.didTapRetry()
    }
}
