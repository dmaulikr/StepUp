import Foundation

enum Day {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

struct DaySchedule {
    let title: String
    let weekDay: Day
    let exercises: [ExerciseType]
}

extension DaySchedule: Equatable {
    static func == (lhs: DaySchedule, rhs: DaySchedule) -> Bool {
            return lhs.title == rhs.title && 
                lhs.exercises == rhs.exercises &&
                lhs.weekDay == rhs.weekDay
    }
}
