import Foundation

protocol ExerciseViewOutput: class {
    func show<T>(exercise: AnyExercise<T>)
    func pop()
}

protocol ExerciseViewModel: class {
    func setOutput(output: ExerciseViewOutput)
    func start()
    func cancel()
    func save<T>(exercise: AnyExercise<T>)
}

protocol UsesExerciseViewModel {
    var exerciseViewModel: ExerciseViewModel { get }
}

class MixinExerciseViewModelImplementation<T>: ExerciseViewModel {
    private weak var output: ExerciseViewOutput?
    private let exercise: AnyExercise<T>
    
    init(exercise: AnyExercise<T>) {
        self.exercise = exercise
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
    
    func save<T>(exercise: AnyExercise<T>) {
        print(exercise.value)
        output?.pop()
    }
}
