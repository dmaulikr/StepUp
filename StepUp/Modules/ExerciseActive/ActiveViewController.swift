import UIKit

class ActiveViewController: UIViewController {
    private lazy var intensity: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Licht", "Matig", "Zwaar"])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.tintColor = .baseGreen
        return s
    }()
    
    private lazy var training: UISegmentedControl = {
        let s = UISegmentedControl(items: ["Slecht", "Gemiddeld", "Super"])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.tintColor = .baseGreen
        return s
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyConstraints()
    }
    
    func result() -> AnyExercise<[Int]> {
        return AnyExercise(type: .active, value: [intensity.selectedSegmentIndex,
                                                  training.selectedSegmentIndex,
                                                  fun.selectedSegmentIndex])
    }
    
    private func setup() {
        view.addSubview(titleLabel)
        view.addSubview(intensity)
        view.addSubview(training)
        view.addSubview(fun)
    }
    
    // swiftlint:disable function_body_length
    private func applyConstraints() {
        let views: [String : Any] = ["intensity": intensity,
                     "training": training,
                     "fun": fun,
                     "titleLabel": titleLabel]
        
        var constraints: [NSLayoutConstraint] = []
        
        constraints.append(NSLayoutConstraint(item: titleLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: intensity,
                                                        attribute: .top,
                                                        relatedBy: .equal,
                                                        toItem: titleLabel,
                                                        attribute: .bottom,
                                                        multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: training,
                                                        attribute: .top,
                                                        relatedBy: .equal,
                                                        toItem: intensity,
                                                        attribute: .bottom,
                                                        multiplier: 1, constant: 10))
        constraints.append(NSLayoutConstraint(item: fun,
                                                        attribute: .top,
                                                        relatedBy: .equal,
                                                        toItem: training,
                                                        attribute: .bottom,
                                                        multiplier: 1, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: fun,
                                                        attribute: .bottom,
                                                        relatedBy: .lessThanOrEqual,
                                                        toItem: bottomLayoutGuide,
                                                        attribute: .top,
                                                        multiplier: 1, constant: 30))
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[titleLabel]|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[intensity]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[training]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[fun]-(15)-|",
                                                           options: NSLayoutFormatOptions(rawValue: 0),
                                                           metrics: nil, views: views))
        NSLayoutConstraint.activate(constraints)
    }
    // swiftlint:enable function_body_length
}
