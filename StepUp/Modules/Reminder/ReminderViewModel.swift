import Foundation
import App

protocol ReminderViewOutput: class {
    func showReminder()
    func pop()
    func timePicker(enabled: Bool)
    func controlSwitch(on: Bool)
}

protocol ReminderViewModel {
    func setModel(output: ReminderViewOutput)
    func start()
    func save()
    func cancel()
    func pushTryTo(enabled: Bool)
}

protocol UsesReminderViewModel {
    var reminderViewModel: ReminderViewModel { get }
}

class MixinReminderViewModel: ReminderViewModel, UsesNotificationService {
    private weak var output: ReminderViewOutput?
    internal let notificationService: NotificationService
    
    init() {
        notificationService = MixinNotificationService()
    }
    
    func start() {
        enablePushScheduling()
        output?.showReminder()
    }
    
    func setModel(output: ReminderViewOutput) {
        self.output = output
    }
    
    func save() {
        output?.pop()
    }
    
    func cancel() {
        output?.pop()
    }
    
    func pushTryTo(enabled: Bool) {
        enablePushScheduling()
    }
    
    private func enablePushScheduling() {
        notificationService.checkNotificationStatus(completion: { [weak self] result in
            switch result {
            case .ok:
                self?.output?.timePicker(enabled: true)
                return
            case .nok:
                self?.output?.controlSwitch(on: false)
                self?.output?.timePicker(enabled: false)
                return
            }
        })
    }
}
