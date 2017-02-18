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
        p.addTarget(self, action: #selector(pickerChanged(sender:)), for: UIControlEvents.valueChanged)
        return p
    }()
    
    
    private lazy var noPushMessage: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .buttonDisabled
        l.font = UIFont.light(withSize: 14)
        l.textAlignment = .center
        l.numberOfLines = 0
        l.lineBreakMode = .byWordWrapping
        var text = "Om een reminder in te stellen, heeft StepUp! Push permissies nodig."
        text += " Deze kun je aanzetten bij Instelligen > StepUp!"
        l.text = text
        l.setContentCompressionResistancePriority(UILayoutPriorityDefaultLow, for: .horizontal)
        l.isHidden = true
        return l
    }()
    
    init(viewModel: ReminderViewModel) {
        reminderViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        reminderViewModel.setModel(output: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        applyViewConstraints()
        registerForAppActivationNotification()
        reminderViewModel.start()
    }
    
    // MARK: view output
    
    func showReminder(_ date: Date) {
        timePicker.date = date
    }
    
    func pop() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func timePicker(enabled: Bool) {
        timePicker.isEnabled = enabled
    }
    
    func controlSwitch(on: Bool) {
        switchOnOff.isOn = on
    }
    
    func showNoPushMessage() {
        noPushMessage.isHidden = false
    }
    
    // MARK: view controller helper
    
    @objc func switchChanged(sender: UISwitch) {
        reminderViewModel.pushTryTo(enabled: sender.isOn, theDate: timePicker.date)
    }
    
    @objc private func cancel(sender: UIBarButtonItem) {
        reminderViewModel.cancel()
    }
    
    @objc private func pickerChanged(sender: UIDatePicker) {
        reminderViewModel.save(theDate: sender.date, pushEnabled: switchOnOff.isOn)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(descriptionLabel)
        view.addSubview(switchOnOff)
        view.addSubview(timePicker)
        view.addSubview(noPushMessage)
        
        let leftButton = UIBarButtonItem(title: "Sluiten",
                                         style: .plain,
                                         target: self,
                                         action: #selector(cancel(sender:)))
        leftButton.tintColor = .actionGreen
        navigationItem.leftBarButtonItem = leftButton
    }
    
    private func applyViewConstraints() {
        let views: [String: Any] = ["descriptionLabel": descriptionLabel,
                     "switchOnOff": switchOnOff,
                     "timePicker": timePicker,
                     "noPushMessage": noPushMessage]
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
        constraints.append(NSLayoutConstraint(item: noPushMessage,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: timePicker,
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
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[noPushMessage]-15-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil, views: views))
        
    }
    
    private func registerForAppActivationNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appBecomeActive(notification:)),
                                               name: .UIApplicationWillEnterForeground,
                                               object: nil)
    }
    
    @objc private func appBecomeActive(notification: Notification) {
        reminderViewModel.start()
    }
}
