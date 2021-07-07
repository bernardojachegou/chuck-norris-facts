import UIKit

public extension TagCellLayout {
	
	struct LayoutInfo {
		
		var layoutAttribute: UICollectionViewLayoutAttributes
		var whiteSpace: CGFloat = 0.0
		var isFirstElementInARow = false
		
		init(layoutAttribute: UICollectionViewLayoutAttributes) {
			self.layoutAttribute = layoutAttribute
		}
	}
}
