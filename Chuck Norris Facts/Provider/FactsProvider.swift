import Foundation
import RxSwift

class FactsProvider {

    enum CacheKey: String {
        case offlineCategories
        case offlineSearches
    }

    private let apiClient: ApiClient!

    init(apiClient: ApiClient? = nil) {
        self.apiClient = apiClient ?? ApiClient()
    }

    public func fetchCategories() -> Observable<[String]> {
        let cacheKey = CacheKey.offlineCategories.rawValue
        if let cachedCategories = getValueFromCache(key: cacheKey, ofType: [String].self) {
            return Observable.of(cachedCategories)
        }
        return apiClient
            .send(apiRequest: CategoriesRequest())
            .retry(2)
    }

    public func fetchSearches() -> Observable<[String]?> {
        return Observable.of(getValueFromCache(key: CacheKey.offlineSearches.rawValue, ofType: [String].self))
    }

    public func saveSearch(keyword: String) {
        let cacheKey = CacheKey.offlineSearches.rawValue
        let searches: [String] = getValueFromCache(key: cacheKey, ofType: [String].self) ?? []
        let newSearches = [keyword] + searches.filter({ item in
            return item.normalized() != keyword.normalized()
        })
        saveValueOnCache(key: cacheKey, value: newSearches)
    }

    public func saveCategories(categories: [String]) {
        saveValueOnCache(key: CacheKey.offlineCategories.rawValue, value: categories)
    }

    public func searchForFacts(query: String) -> Observable<SearchResponseModel> {
        return apiClient.send(apiRequest: SearchRequest(query: query)).retry(2)
    }
}

extension FactsProvider {
    private func getValueFromCache<T>(key: String, ofType type: T.Type) -> T? {
        UserDefaults.standard.synchronize()
        return UserDefaults.standard.value(forKey: key) as? T
    }

    private func saveValueOnCache(key: String, value: Any?) {
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }

    private func fetchFromCache<T>(key: CacheKey, ofType type: T.Type, _ completion: @escaping (GenericError?, T?) -> Void) {
        if let value = getValueFromCache(key: key.rawValue, ofType: type) {
            completion(nil, value)
        } else {
            completion(GenericError(title: "Not in cache", message: "Value requested not cached", statusCode: 404), nil)
        }
    }
}
