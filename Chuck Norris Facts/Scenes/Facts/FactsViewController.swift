import Foundation
import Toaster
import PKHUD

class FactsViewController: BaseViewController {
    private var viewModel = FactsViewModel()
    
    private var factCard: UILabel = {
        let label = UILabel()
        label.text = "Chuck Norris"
        label.numberOfLines = 0
        return label
    }()
    
    override func didSetup() {
        super.didSetup()
        setupNavBar()
        setupBindings()
        loadData()
    }
    
    override func getContentView() -> UIView {
        return factCard
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
            .drive(onNext: { [weak self] categories in
                self?.factCard.text = categories?.joined(separator: ", ")
            })
            .disposed(by: disposeBag)

    }
    
    private func loadData() {
        viewModel.fetchCategories()
    }
    
    @objc private func openSearch() {
        print("open search")
    }
}
