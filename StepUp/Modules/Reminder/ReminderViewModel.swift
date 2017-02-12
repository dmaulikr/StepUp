import Foundation

protocol ReminderViewOutput: class {
    func showReminder()
    func pop()
}

protocol ReminderViewModel {
    func setModel(output: ReminderViewOutput)
    func start()
    func save()
    func cancel()
}

protocol UsesReminderViewModel {
    var reminderViewModel: ReminderViewModel { get }
}

class MixinReminderViewModel: ReminderViewModel {
    private weak var output: ReminderViewOutput?
    
    func start() {
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
    
}
