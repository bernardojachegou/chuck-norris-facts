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
        
        viewModel.output.categories
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { categories in
                print(categories?.joined(separator: ", ") ?? "no categories")
            })
            .disposed(by: disposeBag)
        
        viewModel.output.facts
            .asDriver(onErrorDriveWith: .just([]))
            .drive(onNext: { [weak self] facts in
                guard let facts = facts else { return }
                self?.factCards = facts.map { FactCard(fact: $0) }
                self?.reloadContentView()
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
        print("open search")
    }
}
