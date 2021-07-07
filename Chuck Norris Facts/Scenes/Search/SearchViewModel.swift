import Foundation
import Networking
import RxCocoa
import RxSwift

class SearchViewModel {
    
    struct Output {
        let categories: Observable<[String]?>
        let savedSearches: Observable<[String]?>
    }
    
    struct Input {
        let keyword: BehaviorSubject<String?>
    }
    
    private let httpClient = HttpClient()
    private let disposeBag = DisposeBag()
    private let activityTracker = PublishRelay<Bool>()
    private let categoriesSubject = PublishRelay<[String]?>()
    private let errorSubject = PublishRelay<ErrorHandleable>()
    
    private let savedSearchesSubject = BehaviorSubject<[String]?>(value: nil)
    private let keywordSubject = BehaviorSubject<String?>(value: nil)
    
    public let output: Output!
    public var input: Input!
    
    init() {
        output = Output(
            categories: categoriesSubject.asObservable(),
            savedSearches: savedSearchesSubject.asObservable()
        )
        
        input = Input(
            keyword: keywordSubject
        )
        
        setupBindings()
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
        fetchCategories()
        
        let searches = ["messi", "pope", "covid vaccine"]
        savedSearchesSubject.onNext(searches)
    }
    
}
