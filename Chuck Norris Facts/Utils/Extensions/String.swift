import Foundation

extension String {
    func normalized() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
