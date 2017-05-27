import Foundation
import App

protocol ExerciseView: class {
    func show(exercise: Exercise)
    func pop()
}

protocol ExercisePresenter: class {
    func setView(view: ExerciseView)
    func start()
    func cancel()
    func save(exercise: Exercise)
}

protocol UsesExercisePresenter {
    var exercisePresenter: ExercisePresenter { get }
}

protocol ExerciseDelegate: class {
    func didCancelExercise()
    func didSaveExercise()
}

class MixinExercisePresenterImplementation: ExercisePresenter, UsesTreatmentService {
    private weak var view: ExerciseView?
    private let exercise: Exercise
    internal let treatmentService: TreatmentService
    weak var delegate: ExerciseDelegate?

    init(exercise: Exercise) {
        self.exercise = exercise
        treatmentService = MixinTreatmentService()
    }

    func setView(view: ExerciseView) {
        self.view = view
    }

    func start() {
        view?.show(exercise: exercise)
    }

    func cancel() {
        view?.pop()
        delegate?.didCancelExercise()
    }

    func save(exercise: Exercise) {
        treatmentService.save(exercise)
        view?.pop()
        delegate?.didSaveExercise()
    }
}
