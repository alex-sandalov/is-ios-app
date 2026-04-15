import UIKit

struct ProductListCellConfig {
    let titleText: String
    let subtitleText: String?
    let amountText: String
    let statusText: String
}

struct ProductsListScreenConfig {
    let titleText: String
    let searchBarConfig: DSSearchBarView.Config
    let stateViewConfig: DSStateView.Config
    let items: [ProductListCellConfig]
}
