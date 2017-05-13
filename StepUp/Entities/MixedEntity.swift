import Foundation

enum MixedEntity {
    case setting(Setting)
    case treatment(Treatment)

    func entity() -> Setting? {
        if case let .setting(s) = self {
            return s
        }
        return nil
    }

    func entity() -> Treatment? {
        if case let .treatment(t) = self {
            return t
        }
        return nil
    }
}

extension MixedEntity: Equatable {
    static func == (lhs: MixedEntity, rhs: MixedEntity) -> Bool {
        switch (lhs, rhs) {
        case (.setting(let a), .setting(let b))   where a == b: return true
        case (.treatment(let a), .treatment(let b)) where a == b: return true
        default: return false
        }
    }
}
