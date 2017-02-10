import Foundation

protocol WeekScheduleViewOutput: class {
    func showWeekSchedule()
    func show<T>(exercise: AnyExercise<T>)
}

protocol WeekScheduleViewModel: class {
    var weekNumber: Int { get }
    var dataHandler: ArrayDataHandler<DaySchedule> { get }
    func setModel(output: WeekScheduleViewOutput)
    func start()
    func present(exerciseWithType type: ExerciseType, fromDaySchedule schedule: DaySchedule)
}

protocol UsesWeekScheduleViewModel {
    var weekScheduleViewModel: WeekScheduleViewModel { get }
}

class WeekScheduleViewModelImplementation: WeekScheduleViewModel {
    private weak var output: WeekScheduleViewOutput?
    let dataHandler: ArrayDataHandler<DaySchedule>
    let weekNumber: Int
    
    init(weekNumber: Int) {
        self.weekNumber = weekNumber
        dataHandler = ArrayDataHandler(data: [DaySchedule(title: "Maandag",
                                                           weekDay: .monday,
                                                           exercises: [.active]),
                                              DaySchedule(title: "Dinsdag",
                                                           weekDay: .tuesday,
                                                           exercises: [.active, .mindfulness, .positive]),
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
                                                           exercises: [.active, .mindfulness, .positive])])
    }
    
    func setModel(output: WeekScheduleViewOutput) {
        self.output = output
    }
    
    func start() {
        output?.showWeekSchedule()
    }
    
    func present(exerciseWithType type: ExerciseType, fromDaySchedule schedule: DaySchedule) {
        output?.show(exercise: AnyExercise(type: type, value: []))
    }
}
