import UIKit

@MainActor
final class BDUIMapperRegistry {
    private var storage: [BDUIComponentType: any BDUINodeMapping] = [:]

    func register(_ mapper: any BDUINodeMapping) {
        storage[mapper.supportedType] = mapper
    }

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard node.isVisible else { return nil }
        guard let mapper = storage[node.type] else { return nil }

        guard let view = mapper.map(node: node, context: context) else {
            return nil
        }

        context.register(view: view, for: node.id)
        return view
    }

    static func makeDefault() -> BDUIMapperRegistry {
        let registry = BDUIMapperRegistry()
        registry.register(LabelNodeMapper())
        registry.register(ButtonNodeMapper())
        registry.register(VerticalStackNodeMapper())
        registry.register(HorizontalStackNodeMapper())
        registry.register(ContainerNodeMapper())
        registry.register(SpacerNodeMapper())
        registry.register(DividerNodeMapper())
        registry.register(CardNodeMapper())
        registry.register(TextFieldNodeMapper())
        registry.register(LoadingNodeMapper())
        registry.register(EmptyNodeMapper())
        registry.register(ScrollNodeMapper())
        return registry
    }
}
