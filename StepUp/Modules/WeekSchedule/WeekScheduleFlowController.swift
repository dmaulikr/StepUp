import Foundation
import UIKit
import App

protocol WeekScheduleFlowControllerDelegate: class {
    func close(weekScheduleFlowController: WeekScheduleFlowController)
}

final class WeekScheduleFlowController: MainFlowController {
    var childFlowControllers: [FlowController] = []
    weak var delegate: WeekScheduleFlowControllerDelegate?

    fileprivate var weekScheduleVC: WeekScheduleViewController!

    var mainFlowController: UIViewController {
        return weekScheduleVC
    }

    init() { }

    func start(weekNumber: Int) {
        let presenter = WeekSchedulePresenterImplementation(weekNumber: weekNumber)
        presenter.delegate = self
        weekScheduleVC = WeekScheduleViewController(presenter: presenter)
    }
}

extension WeekScheduleFlowController: WeekScheduleDelegate {
    func close() {
        delegate?.close(weekScheduleFlowController: self)
    }

    func show(exercise: Exercise) {
        let exerciseFlowController = ExerciseFlowController()
        exerciseFlowController.start(withExercise: exercise)
        exerciseFlowController.delegate = self
        add(childFlowController: exerciseFlowController)
        weekScheduleVC.present(exerciseFlowController.mainFlowController, animated: false, completion: nil)
    }
}

extension WeekScheduleFlowController: ExerciseFlowControllerDelegate {
    func dismiss(exerciseFlowController: ExerciseFlowController) {
        weekScheduleVC.dismiss(animated: true, completion: nil)
        remove(childFlowController: exerciseFlowController)
    }
}
