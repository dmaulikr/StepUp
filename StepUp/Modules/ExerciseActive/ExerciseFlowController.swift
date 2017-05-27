import Foundation
import UIKit
import App

protocol ExerciseFlowControllerDelegate: class {
    func dismiss(exerciseFlowController: ExerciseFlowController)
}

final class ExerciseFlowController: MainFlowController {
    var childFlowControllers: [FlowController] = []
    weak var delegate: ExerciseFlowControllerDelegate?
    var mainFlowController: UIViewController {
        return navigationController
    }
    fileprivate lazy var navigationController = UINavigationController()

    func start(withExercise exercise: Exercise) {
        let presenter = MixinExercisePresenterImplementation(exercise: exercise)
        presenter.delegate = self
        let vc = ExerciseViewController(presenter: presenter)
        navigationController.viewControllers = [vc]
    }
}

extension ExerciseFlowController: ExerciseDelegate {
    func didSaveExercise() {
        delegate?.dismiss(exerciseFlowController: self)
    }

    func didCancelExercise() {
        delegate?.dismiss(exerciseFlowController: self)
    }
}
