import Foundation
import UIKit

protocol ReminderFlowControllerDelegate: class {
    func close(reminderFlowController: ReminderFlowController)
}

final class ReminderFlowController: MainFlowController {
    var childFlowControllers: [FlowController] = []
    private lazy var navigationController: UINavigationController = UINavigationController()
    var mainFlowController: UIViewController {
        return navigationController
    }
    weak var delegate: ReminderFlowControllerDelegate?

    init() { }

    func start() {
        let presenter = MixinReminderPresenter()
        presenter.delegate = self
        let vc = ReminderViewController(presenter: presenter)
        navigationController.viewControllers.append(vc)
    }
}

extension ReminderFlowController: RemdinderDelegate {
    func close() {
        delegate?.close(reminderFlowController: self)
    }
}
