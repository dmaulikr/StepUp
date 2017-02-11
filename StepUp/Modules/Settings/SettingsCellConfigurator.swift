import Foundation
import UIKit

class SettingCell: UICollectionViewCell, Reusable {
    private lazy var title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        applyViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Setting) {
        title.text = model.email
    }
    
    private func setupViews() {
        contentView.addSubview(title)
    }
    
    private func applyViewConstraints() {
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: title,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: contentView,
                                              attribute: .top,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: title,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: contentView,
                                              attribute: .width,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: title,
                                              attribute: .bottom,
                                              relatedBy: .lessThanOrEqual,
                                              toItem: contentView,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        NSLayoutConstraint.activate(constraints)
    }
}

class SettingsCellConfigurator<T: Reusable>: CollectionViewCellConfigurator {
    func configure(using collectionView: UICollectionView,
                   at index: IndexPath,
                   with model: Setting) -> UICollectionViewCell {
        let cell: SettingCell = collectionView.dequeueReusableCell(at: index)
        return cell
    }
}
