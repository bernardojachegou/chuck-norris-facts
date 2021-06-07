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
    
    private let httpClient = HttpClient()
    private let activityTracker = PublishRelay<Bool>()
    private let categoriesSubject = PublishRelay<[String]?>()
    private let factsSubject = PublishRelay<[FactModel]?>()
    private let errorSubject = PublishRelay<ErrorHandleable>()
    
    public let output: Output!
    
    init() {
        output = Output(
            loading: activityTracker.asObservable(),
            categories: categoriesSubject.asObservable(),
            facts: factsSubject.asObservable(),
            error: errorSubject.asObservable()
        )
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
    
    func fetchFactByCategory(_ category: String) {
        fetchFromApi(
            responseType: FactModel.self,
            path: ApiPath.fact,
            parameters: ["category": category]
        ) { [weak self] response in
            if let response = response {
                self?.factsSubject.accept([response])
            } else {
                self?.factsSubject.accept(nil)
            }
        }
    }
    
    func fetchFactByKeyword(_ query: String) {
        fetchFromApi(
            responseType: SearchResponseModel.self,
            path: ApiPath.search,
            parameters: ["query": query]
        ) { [weak self] response in
            self?.factsSubject.accept(response?.result)
        }
    }
    
    func fetchCategories() {
        fetchFromApi(
            responseType: [String].self,
            path: ApiPath.categories
        ) { [weak self] response in
            self?.categoriesSubject.accept(response)
        }
    }
    
}
