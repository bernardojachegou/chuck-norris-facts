import Foundation
import RxSwift

class ApiClient {
    private let baseURL = URL(string: "https://api.chucknorris.io/")!
    private let timeoutInSeconds: TimeInterval = 4

    func send<T: Codable>(apiRequest: APIRequest) -> Observable<T> {
        let request = apiRequest.request(with: baseURL)
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeoutInSeconds
        config.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: config).rx.data(request: request)
            .map { try JSONDecoder().decode(T.self, from: $0) }
            .observe(on: MainScheduler.asyncInstance)
    }
}
