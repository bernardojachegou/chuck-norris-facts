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
        fetchCategories()
    }
    
    private func fetchFromApi<T: Decodable>(responseType: T.Type, path: Path, parameters: [String: String]? = nil, _ completion: @escaping (T?) -> ()) {
        activityTracker.accept(true)
        httpClient.doGET(
            host: .general,
            toPath: path,
            withHeaders: nil,
            withParameters: parameters,
            responseType: T.self
        ) { [weak self] (error, response) in
            self?.activityTracker.accept(false)
            if let error = error {
                self?.errorSubject.accept(error)
                return
            }
            completion(response)
        }
    }
    
    private func fetchCategories() {
        fetchFromApi(
            responseType: [String].self,
            path: ApiPath.categories
        ) { [weak self] response in
            self?.categoriesSubject.accept(response)
        }
    }
    
    private func setupBindings() {
        
        keywordSubject.bind(to: searchByTermSubject)
            .disposed(by: disposeBag)
        
        categorySubject.bind(to: searchByCategorySubject)
            .disposed(by: disposeBag)
        
        savedSearchesSubject.onNext(["Jesus", "Messi", "Games"])
        
    }
    
    private static func randomizeResult(_ items: [String]?) -> [String] {
        guard let items = items else {
            return []
        }
        let result = [String](items.shuffled().prefix(8))
        return result
    }
    
}
