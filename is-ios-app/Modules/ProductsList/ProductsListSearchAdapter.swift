import UIKit

@MainActor
final class ProductsListSearchAdapter: NSObject, UISearchResultsUpdating, UISearchBarDelegate {
    weak var presenter: ProductsListPresenter?

    func updateSearchResults(for searchController: UISearchController) {
        presenter?.didSearch(query: searchController.searchBar.text ?? "")
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.didSearch(query: "")
    }
}
