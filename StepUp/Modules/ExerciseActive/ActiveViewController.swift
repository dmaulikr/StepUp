import UIKit
import App

class ActiveViewController: UIViewController, ExerciseResult {
    
    private lazy var intensityLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.regular(withSize: 14)
        l.textAlignment = .left
        l.text = "Intensiteit"
        return l
    }()
    
    private lazy var intensity: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Licht", "Matig", "Zwaar"])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.tintColor = .baseGreen
        return s
    }()
    
    
    private lazy var trainingLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.regular(withSize: 14)
        l.textAlignment = .left
        l.text = "De training ging"
        return l
    }()
    
    private lazy var training: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Slecht", "Gemiddeld", "Super"])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.tintColor = .baseGreen
        return s
    }()
    
    private lazy var funLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.regular(withSize: 14)
        l.textAlignment = .left
        l.text = "Plezier"
        return l
    }()
    
    private lazy var fun: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Weinig", "Gemiddeld", "Veel"])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.tintColor = .baseGreen
        return s
    }()
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.regular(withSize: 20)
        l.textAlignment = .center
        l.text = "Bewegen"
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
        configure()
    }
    
    func result() -> Exercise {
        return ExerciseActive(value: [intensity.selectedSegmentIndex,
                                                  training.selectedSegmentIndex,
                                                  fun.selectedSegmentIndex],
                              weekDay: exercise.weekDay, weekNr: exercise.weekNr)
    }
    
    private func configure() {
        guard let e = exercise as? ExerciseActive,
            e.value.count > 2 else { return }
        intensity.selectedSegmentIndex = e.value[0]
        training.selectedSegmentIndex = e.value[1]
        fun.selectedSegmentIndex = e.value[2]
    }
    
    private func setup() {
        view.addSubview(titleLabel)
        view.addSubview(intensityLabel)
        view.addSubview(intensity)
        view.addSubview(trainingLabel)
        view.addSubview(training)
        view.addSubview(funLabel)
        view.addSubview(fun)
    }
    
    // swiftlint:disable function_body_length
    private func applyConstraints() {
        let views: [String : Any] = ["intensity": intensity,
                     "training": training,
                     "fun": fun,
                     "titleLabel": titleLabel,
                     "intensityLabel": intensityLabel,
                     "trainingLabel": trainingLabel,
                     "funLabel": funLabel]
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: intensityLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: titleLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        constraints.append(NSLayoutConstraint(item: intensity,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: intensityLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 5))
        
        constraints.append(NSLayoutConstraint(item: trainingLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: intensity,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        constraints.append(NSLayoutConstraint(item: training,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: trainingLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 5))
        
        constraints.append(NSLayoutConstraint(item: funLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: training,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        constraints.append(NSLayoutConstraint(item: fun,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: funLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 5))
        constraints.append(NSLayoutConstraint(item: fun,
                                              attribute: .bottom,
                                              relatedBy: .lessThanOrEqual,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1, constant: 30))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[intensityLabel]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[intensity]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[trainingLabel]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[training]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[funLabel]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[fun]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)
    }
    // swiftlint:enable function_body_length
}
