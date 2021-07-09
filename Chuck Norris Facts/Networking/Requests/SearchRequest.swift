import Foundation

class SearchRequest: APIRequest {
    var method = RequestType.GET
    var path = "jokes/search"
    var parameters = [String: String]()

    init(query: String) {
        parameters["query"] = query
    }
}
