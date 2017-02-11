import Foundation

struct AudioTime {
    let day: Int
    let hour: Int
    let minute: Int
    let second: Int
    let timeInterval: TimeInterval
}

extension AudioTime {
    init(_ timeInterval: TimeInterval) {
        day = Int(timeInterval / (24 * 3600))
        hour = Int(timeInterval.truncatingRemainder(dividingBy:(24 * 3600))) / 3600
        minute = Int(timeInterval.truncatingRemainder(dividingBy: 3600)) / 60
        second = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        self.timeInterval = timeInterval
    }
}

extension AudioTime: Equatable {
    static func == (lhs: AudioTime, rhs: AudioTime) -> Bool {
        return lhs.day == rhs.day &&
            lhs.hour == rhs.hour &&
            lhs.minute == rhs.minute &&
            lhs.second == rhs.second &&
            lhs.timeInterval == rhs.timeInterval
    }
}

extension AudioTime: CustomStringConvertible {
    var description: String {
        return String(format: "%02dh:%02dm:%02ds", hour, minute, second)
    }
}
