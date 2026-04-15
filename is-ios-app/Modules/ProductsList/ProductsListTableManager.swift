import UIKit

@MainActor
protocol ProductsListTableManagerDelegate: AnyObject {
    func didSelectProduct(at index: Int)
}

@MainActor
final class ProductsListTableManager: NSObject {
    weak var delegate: ProductsListTableManagerDelegate?

    private var items: [ProductListCellConfig] = []

    func configure(with items: [ProductListCellConfig], in tableView: UITableView) {
        self.items = items
        tableView.reloadData()
    }
}

@MainActor
extension ProductsListTableManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductListCell.reuseIdentifier,
            for: indexPath
        ) as? ProductListCell else {
            return UITableViewCell()
        }

        cell.configure(with: items[indexPath.row])
        return cell
    }
}

@MainActor
extension ProductsListTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectProduct(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
