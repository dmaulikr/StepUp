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
        let data = try? JSONSerialization.data(withJSONObject: exercise.toJSON(),
                                               options: JSONSerialization.WritingOptions(rawValue: 0))
        let file = FileKit.fileInDocumentsFolder(withName: "aa.json", data: data)
        try? fileKit.save(file: file)
    }
}
