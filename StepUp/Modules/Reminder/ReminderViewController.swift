import UIKit

class ReminderViewController: UIViewController, ReminderViewOutput, UsesReminderViewModel {
    internal let reminderViewModel: ReminderViewModel
    
    private lazy var descriptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.light(withSize: 14)
        l.textAlignment = .center
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        var text = "Stel hier een reminder in.\nOp het ingestelde tijdstip"
        text += " ontvang je elke dag een reminder voor je oefeningen."
        l.text = text
        l.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        return l
    }()
    
    private lazy var switchOnOff: UISwitch = {
        let s = UISwitch()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.setContentCompressionResistancePriority(UILayoutPriorityDefaultHigh, for: .horizontal)
        s.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
        return s
    }()
    
    private lazy var timePicker: UIDatePicker = {
        let p = UIDatePicker()
        p.translatesAutoresizingMaskIntoConstraints = false
        p.datePickerMode = UIDatePickerMode.time
        p.isEnabled = false
        return p
    }()
    
    init(viewModel: ReminderViewModel) {
        reminderViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        reminderViewModel.setModel(output: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        applyViewConstraints()
    }
    
    // MARK: view output
    
    func showReminder() {
        
    }
    
    func pop() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func switchChanged(sender: UISwitch) {
        timePicker.isEnabled = sender.isOn
    }
    
    @objc private func cancel(sender: UIBarButtonItem) {
        reminderViewModel.cancel()
    }
    
    @objc private func save(sender: UIBarButtonItem) {
        reminderViewModel.save()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(descriptionLabel)
        view.addSubview(switchOnOff)
        view.addSubview(timePicker)
        
        let leftButton = UIBarButtonItem(title: "Annuleren",
                                         style: .plain,
                                         target: self,
                                         action: #selector(cancel(sender:)))
        leftButton.tintColor = .cancelAction
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "Opslaan",
                                          style: .done,
                                          target: self,
                                          action: #selector(save(sender:)))
        rightButton.tintColor = .actionGreen
        navigationItem.rightBarButtonItem = rightButton
    }
    
    private func applyViewConstraints() {
        let views: [String: Any] = ["descriptionLabel": descriptionLabel,
                     "switchOnOff": switchOnOff,
                     "timePicker": timePicker]
        var constraints: [NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: descriptionLabel,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: topLayoutGuide,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        constraints.append(NSLayoutConstraint(item: switchOnOff,
                                              attribute: .centerY,
                                              relatedBy: .equal,
                                              toItem: descriptionLabel,
                                              attribute: .centerY,
                                              multiplier: 1, constant: 0))
        constraints.append(NSLayoutConstraint(item: timePicker,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: descriptionLabel,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 10))
        NSLayoutConstraint.activate(constraints)
        let vsl = "H:|-15-[descriptionLabel]-8-[switchOnOff]-15-|"
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: vsl,
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[timePicker]-15-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        
    }
    
}
