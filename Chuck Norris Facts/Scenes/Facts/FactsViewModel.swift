import Foundation
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
    private let activityTracker = ActivityIndicator()
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
        provider.searchForFacts(query: query)
            .trackActivity(activityTracker)
            .map { $0.result }
            .catch({ [weak self] error in
                self?.errorSubject.accept(GenericError.generalError)
                return .empty()
            })
            .bind(to: factsSubject)
            .disposed(by: disposeBag)
    }
    
    private func fetchCategories() {
        provider.fetchCategories()
            .trackActivity(activityTracker)
            .catch({ [weak self] error in
                self?.errorSubject.accept(GenericError.generalError)
                return .empty()
            })
            .subscribe(onNext: { [weak self] categories in
                self?.provider.saveCategories(categories: categories)
            })
            .disposed(by: disposeBag)
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
