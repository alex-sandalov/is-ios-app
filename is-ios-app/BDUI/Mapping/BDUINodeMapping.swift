import UIKit

@MainActor
protocol BDUINodeMapping {
    var supportedType: BDUIComponentType { get }
    func map(
        node: BDUINodeDTO,
        context: BDUINodeMappingContext
    ) -> UIView?
}
