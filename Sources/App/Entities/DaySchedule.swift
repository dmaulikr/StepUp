import Foundation

public enum Day: String {
    case sunday = "sunday"
    case monday = "monday"
    case tuesday = "tuesday"
    case wednesday = "wednesday"
    case thursday = "thursday"
    case friday = "friday"
    case saturday = "saturday"
}

public struct DaySchedule {
    public let title: String
    public let weekDay: Day
    public let exercises: [ExerciseType]
    
    public init(title: String, weekDay: Day, exercises: [ExerciseType]) {
        self.title = title
        self.weekDay = weekDay
        self.exercises = exercises
    }
}

extension DaySchedule: Equatable {
    public static func == (lhs: DaySchedule, rhs: DaySchedule) -> Bool {
            return lhs.title == rhs.title && 
                lhs.exercises == rhs.exercises &&
                lhs.weekDay == rhs.weekDay
    }
}
