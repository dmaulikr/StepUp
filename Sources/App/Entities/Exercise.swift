import Foundation

public enum ExerciseType: String {
    case active = "active"
    case mindfulness = "mindfulness"
    case positive = "positive"
}

extension ExerciseType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .active: return "Bewegen"
        case .mindfulness: return "Mindfulness"
        case .positive: return "Positief"
        }
    }
}

public protocol Exercise {
    var type: ExerciseType { get }
    var weekDay: Day { get }
    var weekNr: Int { get }
    func toJSON() -> [String: Any]
    func toHTML() -> String
}

extension Exercise {
    public static func create(json: [String: Any]) -> Exercise? {
        guard let type = ExerciseType(rawValue: json["type"] as! String) else {
            return nil
        }
        guard let weekDay = Day(rawValue: json["weekDay"] as! String) else {
            return nil
        }
        guard let weekNr = json["weekNr"] as? Int else {
            return nil
        }
        switch type {
        case .active:
            guard let value = json["value"] as? [String: Any] else {
                return nil
            }
            let activeValues = [value["0"] as! Int, value["1"] as! Int, value["2"] as! Int]
            return ExerciseActive(value: activeValues, weekDay: weekDay, weekNr: weekNr)
        case .mindfulness:
            guard let value = json["value"] as? [String: Any] else {
                return nil
            }
            let mindfullnessValues = [value["0"] as! Int, value["1"] as! Int]
            return ExerciseMindfulness(value: mindfullnessValues, weekDay: weekDay, weekNr: weekNr)
        case .positive:
            guard let value = json["value"] as? [String: Any] else {
                return nil
            }
            let positiveValues = [value["0"] as! String, value["1"] as! String, value["2"] as! String]
            return ExercisePositive(value: positiveValues, weekDay: weekDay, weekNr: weekNr)
        }   
    }
}

public struct ExerciseActive: Exercise {
    public let type: ExerciseType = .active
    public let value: [Int]
    public let weekDay: Day
    public let weekNr: Int
    
    public init(value: [Int], weekDay: Day, weekNr: Int) {
        self.value = value
        self.weekDay = weekDay
        self.weekNr = weekNr
    }
    
    public func toJSON() -> [String : Any] {
        return ["type": type.rawValue,
                "value": ["0": value[0],
                          "1": value[1],
                          "2": value[2]],
                "weekDay": weekDay.rawValue,
                "weekNr": weekNr]
    }
    
    public func toHTML() -> String {
        var html = "<tr><td>week: \(weekNr) - \(weekDay.rawValue)</td></tr>"
        html += "<tr><td colspan=\"2\">\(type.description)</td></tr>"
        html += "<tr><td colspan=\"2\">Intensiteit: \(value[0])</td></tr>"
        html += "<tr><td colspan=\"2\">Training: \(value[1])</td></tr>"
        html += "<tr><td colspan=\"2\">Plezier: \(value[2])</td></tr>"
        return html
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
    public let type: ExerciseType = .positive
    public let value: [String]
    public let weekDay: Day
    public let weekNr: Int
    
    public init(value: [String], weekDay: Day, weekNr: Int) {
        self.value = value
        self.weekDay = weekDay
        self.weekNr = weekNr
    }
    
    public func toJSON() -> [String : Any] {
        return ["type": type.rawValue,
                "value": ["0": value[0],
                          "1": value[1],
                          "2": value[2]],
                "weekDay": weekDay.rawValue,
                "weekNr": weekNr]
    }
    
    public func toHTML() -> String {
        var html = "<tr><td>week \(weekNr) - \(weekDay.rawValue)</td></tr>"
        html += "<tr><td colspan=\"2\">\(type.description)</td></tr>"
        html += "<tr><td colspan=\"2\">1: \(value[0])</td></tr>"
        html += "<tr><td colspan=\"2\">2: \(value[1])</td></tr>"
        html += "<tr><td colspan=\"2\">3: \(value[2])</td></tr>"
        return html
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
    public let type: ExerciseType = .mindfulness
    public let value: [Int]
    public let weekDay: Day
    public let weekNr: Int
    
    public init(value: [Int], weekDay: Day, weekNr: Int) {
        self.value = value
        self.weekDay = weekDay
        self.weekNr = weekNr
    }
    
    public func toJSON() -> [String : Any] {
        return ["type": type.rawValue,
                "value": ["0": value[0],
                          "1": value[1]],
                "weekDay": weekDay.rawValue,
                "weekNr": weekNr]
    }
    
    public func toHTML() -> String {
        var html = "<tr><td>week \(weekNr) - \(weekDay.rawValue)</td></tr>"
        html += "<tr><td colspan=\"2\">\(type.description)</td></tr>"
        html += "<tr><td colspan=\"2\">bodyscan: \(value[0])</td></tr>"
        html += "<tr><td colspan=\"2\">ademruimte: \(value[1])</td></tr>"
        return html
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
