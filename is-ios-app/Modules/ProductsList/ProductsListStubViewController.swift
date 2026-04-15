import UIKit

@MainActor
final class ProductsListStubViewController: UIViewController, ProductsListView {
    var presenter: ProductsListPresenter?

    private var titleLabel = UILabel()
    private var stateLabel = UILabel()
    private var retryButton = UIButton(type: .system)
    private var activityIndicator = UIActivityIndicatorView(style: .large)

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupViews()
        setupLayout()
        setupActions()

        presenter?.didLoad()
    }

    func render(config: ProductsListScreenConfig) {
        title = config.titleText
        titleLabel.text = config.titleText

        switch config.stateViewConfig.style {
        case .hidden:
            activityIndicator.stopAnimating()
            retryButton.isHidden = true

            if config.items.isEmpty {
                stateLabel.text = "Ожидание загрузки"
            } else {
                stateLabel.text = config.items
                    .map { item in
                        [
                            item.titleText,
                            item.subtitleText,
                            item.amountText,
                            item.statusText
                        ]
                        .compactMap { $0 }
                        .joined(separator: " | ")
                    }
                    .joined(separator: "\n")
            }

        case .loading:
            activityIndicator.startAnimating()
            retryButton.isHidden = true
            stateLabel.text = config.stateViewConfig.message ?? "Загрузка..."

        case .empty:
            activityIndicator.stopAnimating()
            retryButton.isHidden = true
            stateLabel.text = config.stateViewConfig.message ?? "Пусто"

        case .error:
            activityIndicator.stopAnimating()
            retryButton.isHidden = config.stateViewConfig.actionTitle == nil
            stateLabel.text = config.stateViewConfig.message ?? "Ошибка"
            if let actionTitle = config.stateViewConfig.actionTitle {
                retryButton.setTitle(actionTitle, for: .normal)
            }
        }
    }

    private func setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)

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
