import Foundation
import Networking

class FactsProvider {
    
    enum CacheKey: String {
        case OfflineCategories
        case OfflineSearches
    }
    
    private let httpClient: HttpClient!
    
    init(httpClient: HttpClient? = nil) {
        self.httpClient = httpClient ?? HttpClient()
    }
    
    public func fetchCategories(_ completion: @escaping (GenericError?, [String]?) -> ()) {
        fetchFromCache(key: .OfflineCategories, ofType: [String].self) { [weak self] (error, response) in
            if error != nil {
                self?.fetchFromApi(responseType: [String].self, path: ApiPath.categories, completion)
            } else {
                completion(error, response)
            }
        }
    }
    
    public func fetchSearches(_ completion: @escaping (GenericError?, [String]?) -> ()) {
        fetchFromCache(key: .OfflineSearches, ofType: [String].self) { (error, response) in
            completion(error, response)
        }
    }
    
    public func saveSearch(keyword: String) {
        let cacheKey = CacheKey.OfflineSearches.rawValue
        let searches: [String] = getValueFromCache(key: cacheKey, ofType: [String].self) ?? []
        let newSearches = [keyword] + searches.filter({ item in
            return item.normalized() != keyword.normalized()
        })
        saveValueOnCache(key: cacheKey, value: newSearches)
    }
    
    public func searchForFacts(query: String, _ completion: @escaping (GenericError?, SearchResponseModel?) -> ()) {
        fetchFromApi(
            responseType: SearchResponseModel.self,
            path: ApiPath.search,
            parameters: ["query": query]
        ) { (error, response) in
            completion(error, response)
        }
    }
    
}


extension FactsProvider {
    private func fetchFromApi<T: Decodable>(responseType: T.Type, path: Path, parameters: [String: String]? = nil, _ completion: @escaping (GenericError?, T?) -> ()) {
        httpClient.doGET(
            host: .general,
            toPath: path,
            withHeaders: nil,
            withParameters: parameters,
            responseType: T.self
        ) { (error, response) in
            completion(nil, response)
        }
    }
    
    private func getValueFromCache<T>(key: String, ofType type: T.Type) -> T? {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.value(forKey: key) as? T
    }
    
    private func saveValueOnCache(key: String, value: Any?) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    private func fetchFromCache<T>(key: CacheKey, ofType type: T.Type, _ completion: @escaping (GenericError?, T?) -> ()) {
        if let value = getValueFromCache(key: key.rawValue, ofType: type) {
            completion(nil, value)
        } else {
            completion(GenericError(title: "Not in cache", message: "Value requested not cached"), nil)
        }
    }
}
