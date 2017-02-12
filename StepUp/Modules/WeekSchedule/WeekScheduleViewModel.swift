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

class WeekScheduleViewModelImplementation: WeekScheduleViewModel, UsesTreatmentService {
    private weak var output: WeekScheduleViewOutput?
    internal let treatmentService: TreatmentService
    let dataHandler: FlatArrayDataHandler<Section<DaySchedule>>
    let weekNumber: Int
    
    init(weekNumber: Int) {
        self.weekNumber = weekNumber
        dataHandler = FlatArrayDataHandler()
        treatmentService = MixinTreatmentService()
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
        output?.show(exercise: loadExercise(withType: type, weekDay: schedule.weekDay))
    }
    
    private func loadExercise(withType type: ExerciseType, weekDay: Day) -> Exercise {
        if let e = treatmentService.load(exerciseWithType: type, forDay: weekDay, inWeek: weekNumber) {
            return e
        }
        return emptyExercise(withType: type, weekDay: weekDay)
    }
    
    private func emptyExercise(withType type: ExerciseType, weekDay: Day) -> Exercise {
        switch type {
        case .active:
            return ExerciseActive(value: [],
                                  weekDay: weekDay, weekNr: weekNumber)
        case .mindfulness:
            return ExerciseMindfulness(value: [],
                                       weekDay: weekDay, weekNr: weekNumber)
        case .positive:
            return ExercisePositive(value: [],
                                    weekDay: weekDay, weekNr: weekNumber)
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
