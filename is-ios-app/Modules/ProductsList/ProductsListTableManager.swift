import UIKit

@MainActor
protocol ProductsListTableManagerDelegate: AnyObject {
    func didSelectProduct(id: String)
}

@MainActor
final class ProductsListTableManager: NSObject {
    weak var delegate: ProductsListTableManagerDelegate?

    private var items: [ProductListItem] = []

    func setItems(_ items: [ProductListItem], in tableView: UITableView) {
        self.items = items
        tableView.reloadData()
    }

    func clear(in tableView: UITableView) {
        items = []
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
            return UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        }

        let item = items[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

@MainActor
extension ProductsListTableManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        delegate?.didSelectProduct(id: item.id)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
