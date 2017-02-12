import Foundation
import App

protocol WeekScheduleViewOutput: class {
    func showWeekSchedule()
    func show(exercise: Exercise)
}

protocol WeekScheduleViewModel: class {
    var weekNumber: Int { get }
    var dataHandler: FlatArrayDataHandler<Section<DaySchedule>> { get }
    func setModel(output: WeekScheduleViewOutput)
    func start()
    func present(exerciseWithType type: ExerciseType, fromDaySchedule schedule: DaySchedule)
}

protocol UsesWeekScheduleViewModel {
    var weekScheduleViewModel: WeekScheduleViewModel { get }
}

class WeekScheduleViewModelImplementation: WeekScheduleViewModel {
    private weak var output: WeekScheduleViewOutput?
    let dataHandler: FlatArrayDataHandler<Section<DaySchedule>>
    let weekNumber: Int
    
    init(weekNumber: Int) {
        self.weekNumber = weekNumber
        dataHandler = FlatArrayDataHandler()
    }
    
    func setModel(output: WeekScheduleViewOutput) {
        self.output = output
    }
    
    func start() {
        let exercises = exerciseTypes(forWeek: weekNumber)
        let section = Section(title: "Schedule",
                              rows: DaySchedule(title: "Maandag",
                                                weekDay: .monday,
                                                exercises: exercises),
                              DaySchedule(title: "Dinsdag",
                                          weekDay: .tuesday,
                                          exercises: exercises),
                              DaySchedule(title: "Woensdag",
                                          weekDay: .wednesday,
                                          exercises: exercises),
                              DaySchedule(title: "Donderdag",
                                          weekDay: .thursday,
                                          exercises: exercises),
                              DaySchedule(title: "Vrijdag",
                                          weekDay: .friday,
                                          exercises: exercises),
                              DaySchedule(title: "Zaterdag",
                                          weekDay: .saturday,
                                          exercises: exercises),
                              DaySchedule(title: "Zondag",
                                          weekDay: .sunday,
                                          exercises: exercises))
        dataHandler.data = [section]
        output?.showWeekSchedule()
    }
    
    func present(exerciseWithType type: ExerciseType, fromDaySchedule schedule: DaySchedule) {
        switch type {
        case .active:
            output?.show(exercise: ExerciseActive(value: [],
                                                  weekDay: schedule.weekDay, weekNr: weekNumber))
        case .mindfulness:
            output?.show(exercise: ExerciseMindfulness(value: [],
                                                       weekDay: schedule.weekDay, weekNr: weekNumber))
        case .positive:
            output?.show(exercise: ExercisePositive(value: [],
                                                    weekDay: schedule.weekDay, weekNr: weekNumber))
        }
    }
    
    private func exerciseTypes(forWeek: Int) -> [ExerciseType] {
        switch forWeek {
        case 1...1:
            return [.active]
        case 1...7:
            return [.active, .mindfulness]
        case 7...8:
            return [.active, .mindfulness, .positive]
        default:
            return []
        }
    }
}
