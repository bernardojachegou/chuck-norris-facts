import Foundation
import Networking
import RxCocoa
import RxSwift

class SearchViewModel {
    
    struct Output {
        let categories: Observable<[String]?>
        let savedSearches: Observable<[String]?>
        let searchByTerm: Observable<String>
        let searchByCategory: Observable<String>
    }
    
    struct Input {
        let keyword: PublishSubject<String>
        let category: PublishSubject<String>
    }
    
    private let httpClient = HttpClient()
    private let disposeBag = DisposeBag()
    private let activityTracker = PublishRelay<Bool>()
    private let categoriesSubject = PublishRelay<[String]?>()
    private let errorSubject = PublishRelay<ErrorHandleable>()
    
    private let savedSearchesSubject = BehaviorSubject<[String]?>(value: nil)
    private let keywordSubject = PublishSubject<String>()
    private let categorySubject = PublishSubject<String>()
    private let searchByTermSubject = PublishSubject<String>()
    private let searchByCategorySubject = PublishSubject<String>()
    
    public let output: Output!
    public var input: Input!
    
    init() {
        output = Output(
            categories: categoriesSubject.map { SearchViewModel.randomizeResult($0) }.asObservable(),
            savedSearches: savedSearchesSubject.asObservable(),
            searchByTerm: searchByTermSubject.asObservable(),
            searchByCategory: searchByCategorySubject.asObservable()
        )
        
        input = Input(
            keyword: keywordSubject,
            category: categorySubject
        )
        
        setupBindings()
    }
    
    public func fetchCategories() {
        if let categories = UserDefaults.standard.array(forKey: "OFFLINE_CATEGORIES") as? [String] {
            categoriesSubject.accept(categories)
        }
    }
    
    public func fetchSavedSearches() {
        if let searches = loadSearchesLocally() {
            savedSearchesSubject.onNext(searches)
        }
    }
    
    private func setupBindings() {
        
        keywordSubject
            .subscribe { [weak self] keyword in
                self?.saveSearchLocally(keyword)
            }
            .disposed(by: disposeBag)
        
        keywordSubject.bind(to: searchByTermSubject)
            .disposed(by: disposeBag)
        
        categorySubject.bind(to: searchByCategorySubject)
            .disposed(by: disposeBag)
        
    }
    
    private static func randomizeResult(_ items: [String]?) -> [String] {
        guard let items = items else {
            return []
        }
        let result = [String](items.shuffled().prefix(8))
        return result
    }
    
    private func loadSearchesLocally() -> [String]? {
        return UserDefaults.standard.array(forKey: "OFFLINE_SEARCHES") as? [String]
    }
    
    private func saveSearchLocally(_ keyword: String) {
        let searches = loadSearchesLocally() ?? []
        let newSearches = [keyword] + searches.filter({ item in
            return item.normalized() != keyword.normalized()
        })
        UserDefaults.standard.setValue(newSearches, forKey: "OFFLINE_SEARCHES")
        UserDefaults.standard.synchronize()
    }
    
}
