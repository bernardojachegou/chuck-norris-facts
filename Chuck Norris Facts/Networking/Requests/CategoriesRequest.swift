import Foundation

class CategoriesRequest: APIRequest {
    var parameters: [String : String] = [:]
    var method = RequestType.GET
    var path = "jokes/categories"
}
