import UIKit
import App

class PositiveViewController: UIViewController, ExerciseResult {
    private lazy var labelOne: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "1:"
        l.textColor = .darkGray
        l.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        return l
    }()
    
    private lazy var one: UITextField = {
        let s = UITextField()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.borderStyle = UITextBorderStyle.roundedRect
        return s
    }()
    
    private lazy var labelTwo: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "2:"
        l.textColor = .darkGray
        l.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        return l
    }()
    
    private lazy var two: UITextField = {
        let s = UITextField()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.borderStyle = UITextBorderStyle.roundedRect
        return s
    }()
    
    private lazy var labelThree: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "3:"
        l.textColor = .darkGray
        l.setContentHuggingPriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        return l
    }()
    
    private lazy var three: UITextField = {
        let s = UITextField()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.borderStyle = UITextBorderStyle.roundedRect
        return s
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.regular(withSize: 20)
        l.textAlignment = .center
        l.text = "3 Positieve dingen"
        return l
    }()
    
    private let exercise: Exercise
    
    init(exercise: Exercise) {
        self.exercise = exercise
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyConstraints()
    }
    
    func result() -> Exercise {
        return ExercisePositive(type: .positive,
                                value: [one.text ?? "",
                                        two.text ?? "",
                                        three.text ?? ""],
                                weekDay: exercise.weekDay, weekNr: exercise.weekNr)
    }
    
    private func setup() {
        view.addSubview(titleLabel)
        view.addSubview(labelOne)
        view.addSubview(one)
        view.addSubview(labelTwo)
        view.addSubview(two)
        view.addSubview(labelThree)
        view.addSubview(three)
    }
    
    // swiftlint:disable function_body_length
    private func applyConstraints() {
        let views: [String : Any] = ["one": one,
                                     "two": two,
                                     "three": three,
                                     "titleLabel": titleLabel,
                                     "labelOne": labelOne,
                                     "labelTwo": labelTwo,
                                     "labelThree": labelThree]
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: one,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: titleLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: labelOne,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: one,
                                              attribute: .centerY,
                                              multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: two,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: one,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: labelTwo,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: two,
                                              attribute: .centerY,
                                              multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: three,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: two,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: labelThree,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: three,
                                              attribute: .centerY,
                                              multiplier: 1, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: three,
                                              attribute: .bottom,
                                              relatedBy: .lessThanOrEqual,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1, constant: 30))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[labelOne(==labelTwo)]-(5)-[one]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[labelTwo(==labelThree)]-(5)-[two]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[labelThree]-(5)-[three]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        
        NSLayoutConstraint.activate(constraints)
    }
    // swiftlint:enable function_body_length
}
