import Foundation
import App

protocol ExerciseViewOutput: class {
    func show(exercise: Exercise)
    func pop()
}

protocol ExerciseViewModel: class {
    func setOutput(output: ExerciseViewOutput)
    func start()
    func cancel()
    func save(exercise: Exercise)
}

protocol UsesExerciseViewModel {
    var exerciseViewModel: ExerciseViewModel { get }
}

class MixinExerciseViewModelImplementation: ExerciseViewModel, UsesTreatmentService {
    private weak var output: ExerciseViewOutput?
    private let exercise: Exercise
    internal let treatmentService: TreatmentService
    
    init(exercise: Exercise) {
        self.exercise = exercise
        treatmentService = MixinTreatmentService()
    }
    
    func setOutput(output: ExerciseViewOutput) {
        self.output = output
    }
    
    func start() {
        output?.show(exercise: exercise)
    }
    
    func cancel() {
        output?.pop()
    }
    
    func save(exercise: Exercise) {
        treatmentService.save(exercise)
        output?.pop()
    }
}
