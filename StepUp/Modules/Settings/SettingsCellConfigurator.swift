import Foundation
import UIKit

class SettingCell: UICollectionViewCell, Reusable {
    private lazy var email: EmailView = {
        let v = EmailView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var deleteTreatments: RemoveTreatmentsView = {
        let v = RemoveTreatmentsView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var reminderView: ReminderView = {
        let v = ReminderView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var reminderButtonCallback: (() -> ())?
    var emailButtonCallback: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        applyViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: Setting) {
        reminderView.button.addTarget(self, action: #selector(reminderButtonTapped(sender:)), for: .touchUpInside)
        email.sendButton.addTarget(self, action: #selector(emailButtonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func reminderButtonTapped(sender: UIButton) {
        if let f = reminderButtonCallback {
            f()
        }
    }

    @objc private func emailButtonTapped(sender: UIButton) {
        if let f = emailButtonCallback {
            f()
        }
    }
    
    private func setupViews() {
        contentView.addSubview(email)
        contentView.addSubview(deleteTreatments)
        contentView.addSubview(reminderView)
    }
    
    private func applyViewConstraints() {
        let views: [String: Any] = ["email": email,
                     "deleteTreatments": deleteTreatments,
                     "reminderView": reminderView]
        
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: email,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: contentView,
                                              attribute: .top,
                                              multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: deleteTreatments,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: email,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: reminderView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: deleteTreatments,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: reminderView,
                                              attribute: .bottom,
                                              relatedBy: .lessThanOrEqual,
                                              toItem: contentView,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 40))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[email]-15-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[deleteTreatments]-15-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[reminderView]-15-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        
        NSLayoutConstraint.activate(constraints)
    }
}

class SettingsCellConfigurator: CollectionViewCellConfigurator {
    func configure(using collectionView: UICollectionView,
                   at index: IndexPath,
                   with model: Setting) -> UICollectionViewCell {
        let cell: SettingCell = collectionView.dequeueReusableCell(at: index)
        cell.configure(model: model)
        return cell
    }
}