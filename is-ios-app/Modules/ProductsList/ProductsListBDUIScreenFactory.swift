import Foundation

@MainActor
final class ProductsListBDUIScreenFactory {
    func makeScreen(products: [BankProduct]) -> BDUIScreenDTO {
        guard !products.isEmpty else {
            return BDUIScreenDTO(
                root: BDUINodeDTO.makeRootScroll(
                    id: "products_empty_root",
                    children: [
                        BDUINodeDTO.makeEmpty(
                            id: "products_empty_state",
                            title: "Ничего не найдено",
                            subtitle: "Попробуй изменить запрос",
                            actionTitle: nil,
                            action: nil
                        )
                    ]
                )
            )
        }

        return BDUIScreenDTO(
            root: BDUINodeDTO.makeRootScroll(
                id: "products_root",
                children: products.map(makeProductCardNode)
            )
        )
    }

    private func makeProductCardNode(product: BankProduct) -> BDUINodeDTO {
        BDUINodeDTO.makeCard(
            id: "card_\(product.id)",
            children: [
                BDUINodeDTO.makeVerticalStack(
                    id: "stack_\(product.id)",
                    spacing: .s,
                    padding: .s,
                    children: [
                        BDUINodeDTO.makeHorizontalStack(
                            id: "header_row_\(product.id)",
                            spacing: .s,
                            children: [
                                BDUINodeDTO.makeBadge(
                                    id: "type_\(product.id)",
                                    text: typeTitle(product.type)
                                ),
                                BDUINodeDTO.makeFlexibleSpacer(id: "spacer_\(product.id)"),
                                BDUINodeDTO.makeLabel(
                                    id: "status_\(product.id)",
                                    text: statusTitle(product.status),
                                    textStyle: .captionSecondary,
                                    color: statusColor(product.status)
                                )
                            ]
                        ),
                        BDUINodeDTO.makeLabel(
                            id: "title_\(product.id)",
                            text: product.title,
                            textStyle: .title,
                            color: .textPrimary
                        ),
                        BDUINodeDTO.makeLabel(
                            id: "number_\(product.id)",
                            text: product.maskedNumber ?? "Без номера",
                            textStyle: .bodySecondary,
                            color: .textSecondary
                        ),
                        BDUINodeDTO.makeDivider(id: "divider_\(product.id)"),
                        BDUINodeDTO.makeLabel(
                            id: "amount_\(product.id)",
                            text: amountText(product.balance),
                            textStyle: .bodyAccent,
                            color: .primary
                        )
                    ]
                )
            ]
        )
    }

    private func typeTitle(_ type: BankProductType) -> String {
        switch type {
        case .account: return "Счёт"
        case .card: return "Карта"
        case .deposit: return "Вклад"
        }
    }

    private func statusTitle(_ status: ProductStatus) -> String {
        switch status {
        case .active: return "Активен"
        case .blocked: return "Заблокирован"
        case .closed: return "Закрыт"
        }
    }

    private func statusColor(_ status: ProductStatus) -> BDUIColorToken {
        switch status {
        case .active: return .success
        case .blocked: return .error
        case .closed: return .textSecondary
        }
    }

    private func amountText(_ amount: MoneyAmount) -> String {
        "\(amount.value) \(amount.currency)"
    }
}
