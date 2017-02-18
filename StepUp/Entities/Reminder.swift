import Foundation

struct Reminder {
    let hour: Int
    let minute: Int
}

extension Reminder: Equatable {
    static func == (lhs: Reminder, rhs: Reminder) -> Bool {
            return lhs.hour == rhs.hour &&
                lhs.minute == rhs.minute
    }
}
