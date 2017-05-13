import Foundation
import FileKit

public protocol TreatmentService {
    func save(_ exercise: Exercise)
    func load(exerciseWithType type: ExerciseType,
              forDay day: Day,
              inWeek week: Int,
              completion: @escaping (Exercise?) -> Void)
    func cleanAll()
    func loadAllExercise(completion: @escaping ([Exercise]) -> Void)
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
        add(exercise: exercise) { [weak self] exercises in
            let exercises = exercises.map { e in
                e.toJSON()
            }
            let data = try? JSONSerialization.data(withJSONObject: exercises,
                                                   options: JSONSerialization.WritingOptions(rawValue: 0))
            let file = FileKit.fileInDocumentsFolder(withName: "\(exercise.weekNr).json", data: data)
            self?.fileKit.save(file: file, queue: DispatchQueue.global())
        }
    }

    public func load(exerciseWithType type: ExerciseType,
                     forDay day: Day,
                     inWeek week: Int,
                     completion: @escaping (Exercise?) -> Void) {
        loadExercises(forWeekNumber: week) { exercises in
            guard let index = exercises.index(where: { e in
                return e.weekDay == day && e.type == type
            }) else {
                completion(nil)
                return
            }
            completion(exercises[index])
        }
    }

    public func loadAllExercise(completion: @escaping ([Exercise]) -> Void) {
        var result: [Exercise] = []
        let asycWorkerGroup = DispatchGroup()
        for week in 1...8 {
            asycWorkerGroup.enter()
            loadExercises(forWeekNumber: week) { exercises in
                result.append(contentsOf: exercises)
                asycWorkerGroup.leave()
            }
        }
        asycWorkerGroup.notify(queue: DispatchQueue.main) {
            completion(result)
        }
    }

    public func cleanAll() {
        fileKit.load(folder: Folder(path: FileKit.pathToDocumentsFolder())) { [weak self] result in
            guard case let .success(folder) = result else { return }
            let files: [File] = folder.filePaths.flatMap { url in
                let filename = url.lastPathComponent
                let pathComp = url.pathComponents
                    .dropFirst()
                    .dropLast()
                    .joined(separator: "/")
                let f = Folder(path: URL(fileURLWithPath: pathComp))
                return File(name: filename, folder: f)
            }

            files.forEach { f in
                self?.fileKit.delete(file: f, queue: DispatchQueue.global())
            }
        }
    }

    private func add(exercise: Exercise, completion: @escaping ([Exercise]) -> Void) {
        loadExercises(forWeekNumber: exercise.weekNr) { exercises in
            var exercises = exercises
            if let index = exercises.index(where: { e in
                return e.weekDay == exercise.weekDay && e.type == exercise.type
            }) {
                exercises.remove(at: index)
            }
            exercises.append(exercise)
            completion(exercises)
        }
    }

    private func loadExercises(forWeekNumber number: Int, completion: @escaping ([Exercise]) -> Void) {
        let backgroundQueue = DispatchQueue.global()
        fileKit.load(file: FileKit.fileInDocumentsFolder(withName: "\(number).json"),
                     queue: backgroundQueue) { result in
            guard case let .success(file) = result,
                    let data = file.data else {
                        completion([])
                        return
            }

            guard let json = try? JSONSerialization.jsonObject(with: data,
                                                               options: []) as? [[String: Any]],
                let result = json
                else {
                    completion([])
                    return
            }
            let exercises: [Exercise] = result.flatMap { item in
                return ExerciseActive.create(json: item)
            }
            completion(exercises)
        }
    }
}
