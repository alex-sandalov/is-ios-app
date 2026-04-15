import UIKit

@MainActor
final class ProductsListViewController: UIViewController {
    var presenter: ProductsListPresenter?

    private var searchBarView = DSSearchBarView()
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var refreshControl = UIRefreshControl()
    private var stateView = DSStateView()
    private var listManager = ProductsListTableManager()

    override func loadView() {
        view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = DS.Colors.background

        setupNavigationBar()
        setupViews()
        setupHierarchy()
        setupLayout()
        setupTableManager()
        setupRefreshControl()

        presenter?.didLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBarView.resignFocus()
    }

    func render(config: ProductsListScreenConfig) {
        title = config.titleText
        navigationItem.title = config.titleText

        searchBarView.configure(with: config.searchBarConfig)
        stateView.configure(with: config.stateViewConfig)
        listManager.configure(with: config.items, in: tableView)

        tableView.isHidden = config.stateViewConfig.style != .hidden && config.items.isEmpty
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Выйти",
            style: .plain,
            target: self,
            action: #selector(didTapLogout)
        )
    }

    private func setupViews() {
        searchBarView.delegate = self

        tableView.translatesAutoresizingMaskIntoConstraints = false
        stateView.translatesAutoresizingMaskIntoConstraints = false

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 88
        tableView.register(ProductListCell.self, forCellReuseIdentifier: ProductListCell.reuseIdentifier)
    }

    private func setupHierarchy() {
        view.addSubview(searchBarView)
        view.addSubview(tableView)
        view.addSubview(stateView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            searchBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: DS.Spacing.s),
            searchBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: DS.Spacing.m),
            searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -DS.Spacing.m),

            tableView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: DS.Spacing.s),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stateView.topAnchor.constraint(equalTo: searchBarView.bottomAnchor, constant: DS.Spacing.s),
            stateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTableManager() {
        listManager.delegate = self
        tableView.dataSource = listManager
        tableView.delegate = listManager
    }

    private func setupRefreshControl() {
        refreshControl.tintColor = DS.Colors.primary
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
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
    func didSelectProduct(at index: Int) {
        presenter?.didSelectProduct(at: index)
    }
}

@MainActor
extension ProductsListViewController: DSSearchBarViewDelegate {
    func didChangeSearchText(_ text: String?) {
        presenter?.didChangeSearchText(text)
    }
}
