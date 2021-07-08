import Foundation
import Networking
import RxCocoa
import RxSwift

class FactsViewModel {
    
    struct Output {
        let loading: Observable<Bool>
        let categories: Observable<[String]?>
        let facts: Observable<[FactModel]?>
        let error: Observable<GenericError>
    }
    
    struct Input {
        let keyword: BehaviorSubject<String?>
        let category: BehaviorSubject<String?>
    }
    
    private let provider: FactsProvider!
    private let disposeBag = DisposeBag()
    private let activityTracker = PublishRelay<Bool>()
    private let categoriesSubject = PublishRelay<[String]?>()
    private let factsSubject = PublishRelay<[FactModel]?>()
    private let errorSubject = PublishRelay<GenericError>()
    
    private let keywordSubject = BehaviorSubject<String?>(value: nil)
    private let categorySubject = BehaviorSubject<String?>(value: nil)
    
    public let output: Output!
    public var input: Input!
    
    init(provider: FactsProvider? = nil) {
        self.provider = provider ?? FactsProvider()
        
        output = Output(
            loading: activityTracker.asObservable(),
            categories: categoriesSubject.asObservable(),
            facts: factsSubject.asObservable(),
            error: errorSubject.asObservable()
        )
        
        input = Input(
            keyword: keywordSubject,
            category: categorySubject
        )
        
        setupBindings()
        fetchCategories()
    }
    
    private func fetchFactByKeyword(_ query: String) {
        activityTracker.accept(true)
        provider.searchForFacts(query: query) { [weak self] (error, response) in
            self?.factsSubject.accept(response?.result)
            self?.activityTracker.accept(false)
        }
    }
    
    private func fetchCategories() {
        activityTracker.accept(true)
        provider.fetchCategories() { [weak self] (error, response) in
            self?.activityTracker.accept(false)
        }
    }
    
    private func setupBindings() {
        
        keywordSubject
            .subscribe { [weak self] keyword in
                self?.fetchByFilters(keyword: keyword)
            }
            .disposed(by: disposeBag)
        
        categorySubject
            .subscribe { [weak self] category in
                self?.fetchByFilters(keyword: category)
            }
            .disposed(by: disposeBag)

    }
    
    private func fetchByFilters(keyword: String? = nil) {
        guard let keyword = keyword else {
            return
        }
        fetchFactByKeyword(keyword)
    }
    
}
