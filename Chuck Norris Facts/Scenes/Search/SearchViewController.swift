import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
    private var viewModel = SearchViewModel()
    private let collectionViewHeight: CGFloat = 120
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 8
        return stack
    }()
    
    private var searchTextField: UITextField = {
        let field = UITextField()
        field.keyboardType = .webSearch
        field.borderStyle = .roundedRect
        field.placeholder = "Enter your search term"
        field.returnKeyType = .search
        return field
    }()
    
    private var categoriesCollectionView = TagsCollectionView()
    private var searchesCollectionView = TagsCollectionView()
    
    override func didSetup() {
        super.didSetup()
        setupNavBar()
        setupBindings()
        setupLayout()
    }
    
    override func getContentView() -> UIView {
        return renderSearchView()
    }
    
    private func setupNavBar() {
        setTitle("Search facts")
    }
    
    private func renderSearchView() -> UIView {
        stackView.addArrangedSubview(sectionTitle("Search facts"))
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(sectionTitle("Categories"))
        stackView.addArrangedSubview(categoriesCollectionView)
        stackView.addArrangedSubview(sectionTitle("Saved searches"))
        stackView.addArrangedSubview(searchesCollectionView)
        return stackView
    }
    
    private func setupBindings() {
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe { _ in
                print("pressed search")
            }
            .disposed(by: disposeBag)
        
        viewModel.output.categories.asDriver(onErrorDriveWith: .just([]))
            .drive { [weak self] categories in
                self?.updateCollectionViewCategories(categories)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.savedSearches.asDriver(onErrorDriveWith: .just([]))
            .drive { [weak self] searches in
                self?.updateCollectionViewSearches(searches)
            }
            .disposed(by: disposeBag)

    }
    
    private func setupLayout() {
        
        categoriesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        searchesCollectionView.tagStyle = TagsCollectionView.TagStyle(foregroundColor: .darkText, backgroundColor: .lightGray)
        
//        NSLayoutConstraint.activate([
//            categoriesCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight),
//            searchesCollectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight)
//        ])
    }
    
    private func updateCollectionViewCategories(_ categories: [String]?) {
        guard let categories = categories else {
            return
        }
        categoriesCollectionView.setTags(categories)
    }
    
    private func updateCollectionViewSearches(_ searches: [String]?) {
        guard let searches = searches else {
            return
        }
        searchesCollectionView.setTags(searches)
    }
    
}
