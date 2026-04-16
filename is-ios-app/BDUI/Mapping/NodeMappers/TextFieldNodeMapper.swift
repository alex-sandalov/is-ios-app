import UIKit

@MainActor
final class TextFieldNodeMapper: BDUINodeMapping {
    let supportedType: BDUIComponentType = .textField

    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView? {
        guard case .textField(let content)? = node.content else { return nil }

        let textFieldView = DSTextFieldView()
        textFieldView.configure(
            with: .init(
                title: content.title,
                placeholder: content.placeholder,
                text: content.text,
                errorMessage: content.errorMessage,
                isSecure: content.isSecure ?? false,
                keyboardType: .default,
                textContentType: nil,
                returnKeyType: .default
            )
        )

        context.bindAction(node.action, to: textFieldView)

        return textFieldView
    }
}
