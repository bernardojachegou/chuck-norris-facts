import UIKit

public protocol TagCellLayoutDelegate {
	func tagCellLayoutTagSize(layout: TagCellLayout, atIndex index:Int) -> CGSize
}
