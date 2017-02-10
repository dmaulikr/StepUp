import Foundation

enum ExerciseType {
    case active
    case mindfulness
    case positive
}

protocol Exercise {
    associatedtype Value
    var type: ExerciseType { get set }
    var value: Value { get set }
}

struct AnyExercise<T>: Exercise {
    var type: ExerciseType
    var value: T
}

extension AnyExercise: Equatable {
    static func == (lhs: AnyExercise, rhs: AnyExercise) -> Bool {
            return lhs.type == rhs.type
    }
}
