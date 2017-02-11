import UIKit

class DayScheduleCell: UICollectionViewCell, Reusable {
    private lazy var title: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .black
        l.textAlignment = .center
        l.font = UIFont.regular(withSize: 20)
        return l
    }()
    
    lazy var active: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.regular(withSize: 14)
        b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        b.setTitle("Bewegen", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(.buttonDisabled, for: .highlighted)
        b.backgroundColor = .treamentButtonBackground
        b.layer.cornerRadius = 7
        return b
    }()
    
    lazy var mindfulness: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.regular(withSize: 14)
        b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        b.setTitle("Mindfulness", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(.buttonDisabled, for: .highlighted)
        b.backgroundColor = .treamentButtonBackground
        b.layer.cornerRadius = 7
        return b
    }()
    
    lazy var positive: UIButton = {
        let b = UIButton(type: .custom)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.titleLabel?.font = UIFont.regular(withSize: 14)
        b.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        b.setTitle("Positief", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.setTitleColor(.buttonDisabled, for: .highlighted)
        b.backgroundColor = .treamentButtonBackground
        b.layer.cornerRadius = 7
        return b
    }()
    
    private lazy var wrapperView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var buttonWrapperView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var buttonTappedCallBack: ((_ exercise: ExerciseType) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        applyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with item: DaySchedule) {
        title.text = item.title
        setup(excerises: item.exercises)
        
        if item.exercises.contains(.active) {
            active.addTarget(self, action: #selector(actionTapped(sender:)), for: .touchUpInside)
        }
        if item.exercises.contains(.mindfulness) {
            mindfulness.addTarget(self, action: #selector(mindfulnessTapped(sender:)), for: .touchUpInside)
        }
        if item.exercises.contains(.positive) {
            positive.addTarget(self, action: #selector(positiveTapped(sender:)), for: .touchUpInside)
        }
    }
    
    @objc private func actionTapped(sender: UIButton) {
        callButtonCallbackBlock(exerciseType: .active)
    }
    
    @objc private func mindfulnessTapped(sender: UIButton) {
        callButtonCallbackBlock(exerciseType: .mindfulness)
    }
    
    @objc private func positiveTapped(sender: UIButton) {
        callButtonCallbackBlock(exerciseType: .positive)
    }
    
    private func callButtonCallbackBlock(exerciseType: ExerciseType) {
        if let f = buttonTappedCallBack {
            f(exerciseType)
        }
    }
    
    // swiftlint:disable line_length
    private func setup(excerises: [ExerciseType]) {
        for v in buttonWrapperView.subviews { v.removeFromSuperview() }
        var previous: UIView = buttonWrapperView
        var constraints: [NSLayoutConstraint] = []
        for exc in excerises {
            switch exc {
            case .active:
                buttonWrapperView.addSubview(active)
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[active]-15-|",
                                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                                           metrics: nil, views: ["active": active]))
                constraints.append(NSLayoutConstraint(item: active, attribute: .top, relatedBy: .equal, toItem: buttonWrapperView, attribute: .top, multiplier: 1, constant: 7))
            
                previous = active
            case .mindfulness:
                buttonWrapperView.addSubview(mindfulness)
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[mindfulness]-15-|",
                                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                                           metrics: nil, views: ["mindfulness": mindfulness]))
                constraints.append(NSLayoutConstraint(item: mindfulness, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: 7))
    
                previous = mindfulness
            case .positive:
                buttonWrapperView.addSubview(positive)
                NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[positive]-15-|",
                                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                                           metrics: nil, views: ["positive": positive]))
                constraints.append(NSLayoutConstraint(item: positive, attribute: .top, relatedBy: .equal, toItem: previous, attribute: .bottom, multiplier: 1, constant: 7))
            
                previous = positive
            }
        }
        constraints.append(NSLayoutConstraint(item: previous, attribute: .bottom, relatedBy: .lessThanOrEqual, toItem: buttonWrapperView, attribute: .bottom, multiplier: 1, constant: 0))
        NSLayoutConstraint.activate(constraints)
    }
    // swiftlint:enable line_length
    
    private func setup() {
        contentView.addSubview(wrapperView)
        wrapperView.addSubview(title)
        wrapperView.addSubview(buttonWrapperView)
    }
    
    // swiftlint:disable line_length
    private func applyConstraints() {
        let views: [String : Any] = ["title": title,
                                    "wrapperView": wrapperView,
                                    "buttonWrapperView": buttonWrapperView]
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[wrapperView]-10-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[buttonWrapperView]|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[wrapperView]-10-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|[title]|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(<=30)-[title]-[buttonWrapperView]-(>=50)-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
    }
    // swiftlint:enable line_length
}

class WeekScheduleCellConfiguration: CollectionViewCellConfigurator,
                                                  UsesWeekScheduleViewModel {
    
    internal unowned let weekScheduleViewModel: WeekScheduleViewModel
    
    init(viewModel: WeekScheduleViewModel) {
        weekScheduleViewModel = viewModel
    }
    
    func configure(using collectionView: UICollectionView,
                   at index: IndexPath,
                   with model: DaySchedule) -> UICollectionViewCell {
        let cell: DayScheduleCell = collectionView.dequeueReusableCell(at: index)
        cell.configure(with: model)
        cell.buttonTappedCallBack = { [weak self] type in
            self?.weekScheduleViewModel.present(exerciseWithType: type, fromDaySchedule: model)
        }
        return cell
    }
    
   
}
