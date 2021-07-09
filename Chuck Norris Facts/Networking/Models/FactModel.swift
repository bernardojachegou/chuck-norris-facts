import Foundation

struct FactModel: Codable {
    
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

struct SearchResponseModel: Codable {
    let result: [FactModel]
    
    enum CodingKeys: String, CodingKey {
        case result = "result"
    }
}
