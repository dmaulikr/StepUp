import Foundation
import App

protocol ReminderViewOutput: class {
    func showReminder(_ date: Date)
    func pop()
    func timePicker(enabled: Bool)
    func controlSwitch(on: Bool)
    func showNoPushMessage()
}

protocol ReminderViewModel {
    func setModel(output: ReminderViewOutput)
    func start()
    func save(theDate: Date, pushEnabled enabled: Bool)
    func cancel()
    func pushTryTo(enabled: Bool, theDate date: Date)
}

protocol UsesReminderViewModel {
    var reminderViewModel: ReminderViewModel { get }
}

class MixinReminderViewModel: ReminderViewModel, UsesNotificationService {
    let pushStateKey = "PushStateKey"
    let reminderHourKey = "ReminderHourKey"
    let reminderMinuteKey = "ReminderMinuteKey"
    private weak var output: ReminderViewOutput?
    internal let notificationService: NotificationService
    
    init() {
        notificationService = MixinNotificationService()
    }
    
    func start() {
        let reminderDate = getReminderDate()
        let pushState = getPushState()
        output?.controlSwitch(on: pushState)
        output?.timePicker(enabled: pushState)
        enablePushScheduling(withDate: reminderDate, pushEnabled: pushState)
        output?.showReminder(reminderDate)
    }
    
    func setModel(output: ReminderViewOutput) {
        self.output = output
    }
    
    func save(theDate date: Date, pushEnabled enabled: Bool) {
        if enabled {
            setReminder(withDate: date)
        } else {
            cleanDefaults()
        }
    }
    
    func cancel() {
        output?.pop()
    }
    
    func pushTryTo(enabled: Bool, theDate date: Date) {
        storePushState(enabled: enabled)
        if enabled {
            enablePushScheduling(withDate: date, pushEnabled: enabled)
        } else {
            output?.timePicker(enabled: false)
            cleanDefaults()
        }
    }
    
    private func setReminder(withDate date: Date) {
        let title = "StepUp! Tijd voor je oefeningen"
        let body = "Het is tijd voor je oefeningen."

        let todayInterval = date.timeIntervalSinceNow
        if todayInterval > 0 {
            notificationService.scheduleLocalNotification(title: title,
                                                      body: body,
                                                      at: todayInterval < 60 ? 60 : todayInterval,
                                                      withIdentifier: "stepup-today",
                                                      repeats: false)
        }
    
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: date) else { return }
        let interval: TimeInterval = tomorrow.timeIntervalSinceNow
        
        notificationService.scheduleLocalNotification(title: title,
                                                      body: body,
                                                      at: interval,
                                                      withIdentifier: "stepup-repeating",
                                                      repeats: true)
        storeReminder(createReminder(fromDate: date))
    }
    
    private func storePushState(enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: pushStateKey)
    }
    
    private func getPushState() -> Bool {
        return UserDefaults.standard.bool(forKey: pushStateKey)
    }
    
    private func storeReminder(_ reminder: Reminder) {
        UserDefaults.standard.set(reminder.hour, forKey: reminderHourKey)
        UserDefaults.standard.set(reminder.minute, forKey: reminderMinuteKey)
    }

    private func getReminderDate() -> Date {
        let reminder = Reminder(hour: UserDefaults.standard.integer(forKey: reminderHourKey),
                        minute: UserDefaults.standard.integer(forKey: reminderMinuteKey))
        
        guard reminder != Reminder(hour: 0, minute: 0),
            let date = Calendar.current.date(bySettingHour: reminder.hour,
                                            minute: reminder.minute,
                                            second: 0, of: Date()) else {
            return Date()
        }
        return date
    }
    
    private func cleanDefaults() {
        UserDefaults.standard.removeObject(forKey: reminderHourKey)
        UserDefaults.standard.removeObject(forKey: reminderMinuteKey)
        UserDefaults.standard.removeObject(forKey: pushStateKey)
    }
    
    private func createReminder(fromDate date: Date) -> Reminder {
        let componentsSet = Set<Calendar.Component>(arrayLiteral: .hour,.minute)
        let intervalComponents = Calendar.current.dateComponents(componentsSet,
                                                                 from: date)
        return Reminder(hour: intervalComponents.hour!, minute: intervalComponents.minute!)
    }
    
    private func enablePushScheduling(withDate date: Date, pushEnabled enabled: Bool) {
        notificationService.checkNotificationStatus(completion: { [weak self] result in
            switch result {
            case .ok:
                let pushState = self?.getPushState() ?? false
                self?.output?.timePicker(enabled: true && pushState)
                self?.save(theDate: date, pushEnabled: enabled)
                return
            case .nok:
                self?.output?.controlSwitch(on: false)
                self?.output?.timePicker(enabled: false)
                self?.output?.showNoPushMessage()
                return
            }
        })
    }
}
