import Foundation

protocol ProductDetailsView: AnyObject {
    func render(_ state: ProductDetailsViewState)
}

protocol ProductDetailsPresenter {
    func didLoad()
    func didTapClose()
}

protocol ProductDetailsRouter {
    func close()
}
