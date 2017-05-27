import Foundation
import UIKit

final class HomeFlowController: MainFlowController {
    var childFlowControllers: [FlowController] = []

    var mainFlowController: UIViewController {
        return navigationController
    }

    fileprivate lazy var navigationController: UINavigationController = {
        let nc = UINavigationController()
        nc.isNavigationBarHidden = true
        return nc
    }()

    init(window: UIWindow?) {
        window?.rootViewController = mainFlowController
        window?.makeKeyAndVisible()
    }

    func start() {
        let homePresenter = HomePresenterImplementation()
        homePresenter.delegate = self
        navigationController.viewControllers = [HomeViewController(presenter: homePresenter)]
    }
}

extension HomeFlowController: HomePresenterDelegate {
    func presentTreatmentWeek(_ week: Int) {
        let weekScheduleFlowController = WeekScheduleFlowController()
        weekScheduleFlowController.delegate = self
        weekScheduleFlowController.start(weekNumber: week)
        add(childFlowController: weekScheduleFlowController)
        navigationController.pushViewController(weekScheduleFlowController.mainFlowController, animated: true)
    }

    func presentReminderSettings() {
        let reminderFlowController = ReminderFlowController()
        reminderFlowController.delegate = self
        add(childFlowController: reminderFlowController)
        reminderFlowController.start()
        navigationController.present(reminderFlowController.mainFlowController, animated: true, completion: nil)
    }
}

extension HomeFlowController: ReminderFlowControllerDelegate {
    func close(reminderFlowController: ReminderFlowController) {
        navigationController.dismiss(animated: true, completion: nil)
        remove(childFlowController: reminderFlowController)
    }
}

extension HomeFlowController: WeekScheduleFlowControllerDelegate {
    func close(weekScheduleFlowController: WeekScheduleFlowController) {
        remove(childFlowController: weekScheduleFlowController)
        navigationController.popViewController(animated: true)
    }
}
