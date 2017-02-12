import Foundation

public enum ExerciseType: String {
    case active = "active"
    case mindfulness = "mindfulness"
    case positive = "positive"
}

extension ExerciseType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .active: return "active"
        case .mindfulness: return "mindfulness"
        case .positive: return "positive"
        }
    }
}

public protocol Exercise {
    var type: ExerciseType { get }
    var weekDay: Day { get }
    var weekNr: Int { get }
    func toJSON() -> [String: Any]
}

public struct ExerciseActive: Exercise {
    public let type: ExerciseType
    public let value: [Int]
    public let weekDay: Day
    public let weekNr: Int
    
    public init(type: ExerciseType, value: [Int], weekDay: Day, weekNr: Int) {
        self.type = type
        self.value = value
        self.weekDay = weekDay
        self.weekNr = weekNr
    }
    
    public func toJSON() -> [String : Any] {
        return ["type": type.rawValue,
                "value": ["0": value[0],
                          "1": value[1],
                          "2": value[2]]]
    }
}

extension ExerciseActive: Equatable {
    public static func == (lhs: ExerciseActive, rhs: ExerciseActive) -> Bool {
        return lhs.type == rhs.type &&
            lhs.value == rhs.value &&
            lhs.weekDay == rhs.weekDay &&
            lhs.weekNr == rhs.weekNr
    }
}

public struct ExercisePositive: Exercise {
    public let type: ExerciseType
    public let value: [String]
    public let weekDay: Day
    public let weekNr: Int
    
    public init(type: ExerciseType, value: [String], weekDay: Day, weekNr: Int) {
        self.type = type
        self.value = value
        self.weekDay = weekDay
        self.weekNr = weekNr
    }
    
    public func toJSON() -> [String : Any] {
        return ["type": type.rawValue,
                "value": ["0": value[0],
                          "1": value[1],
                          "2": value[2]]]
    }
}

extension ExercisePositive: Equatable {
    public static func == (lhs: ExercisePositive, rhs: ExercisePositive) -> Bool {
        return lhs.type == rhs.type &&
            lhs.value == rhs.value &&
            lhs.weekDay == rhs.weekDay &&
            lhs.weekNr == rhs.weekNr
    }
}

public struct ExerciseMindfulness: Exercise {
    public let type: ExerciseType
    public let value: [Int]
    public let weekDay: Day
    public let weekNr: Int
    
    public init(type: ExerciseType, value: [Int], weekDay: Day, weekNr: Int) {
        self.type = type
        self.value = value
        self.weekDay = weekDay
        self.weekNr = weekNr
    }
    
    public func toJSON() -> [String : Any] {
        return ["type": type.rawValue,
                "value": ["0": value[0],
                          "1": value[1]]]
    }
}

extension ExerciseMindfulness: Equatable {
    public static func == (lhs: ExerciseMindfulness, rhs: ExerciseMindfulness) -> Bool {
            return lhs.type == rhs.type &&
                lhs.value == rhs.value &&
                lhs.weekDay == rhs.weekDay &&
                lhs.weekNr == rhs.weekNr
    }
}
