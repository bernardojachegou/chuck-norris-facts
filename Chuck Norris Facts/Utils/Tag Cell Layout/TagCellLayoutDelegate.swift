import UIKit

public protocol TagCellLayoutDelegate: AnyObject {
	func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index: Int) -> CGSize
}
