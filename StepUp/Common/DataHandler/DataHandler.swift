import Foundation

protocol DataHandler {
    associatedtype DataType
    
    func numberOfItems(inSection section: Int) -> Int
    func numberOfSections() -> Int
    func item(at index: IndexPath) -> DataType
    func add(item: DataType, at: IndexPath)
    func add(item: DataType)
    func remove(item: DataType, at index: IndexPath)
}
