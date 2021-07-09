import Foundation

struct FactModel: Codable {

    let id: String
    let url: String
    let value: String
    let categories: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case value
        case categories
    }

}

struct SearchResponseModel: Codable {
    let result: [FactModel]

    enum CodingKeys: String, CodingKey {
        case result
    }
}
