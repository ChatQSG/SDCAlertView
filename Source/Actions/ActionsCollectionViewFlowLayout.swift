import UIKit

let kHorizontalActionSeparator = "horizontal"
let kVerticalActionSeparator = "vertical"

final class ActionsCollectionViewFlowLayout: UICollectionViewFlowLayout {

    var shouldHideTopSeparator = false
    var visualStyle: AlertVisualStyle?

    override static var layoutAttributesClass: AnyClass {
        return ActionsCollectionViewLayoutAttributes.self
    }

    override init() {
        super.init()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var mutableAttributes = attributes

        for attribute in attributes {
            if let horizontal = self.layoutAttributesForDecorationView(ofKind: kHorizontalActionSeparator,
                at: attribute.indexPath) {
                mutableAttributes.append(horizontal)
            }

            if self.scrollDirection == .horizontal && attribute.indexPath.item > 0,
                let vertical = layoutAttributesForDecorationView(ofKind: kVerticalActionSeparator,
                at: attribute.indexPath) {
                mutableAttributes.append(vertical)
            }
        }

        return mutableAttributes
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String,
                                                    at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let itemAttributes = self.layoutAttributesForItem(at: indexPath) else {
            return nil
        }

        let attributes = ActionsCollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind,
                                                               with: indexPath)
        attributes.zIndex = itemAttributes.zIndex + 1
        attributes.backgroundColor = self.visualStyle?.actionViewSeparatorColor

        let defaultThick = self.visualStyle?.actionViewSeparatorThickness ?? 0.5
        let thick = indexPath.row == 0 ? (shouldHideTopSeparator ? 0 : defaultThick) : defaultThick
        var decorationViewFrame = itemAttributes.frame
        if elementKind == kHorizontalActionSeparator {
            decorationViewFrame.size.height = thick
        } else {
            decorationViewFrame.size.width = thick
        }

        attributes.frame = decorationViewFrame
        return attributes
    }
}

class ActionsCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor: UIColor?
}
