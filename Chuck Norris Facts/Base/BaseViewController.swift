import UIKit
import RxSwift

class BaseViewController: UIViewController {

    internal lazy var disposeBag = DisposeBag()
    private weak var scrollView: UIScrollView?
    private weak var mainStackView: UIStackView?
    
    public override func loadView() {
        super.loadView()
        setupStructure()
    }
    
    private func setupStructure() {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        
        let mainStackView = UIStackView(frame: .zero)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 0
        mainStackView.alignment = .fill
        mainStackView.distribution = .fill
        mainStackView.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        self.scrollView = scrollView
        self.mainStackView = mainStackView
        
        navigationItem.backButtonTitle = ""
        setup()
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
        
        let fieldView = getContentView()
        fieldView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.addArrangedSubview(fieldView)
    }
    
    private func setup() {
        setupParentView()
        didSetup()
    }
    
    public func didSetup() {}
    
    public func getContentView() -> UIView {
        return UIView()
    }
}

