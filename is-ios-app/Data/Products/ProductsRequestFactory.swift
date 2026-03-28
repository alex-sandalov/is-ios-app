import Foundation

struct ProductsRequestFactory {
    let productsURL: URL

    func makeProductsListRequest() -> URLRequest {
        var request = URLRequest(url: productsURL)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
