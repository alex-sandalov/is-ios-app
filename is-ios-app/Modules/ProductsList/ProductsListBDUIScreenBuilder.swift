import Foundation

@MainActor
final class ProductsListBDUIScreenBuilder {
    func makeScreen(
        products: [BankProduct],
        query: String
    ) -> BDUIScreenDTO {
        let children: [BDUINodeDTO] = [
            .makeLabel(
                id: "products_title",
                text: query.isEmpty ? "Мои продукты" : "Результаты поиска",
                textStyle: .largeTitle,
                color: .textPrimary
            ),
            .makeLabel(
                id: "products_subtitle",
                text: query.isEmpty
                    ? "Карты, счета и вклады"
                    : "Найдено: \(products.count)",
                textStyle: .bodySecondary,
                color: .textSecondary
            ),
            .makeSearchField(
                id: "products_search_field",
                title: "Поиск",
                placeholder: "Название, номер, тип, статус",
                text: query,
                action: .callback(id: "products_search_changed")
            )
        ] + contentNodes(products: products, query: query)

        return BDUIScreenDTO(
            root: .makeRootScroll(
                id: "products_root",
                children: children
            )
        )
    }

    private func contentNodes(
        products: [BankProduct],
        query: String
    ) -> [BDUINodeDTO] {
        guard !products.isEmpty else {
            return [
                .makeEmpty(
                    id: "products_empty_state",
                    title: query.isEmpty ? "Пока пусто" : "Ничего не найдено",
                    subtitle: query.isEmpty
                        ? "У вас пока нет продуктов"
                        : "Попробуй изменить запрос",
                    actionTitle: nil,
                    action: nil
                )
            ]
        }

        return products.map(makeProductCardNode)
    }

    private func makeProductCardNode(product: BankProduct) -> BDUINodeDTO {
        .makeCard(
            id: "card_\(product.id)",
            children: [
                .makeVerticalStack(
                    id: "stack_\(product.id)",
                    spacing: .s,
                    padding: .s,
                    children: [
                        .makeHorizontalStack(
                            id: "header_row_\(product.id)",
                            spacing: .s,
                            children: [
                                .makeBadge(
                                    id: "type_\(product.id)",
                                    text: typeTitle(product.type)
                                ),
                                .makeFlexibleSpacer(id: "spacer_\(product.id)"),
                                .makeLabel(
                                    id: "status_\(product.id)",
                                    text: statusTitle(product.status),
                                    textStyle: .captionSecondary,
                                    color: statusColor(product.status)
                                )
                            ]
                        ),
                        .makeLabel(
                            id: "title_\(product.id)",
                            text: product.title,
                            textStyle: .title,
                            color: .textPrimary
                        ),
                        .makeLabel(
                            id: "number_\(product.id)",
                            text: product.maskedNumber ?? "Без номера",
                            textStyle: .bodySecondary,
                            color: .textSecondary
                        ),
                        .makeDivider(id: "divider_\(product.id)"),
                        .makeLabel(
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
