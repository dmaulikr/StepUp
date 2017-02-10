import Foundation
import UIKit

// MARK: Reusable protocol

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

// MARK: Collection view extensions

extension UICollectionView {
    func dequeueReusableCell<C: Reusable>(at indexPath: IndexPath) -> C {
        return self.dequeueReusableCell(withReuseIdentifier: C.reuseIdentifier, for: indexPath) as! C
    }
    
    func registerReusableCell<C: UICollectionViewCell>(_: C.Type) where C: Reusable {
        self.register(C.self, forCellWithReuseIdentifier: C.reuseIdentifier)
    }
}
