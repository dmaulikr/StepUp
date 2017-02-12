import Foundation
import FileKit

public protocol TreatmentService {
    func save(_ exercise: Exercise)
}

public protocol UsesTreatmentService {
    var treatmentService: TreatmentService { get }
}

public class MixinTreatmentService: TreatmentService {
    private let fileKit: FileKit
    
    public init() {
        fileKit = FileKit()
    }
    
    public func save(_ exercise: Exercise) {
        let exercises = add(exercise: exercise).map { e in
            e.toJSON()
        }
        let data = try? JSONSerialization.data(withJSONObject: exercises,
                                               options: JSONSerialization.WritingOptions(rawValue: 0))
        let file = FileKit.fileInDocumentsFolder(withName: "\(exercise.weekNr).json", data: data)
        try? fileKit.save(file: file)
    }
    
    private func add(exercise: Exercise) -> [Exercise] {
        var exercises = loadExercises(forWeek: exercise.weekNr)
        if let index = exercises.index(where: { e in
            return e.weekDay == exercise.weekDay && e.type == exercise.type
        }) {
            exercises.remove(at: index)
        }
        exercises.append(exercise)
        return exercises
    }
    
    private func loadExercises(forWeek nr: Int) -> [Exercise] {
        guard let f = try? fileKit.load(file: FileKit.fileInDocumentsFolder(withName: "\(nr).json")),
              let data = f.data else {
            return []
        }
        guard let json = try? JSONSerialization.jsonObject(with: data,
                                                           options: []) as? [[String: Any]],
              let result = json
            else {
                return []
        }
        let exercises: [Exercise] = result.flatMap { item in
            return ExerciseActive.create(json: item)
        }
        return exercises
    }
}
