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
    
    private let provider: FactsProvider!
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
    
    init(provider: FactsProvider? = nil) {
        self.provider = provider ?? FactsProvider()
        
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
        
        provider.fetchCategories { [weak self] (error, response) in
            self?.categoriesSubject.accept(response)
        }
    }
    
    public func fetchSavedSearches() {
        provider.fetchSearches { [weak self] (error, response) in
            self?.savedSearchesSubject.onNext(response)
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
    
    private func saveSearchLocally(_ keyword: String) {
        provider.saveSearch(keyword: keyword)
    }
    
}
