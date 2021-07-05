import Foundation
import Networking
import RxCocoa
import RxSwift

class FactsViewModel {
    
    struct Output {
        let loading: Observable<Bool>
        let categories: Observable<[String]?>
        let facts: Observable<[FactModel]?>
        let error: Observable<ErrorHandleable>
    }
    
    struct Input {
        let keyword: BehaviorSubject<String?>
        let category: BehaviorSubject<String?>
    }
    
    private let httpClient = HttpClient()
    private let disposeBag = DisposeBag()
    private let activityTracker = PublishRelay<Bool>()
    private let categoriesSubject = PublishRelay<[String]?>()
    private let factsSubject = PublishRelay<[FactModel]?>()
    private let errorSubject = PublishRelay<ErrorHandleable>()
    
    private let keywordSubject = BehaviorSubject<String?>(value: nil)
    private let categorySubject = BehaviorSubject<String?>(value: nil)
    
    public let output: Output!
    public var input: Input!
    
    init() {
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
    
    func fetchFactByCategory(_ category: String? = nil) {
        
        var parameters: [String: String]?
        if let category = category {
            parameters = ["category": category]
        }
        
        fetchFromApi(
            responseType: FactModel.self,
            path: ApiPath.fact,
            parameters: parameters
        ) { [weak self] response in
            if let response = response {
                self?.factsSubject.accept([response])
            } else {
                self?.factsSubject.accept(nil)
            }
        }
    }
    
    private func fetchFactByKeyword(_ query: String) {
        fetchFromApi(
            responseType: SearchResponseModel.self,
            path: ApiPath.search,
            parameters: ["query": query]
        ) { [weak self] response in
            self?.factsSubject.accept(response?.result)
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
        
        Observable
            .zip(input.keyword, input.category)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (keyword, category) in
                self?.fetchByFilters(keyword: keyword, category: category)
            })
            .disposed(by: disposeBag)
        
        fetchCategories()
            
    }
    
    private func fetchByFilters(keyword: String? = nil, category: String? = nil) {
        if let keyword = keyword {
            fetchFactByKeyword(keyword)
        } else if let category = category {
            fetchFactByCategory(category)
        }
    }
    
}
