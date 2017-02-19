import Foundation
import UIKit

class TreatmentCell: UICollectionViewCell, Reusable {
    private lazy var title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        l.textAlignment = .center
        l.font = UIFont.regular(withSize: 20)
        return l
    }()
    
    private lazy var info: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        l.numberOfLines = 0
        l.textAlignment = .center
        l.font = UIFont.light(withSize: 18)
        return l
    }()
    
    private lazy var start: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.regular(withSize: 18)
        b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        b.setTitle("Start behandeling", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(.buttonDisabled, for: .highlighted)
        b.backgroundColor = .treamentButtonBackground
        b.layer.cornerRadius = 7
        return b
    }()
    
    private lazy var wrapperView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private var treatmentNumber: Int?
    
    var buttonTappedCallBack: ((_ number: Int) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with item: Treatment) {
        title.text = item.title
        info.text = item.description
        treatmentNumber = item.number
        start.addTarget(self, action: #selector(startButtonTapped(sender:)), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonTappedCallBack = nil
    }
    
    @objc private func startButtonTapped(sender: UIButton) {
        if let f = buttonTappedCallBack, let number = treatmentNumber {
            f(number)
        }
    }
    
    private func setup() {
        wrapperView.addSubview(title)
        wrapperView.addSubview(info)
        wrapperView.addSubview(start)
        contentView.addSubview(wrapperView)
    }
    
    private func applyConstraints() {
        let views = ["title": title,
                     "info": info,
                     "start": start,
                     "wrapperView": wrapperView]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[wrapperView]-20-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[wrapperView]-30-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[title]|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[info]|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[start]-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        let visualFormat = "V:|[title]-[info]-(>=10)-[start]-(==40)-|"
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
    }
}

// MARK: Collection view cell configurator

class MixedCellConfigurator: CollectionViewCellConfigurator, UsesHomeViewModel {
    internal unowned let homeViewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        homeViewModel = viewModel
    }
    
    func configure(using collectionView: UICollectionView,
                   at index: IndexPath,
                   with model: MixedEntity) -> UICollectionViewCell {
        switch model {
        case let .treatment(t):
            let cell: TreatmentCell = collectionView.dequeueReusableCell(at: index)
            cell.configure(with: t)
            cell.buttonTappedCallBack = { [weak self] number in
                self?.homeViewModel.presentTreatment(weekNumber: number)
            }
            return cell
        case let .setting(s):
            let cell: SettingCell = collectionView.dequeueReusableCell(at: index)
            cell.configure(model: s)
            cell.reminderButtonCallback = { [weak self] in
                self?.homeViewModel.getReminderSettings()
            }
            cell.emailButtonCallback = { [weak self] email, name in
                self?.homeViewModel.getTreatmentResults(email: email, name: name)
            }
            cell.deleteButtonCallback = { [weak self] in
                self?.homeViewModel.promptForExercisesRemoval()
            }
            return cell
        }
    }
}
