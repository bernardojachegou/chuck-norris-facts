import Foundation

struct FactModel: Decodable {
    
    let id: String
    let url: String
    let value: String
    let categories: [String]
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case url = "url"
        case value = "value"
        case categories = "categories"
    }
    
}

struct SearchResponseModel: Decodable {
    let result: [FactModel]
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}
