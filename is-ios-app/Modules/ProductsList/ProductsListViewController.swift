import UIKit

@MainActor
final class ProductsListViewController: UIViewController {
    var presenter: ProductsListPresenter?

    private var tableView = UITableView(frame: .zero, style: .plain)
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var messageLabel = UILabel()
    private var retryButton = UIButton(type: .system)
    private var searchController = UISearchController(searchResultsController: nil)
    private var refreshControl = UIRefreshControl()
    private var listManager = ProductsListTableManager()

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Продукты"
        view.backgroundColor = .systemBackground
        view.tintColor = .systemBlue

        setupNavigationBar()
        setupViews()
        setupHierarchy()
        setupLayout()
        setupTableManager()
        setupSearch()
        setupRefreshControl()

        presenter?.didLoad()
    }

    func render(_ state: ProductsListViewState) {
        refreshControl.endRefreshing()

        switch state {
        case .idle:
            showIdleState()

        case .loading:
            showLoadingState()

        case .content(let items):
            showContentState(items)

        case .empty(let message):
            showMessageState(message: message, showsRetry: false)

        case .error(let message):
            showMessageState(message: message, showsRetry: true)
        }
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Выйти",
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
    }

    private func setupViews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.isHidden = true

        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .systemBlue

        messageLabel.font = .systemFont(ofSize: 17, weight: .regular)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.isHidden = true

        retryButton.configuration = .filled()
        retryButton.configuration?.title = "Повторить"
        retryButton.configuration?.baseBackgroundColor = .systemBlue
        retryButton.configuration?.baseForegroundColor = .white
        retryButton.isHidden = true
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
    }

    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(messageLabel)
        view.addSubview(retryButton)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 16),
            retryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupTableManager() {
        listManager.delegate = self
        tableView.dataSource = listManager
        tableView.delegate = listManager
    }

    private func setupSearch() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск продуктов"
        searchController.searchResultsUpdater = self
        searchController.searchBar.tintColor = .systemBlue
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    private func setupRefreshControl() {
        refreshControl.tintColor = .systemBlue
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func showIdleState() {
        activityIndicator.stopAnimating()
        tableView.isHidden = true
        messageLabel.isHidden = true
        retryButton.isHidden = true
        listManager.clear(in: tableView)
    }

    private func showLoadingState() {
        activityIndicator.startAnimating()
        tableView.isHidden = true
        messageLabel.isHidden = true
        retryButton.isHidden = true
    }

    private func showContentState(_ items: [ProductListItem]) {
        activityIndicator.stopAnimating()
        messageLabel.isHidden = true
        retryButton.isHidden = true
        tableView.isHidden = false
        listManager.setItems(items, in: tableView)
    }

    private func showMessageState(message: String, showsRetry: Bool) {
        activityIndicator.stopAnimating()
        tableView.isHidden = true
        listManager.clear(in: tableView)

        messageLabel.isHidden = false
        messageLabel.text = message

        retryButton.isHidden = !showsRetry
    }

    @objc
    private func didTapRetry() {
        presenter?.didTapRetry()
    }

    @objc
    private func didTapLogout() {
        presenter?.didTapLogout()
    }

    @objc
    private func didPullToRefresh() {
        presenter?.didPullToRefresh()
    }
}

@MainActor
extension ProductsListViewController: ProductsListView {}

@MainActor
extension ProductsListViewController: ProductsListTableManagerDelegate {
    func didSelectProduct(id: String) {
        presenter?.didSelectProduct(id: id)
    }
}

@MainActor
extension ProductsListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter?.didChangeSearchQuery(searchController.searchBar.text)
    }
}
