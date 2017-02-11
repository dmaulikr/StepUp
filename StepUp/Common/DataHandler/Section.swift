import Foundation

protocol SectionInfo {
    associatedtype RowType
    var title: String { get }
    var rows: [RowType] { get set }
}

struct Section<T: Equatable>: SectionInfo {
    let title: String
    var rows: [T]
    
    init(title: String, rows: T...) {
        self.rows = rows
        self.title = title
    }
    
    public subscript (index: Int) -> T {
        get {
            return rows[index]
        }
        set {
            rows[index] = newValue
        }
    }
}

extension Section: Equatable {
    static func ==<T>(lhs: Section<T>, rhs: Section<T>) -> Bool {
        return lhs.title == rhs.title &&
            lhs.rows == rhs.rows
    }
}
