import UIKit

extension UIView {
    func fillParentView(padding: CGFloat = 0) {
        if let superview = superview {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding),
            ])
        }
    }
}
