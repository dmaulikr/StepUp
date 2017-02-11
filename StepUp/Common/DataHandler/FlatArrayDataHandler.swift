import Foundation

class FlatArrayDataHandler<T: SectionInfo>: DataHandler {
    private var data: [T]
    
    init(data: [T]) {
        self.data = data
    }
    
    convenience init() {
        self.init(data: [T]())
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        let totalSections = numberOfSections()
        guard section < totalSections else {
            fatalError("Section \(section) is greater then \(totalSections)")
        }
        return data[section].rows.count
    }
    
    func numberOfSections() -> Int {
        return data.count
    }
    
    func item(at index: IndexPath) -> T.RowType {
        guard index.row < data[index.section].rows.count else {
            fatalError("Index \(index.row) is out of range \(data[index.section].rows.count)")
        }
        return data[index.section].rows[index.row]
    }
    
    func add(item: T.RowType, at index: IndexPath) {
        guard index.row < data[index.section].rows.count else {
            fatalError("Index \(index.row) is out of range \(data[index.section].rows.count)")
        }
        data[index.section].rows.insert(item, at: index.row)
    }
    
    func remove(item: T.RowType, at index: IndexPath) {
        data[index.section].rows.remove(at: index.row)
    }
    
    public subscript (index: Int) -> T {
        get {
            return data[index]
        }
        set {
            data[index] = newValue
        }
    }

    public subscript (indexPath: IndexPath) -> T.RowType {
        get {
            return data[indexPath.section].rows[indexPath.row]
        }
        set {
            data[indexPath.section].rows[indexPath.row] = newValue
        }
    }
}

