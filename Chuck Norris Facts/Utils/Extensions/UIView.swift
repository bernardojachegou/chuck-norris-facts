import UIKit

extension UIView {
    func fillParentView(padding: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            superview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor, constant: padding),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -padding),
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: padding),
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -padding)
            ])
        }
    }
}
