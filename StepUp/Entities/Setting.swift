import Foundation

struct Setting {
    let email: String
    let name: String
}

extension Setting: Equatable {
    static func == (lhs: Setting, rhs: Setting) -> Bool {
        return lhs.email == rhs.email &&
            lhs.name == rhs.name
    }
}
