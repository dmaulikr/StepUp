import Foundation

class ArrayDataHandler<T>: DataHandler {
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
        return data.count
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func item(at index: IndexPath) -> T {
        guard index.row < data.count else {
            fatalError("Index \(index.row) is out of range \(data.count)")
        }
        return data[index.row]
    }
    
    func add(item: T, at index: IndexPath) {
        guard index.row < data.count else {
            fatalError("Index \(index.row) is out of range \(data.count)")
        }
        data.insert(item, at: index.row)
    }
    
    func add(item: T) {
        data.append(item)
    }
    
    func remove(item: T, at index: IndexPath) {
        data.remove(at: index.row)
    }
}
