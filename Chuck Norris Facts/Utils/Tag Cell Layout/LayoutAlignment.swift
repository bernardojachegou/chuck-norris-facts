import UIKit

public extension TagCellLayout {
	
	public enum LayoutAlignment: Int {
		
		case left
		case center
		case right
	}
}

extension TagCellLayout.LayoutAlignment {
	
	var distributionDivisionFactor: CGFloat {
		switch self {
		case .center:
			return 2
		default:
			return 1
		}
	}
}
