import Foundation
import Toaster
import PKHUD
import RxSwift
import RxCocoa

class FactsViewController: BaseViewController {
    
    private var viewModel = FactsViewModel()
    private var factCards: [FactCard] = []
    
    private var noFactsMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "No facts yet. Try searching for facts!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .darkGray
        return label
    }()
    
    public var onOpenSearch: (() -> ())?
    public var onCloseSearch: (() -> ())?
    
    override func didSetup() {
        super.didSetup()
        setupNavBar()
        setupBindings()
    }
    
    override func getContentView() -> UIView {
        if factCards.isEmpty {
            return noFactsMessageLabel
        }
        return renderFactCards()
    }
    
    private func setupNavBar() {
        setTitle("Chuck Norris")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(openSearch))
    }
    
    private func setupBindings() {
        
        viewModel.output.loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { loading in
                if loading {
                    HUD.show(.progress)
                } else {
                    HUD.hide()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.error
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] error in
                self?.noFactsMessageLabel.text = error.getMessage()
                self?.displayError(error)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.facts
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] facts in
                self?.processFacts(facts)
            })
            .disposed(by: disposeBag)
    }
    
    private func renderFactCards() -> UIView {
        let list = UIView()
        let stack = UIStackView()
        
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 8
        
        factCards.forEach { fact in
            stack.addArrangedSubview(fact)
        }
        
        list.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.fillParentView(padding: 0)
        
        return list
    }
    
    @objc private func openSearch() {
        onOpenSearch?()
    }
    
    private func processFacts(_ facts: [FactModel]?) {
        factCards = []
        if let facts = facts, !facts.isEmpty {
            factCards = facts.map { FactCard(fact: $0) { [weak self] factUrlString in
                self?.shareUrlString(factUrlString)
            } }
        } else {
            noFactsMessageLabel.text = "Your search has no results, try another term"
        }
        
        reloadContentView()
    }
}

extension FactsViewController {
    fileprivate func shareUrlString(_ shareableURLString: String) {
        guard let shareableURL = URL(string: shareableURLString), UIApplication.shared.canOpenURL(shareableURL) else {
            return
        }
        UIApplication.shared.open(shareableURL, options: [:], completionHandler: nil)
    }
}

extension FactsViewController: SearchViewControllerDelegate {
    func searchBy(keyword: String) {
        viewModel.input.keyword.onNext(keyword)
        onCloseSearch?()
    }
    
    func searchBy(category: String) {
        viewModel.input.category.onNext(category)
        onCloseSearch?()
    }
}
