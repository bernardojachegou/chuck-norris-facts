import Foundation

class GenericError {

    private let title: String!
    private let message: String!
    private let statusCode: Int!
    public static let generalError = GenericError(
        title: "Failed to load items",
        message: "Failed to load items, verify connection and try again",
        statusCode: 999
    )

    init(title: String, message: String, statusCode: Int) {
        self.title = title
        self.message = message
        self.statusCode = statusCode
    }

    public func getMessage() -> String {
        return message
    }

    public func getTitle() -> String {
        return title
    }

    public func getStatusCode() -> Int {
        return statusCode
    }

}
