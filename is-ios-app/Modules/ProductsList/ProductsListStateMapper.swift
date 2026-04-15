import Foundation

protocol ProductsListStateMapping {
    func map(products: [BankProduct]) -> [ProductListCellConfig]
    func map(error: Error) -> String
}

struct ProductsListStateMapper: ProductsListStateMapping {
    func map(products: [BankProduct]) -> [ProductListCellConfig] {
        products.map { product in
            ProductListCellConfig(
                titleText: product.title,
                subtitleText: makeSubtitle(for: product),
                amountText: makeAmountText(for: product.balance),
                statusText: makeStatusText(for: product.status)
            )
        }
    }

    func map(error: Error) -> String {
        guard let networkError = error as? NetworkError else {
            return "Произошла неизвестная ошибка"
        }

        switch networkError {
        case .transport:
            return "Не удалось загрузить данные. Проверьте интернет-соединение"
        case .httpStatus(let statusCode):
            return "Сервер вернул ошибку (\(statusCode))"
        case .invalidResponse:
            return "Получен некорректный ответ сервера"
        case .decoding:
            return "Не удалось обработать данные сервера"
        case .cancelled:
            return "Загрузка была отменена"
        }
    }

    private func makeSubtitle(for product: BankProduct) -> String? {
        let typeText: String

        switch product.type {
        case .account:
            typeText = "Счёт"
        case .card:
            typeText = "Карта"
        case .deposit:
            typeText = "Вклад"
        }

        guard let maskedNumber = product.maskedNumber, !maskedNumber.isEmpty else {
            return typeText
        }

        return "\(typeText) • \(maskedNumber)"
    }

    private func makeAmountText(for amount: MoneyAmount) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = amount.currency
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0

        let number = NSDecimalNumber(decimal: amount.value)
        return formatter.string(from: number) ?? "\(amount.value) \(amount.currency)"
    }

    private func makeStatusText(for status: ProductStatus) -> String {
        switch status {
        case .active:
            return "Активен"
        case .blocked:
            return "Заблокирован"
        case .closed:
            return "Закрыт"
        }
    }
}
