import Foundation

struct Treatment {
    let title: String
    let description: String
    let number: Int
}

extension Treatment: Equatable {
    static func == (lhs: Treatment, rhs: Treatment) -> Bool {
            return lhs.title == rhs.title &&
                lhs.description == rhs.description &&
                lhs.number == rhs.number
    }
}
