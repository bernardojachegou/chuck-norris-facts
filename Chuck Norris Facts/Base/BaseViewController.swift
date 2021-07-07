import UIKit
import RxSwift

class BaseViewController: UIViewController {

    internal lazy var disposeBag = DisposeBag()
    private weak var scrollView: UIScrollView?
    private weak var mainStackView: UIStackView?
    private var contentView: UIView?
    
    public override func loadView() {
        super.loadView()
        setupNavigation()
        setupStructure()
        setup()
        didSetup()
    }
    
    private func setupStructure() {
        view.backgroundColor = .white
        
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let mainStackView = UIStackView(frame: .zero)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        self.scrollView = scrollView
        self.mainStackView = mainStackView
    }
    
    private func setupNavigation() {
        navigationItem.backButtonTitle = ""
        
        if let navbar = navigationController?.navigationBar {
            navbar.backgroundColor = .primaryColor
            navbar.isTranslucent = false
            navbar.barTintColor = .primaryColor
            navbar.tintColor = .white
            navbar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
        }
    }
    
    private func setupScrollViewConstraints(_ distance: CGFloat = 0) {
        
        guard let scrollView = self.scrollView, let parentView = scrollView.superview else {
            return
        }
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: parentView.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: distance)
        ])
    }
    
    private func setupParentView() {
        guard let scrollView = self.scrollView, let mainStackView = self.mainStackView else {
            return
        }
        
        setupScrollViewConstraints()
        mainStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        mainStackView.widthAnchor.constraint(equalToConstant: view.bounds.width - 32).isActive = true
    }
    
    private func setupContentView() {
        if let oldContentView = contentView {
            oldContentView.removeFromSuperview()
        }
        
        
        let newContentView = getContentView()
        newContentView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView?.addArrangedSubview(newContentView)
        contentView = newContentView
    }
    
    private func setup() {
        setupParentView()
        setupContentView()
    }
    
    public func didSetup() {}
    
    public func getContentView() -> UIView {
        return UIView()
    }
    
    public func reloadContentView() {
        setupContentView()
    }
    
    public func setTitle(_ newTitle: String) {
        title = newTitle
    }
    
    public func sectionTitle(_ titleString: String) -> UIView {
        let holder = UIView()
        let label = UILabel()
        label.text = titleString
        label.font = .boldSystemFont(ofSize: 12)
        holder.addSubview(label)
        label.fillParentView(padding: 4)
        return holder
    }
    
    public func spacer(_ size: CGFloat = 8) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: 0, height: size))
    }
}

