import Foundation

enum BDUIActionDTO: Decodable {
    case callback(id: String)
    case reload
    case route(destination: String, payload: String?)

    private enum CodingKeys: String, CodingKey {
        case type
        case id
        case destination
        case payload
    }

    private enum ActionType: String, Decodable {
        case callback
        case reload
        case route
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ActionType.self, forKey: .type)

        switch type {
        case .callback:
            self = .callback(id: try container.decode(String.self, forKey: .id))
        case .reload:
            self = .reload
        case .route:
            self = .route(
                destination: try container.decode(String.self, forKey: .destination),
                payload: try container.decodeIfPresent(String.self, forKey: .payload)
            )
        }
    }
}

enum BDUIComponentType: String, Decodable {
    case label
    case button
    case vStack
    case hStack
    case card
    case scroll
    case container
    case spacer
    case divider
    case textField
    case loading
    case empty
}

struct BDUILabelContentDTO: Decodable {
    let text: String
    let textStyle: BDUITextStyleToken
    let color: BDUIColorToken?
    let alignment: String?
    let numberOfLines: Int?
}

struct BDUIButtonContentDTO: Decodable {
    let title: String
    let style: BDUIButtonStyleToken
    let isEnabled: Bool?
}

struct BDUIStackContentDTO: Decodable {
    let spacing: BDUISpacingToken?
    let padding: BDUISpacingToken?
    let backgroundColor: BDUIColorToken?
}

struct BDUICardContentDTO: Decodable {
    let padding: BDUISpacingToken?
    let backgroundColor: BDUIColorToken?
}

struct BDUIScrollContentDTO: Decodable {
    let spacing: BDUISpacingToken?
    let padding: BDUISpacingToken?
    let backgroundColor: BDUIColorToken?
}

struct BDUIContainerContentDTO: Decodable {
    let backgroundColor: BDUIColorToken?
    let padding: BDUISpacingToken?
    let cornerRadius: BDUICornerRadiusToken?
}

struct BDUISpacerContentDTO: Decodable {
    let height: Double?
}

struct BDUIDividerContentDTO: Decodable {
    let color: BDUIColorToken?
    let thickness: Double?
}

struct BDUITextFieldContentDTO: Decodable {
    let placeholder: String
    let title: String
    let text: String?
    let errorMessage: String?
    let isSecure: Bool?
}

struct BDUILoadingContentDTO: Decodable {
    let title: String?
    let message: String?
}

struct BDUIEmptyContentDTO: Decodable {
    let title: String
    let subtitle: String?
    let actionTitle: String?
}

enum BDUIContentDTO {
    case label(BDUILabelContentDTO)
    case button(BDUIButtonContentDTO)
    case stack(BDUIStackContentDTO)
    case card(BDUICardContentDTO)
    case scroll(BDUIScrollContentDTO)
    case container(BDUIContainerContentDTO)
    case spacer(BDUISpacerContentDTO)
    case divider(BDUIDividerContentDTO)
    case textField(BDUITextFieldContentDTO)
    case loading(BDUILoadingContentDTO)
    case empty(BDUIEmptyContentDTO)
}

struct BDUINodeDTO: Decodable {
    let id: String
    let type: BDUIComponentType
    let content: BDUIContentDTO?
    let subviews: [BDUINodeDTO]
    let action: BDUIActionDTO?
    let isVisible: Bool

    init(
        id: String,
        type: BDUIComponentType,
        content: BDUIContentDTO?,
        subviews: [BDUINodeDTO],
        action: BDUIActionDTO?,
        isVisible: Bool
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.subviews = subviews
        self.action = action
        self.isVisible = isVisible
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case content
        case subviews
        case action
        case isVisible
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(BDUIComponentType.self, forKey: .type)
        subviews = try container.decodeIfPresent([BDUINodeDTO].self, forKey: .subviews) ?? []
        action = try container.decodeIfPresent(BDUIActionDTO.self, forKey: .action)
        isVisible = try container.decodeIfPresent(Bool.self, forKey: .isVisible) ?? true

        switch type {
        case .label:
            content = .label(try container.decode(BDUILabelContentDTO.self, forKey: .content))
        case .button:
            content = .button(try container.decode(BDUIButtonContentDTO.self, forKey: .content))
        case .vStack, .hStack:
            content = .stack(
                try container.decodeIfPresent(BDUIStackContentDTO.self, forKey: .content)
                ?? .init(spacing: nil, padding: nil, backgroundColor: nil)
            )
        case .card:
            content = .card(
                try container.decodeIfPresent(BDUICardContentDTO.self, forKey: .content)
                ?? .init(padding: nil, backgroundColor: nil)
            )
        case .scroll:
            content = .scroll(
                try container.decodeIfPresent(BDUIScrollContentDTO.self, forKey: .content)
                ?? .init(spacing: nil, padding: nil, backgroundColor: nil)
            )
        case .container:
            content = .container(
                try container.decodeIfPresent(BDUIContainerContentDTO.self, forKey: .content)
                ?? .init(backgroundColor: nil, padding: nil, cornerRadius: nil)
            )
        case .spacer:
            content = .spacer(
                try container.decodeIfPresent(BDUISpacerContentDTO.self, forKey: .content)
                ?? .init(height: nil)
            )
        case .divider:
            content = .divider(
                try container.decodeIfPresent(BDUIDividerContentDTO.self, forKey: .content)
                ?? .init(color: nil, thickness: nil)
            )
        case .textField:
            content = .textField(try container.decode(BDUITextFieldContentDTO.self, forKey: .content))
        case .loading:
            content = .loading(
                try container.decodeIfPresent(BDUILoadingContentDTO.self, forKey: .content)
                ?? .init(title: nil, message: nil)
            )
        case .empty:
            content = .empty(try container.decode(BDUIEmptyContentDTO.self, forKey: .content))
        }
    }
}

struct BDUIScreenDTO: Decodable {
    let root: BDUINodeDTO

    init(root: BDUINodeDTO) {
        self.root = root
    }
}
