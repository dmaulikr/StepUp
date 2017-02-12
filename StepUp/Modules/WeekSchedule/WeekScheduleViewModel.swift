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
        let section = Section(title: "Schedule",
                              rows: DaySchedule(title: "Maandag",
                                                weekDay: .monday,
                                                exercises: [.active]),
                              DaySchedule(title: "Dinsdag",
                                          weekDay: .tuesday,
                                          exercises: [.active, .mindfulness]),
                              DaySchedule(title: "Woensdag",
                                          weekDay: .wednesday,
                                          exercises: [.active, .mindfulness]),
                              DaySchedule(title: "Donderdag",
                                          weekDay: .thursday,
                                          exercises: [.active, .mindfulness]),
                              DaySchedule(title: "Vrijdag",
                                          weekDay: .friday,
                                          exercises: [.active, .mindfulness]),
                              DaySchedule(title: "Zaterdag",
                                          weekDay: .saturday,
                                          exercises: [.active, .mindfulness]),
                              DaySchedule(title: "Zondag",
                                          weekDay: .sunday,
                                          exercises: [.active, .mindfulness, .positive]))
        dataHandler = FlatArrayDataHandler(data: [section])
    }
    
    func setModel(output: WeekScheduleViewOutput) {
        self.output = output
    }
    
    func start() {
        output?.showWeekSchedule()
    }
    
    func present(exerciseWithType type: ExerciseType, fromDaySchedule schedule: DaySchedule) {
        switch type {
        case .active:
            output?.show(exercise: ExerciseActive(type: type,
                                                  value: [],
                                                  weekDay: schedule.weekDay, weekNr: weekNumber))
        case .mindfulness:
            output?.show(exercise: ExerciseMindfulness(type: type,
                                                       value: [],
                                                       weekDay: schedule.weekDay, weekNr: weekNumber))
        case .positive:
            output?.show(exercise: ExercisePositive(type: type,
                                                    value: [],
                                                    weekDay: schedule.weekDay, weekNr: weekNumber))
        }
    }
}
