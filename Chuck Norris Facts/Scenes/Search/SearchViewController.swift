import UIKit
import RxSwift
import RxCocoa

protocol SearchViewControllerDelegate {
    func searchBy(keyword: String)
    func searchBy(category: String)
}

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
    
    private var categoriesCollectionView: TagsCollectionView!
    private var searchesCollectionView: TagsCollectionView!
    
    public var delegate: SearchViewControllerDelegate?
    
    override func didSetup() {
        super.didSetup()
        
        setupNavBar()
        setupBindings()
        setupLayout()
        
        viewModel.fetchCategories()
        viewModel.fetchSavedSearches()
    }
    
    override func getContentView() -> UIView {
        categoriesCollectionView = TagsCollectionView(delegate: self)
        searchesCollectionView = TagsCollectionView(delegate: self)
        return renderSearchView()
    }
    
    private func setupNavBar() {
        setTitle("Search facts")
    }
    
    private func renderSearchView() -> UIView {
        stackView.addArrangedSubview(sectionTitle("Search facts", textColor: .lightGray))
        stackView.addArrangedSubview(searchTextField)
        stackView.addArrangedSubview(sectionTitle("Categories", textColor: .lightGray))
        stackView.addArrangedSubview(categoriesCollectionView)
        stackView.addArrangedSubview(sectionTitle("Saved searches", textColor: .lightGray))
        stackView.addArrangedSubview(searchesCollectionView)
        return stackView
    }
    
    private func setupBindings() {
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .map({ [weak self] _ in
                return self?.searchTextField.text ?? ""
            })
            .filter({ term in
                return !term.isEmpty
            })
            .bind(to: viewModel.input.keyword)
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
        
        viewModel.output.searchByTerm.asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] term in
                self?.delegate?.searchBy(keyword: term)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.searchByCategory.asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] category in
                self?.delegate?.searchBy(category: category)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        view.backgroundColor = .darkText
        searchesCollectionView.tagStyle = TagsCollectionView.TagStyle(foregroundColor: .white, backgroundColor: .darkGray)
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

extension SearchViewController: TagsCollectionViewDelegate {
    func didSelect(collectionView: TagsCollectionView, tag: String) {
        if collectionView == searchesCollectionView {
            viewModel.input.keyword.onNext(tag)
        }
        if collectionView == categoriesCollectionView {
            viewModel.input.category.onNext(tag)
        }
    }
    
    
}
