import Foundation
import App
import CollectionViewKit

protocol WeekScheduleView: class, ActivityIndicating {
    func showWeekSchedule()
}

protocol WeekSchedulePresenter: class {
    var weekNumber: Int { get }
    var dataHandler: SectionDataHandler<Section<DaySchedule>> { get }
    func setView(view: WeekScheduleView)
    func start()
    func present(exerciseWithType type: ExerciseType, fromDaySchedule schedule: DaySchedule)
    func dismissWeekSchedule()
}

protocol UsesWeekSchedulePresenter {
    var weekSchedulePresenter: WeekSchedulePresenter { get }
}

protocol WeekScheduleDelegate: class {
    func close()
    func show(exercise: Exercise)
}

class WeekSchedulePresenterImplementation: WeekSchedulePresenter, UsesTreatmentService {
    private weak var view: WeekScheduleView?
    internal let treatmentService: TreatmentService
    let dataHandler: SectionDataHandler<Section<DaySchedule>>
    let weekNumber: Int
    weak var delegate: WeekScheduleDelegate?

    init(weekNumber: Int) {
        self.weekNumber = weekNumber
        dataHandler = SectionDataHandler()
        treatmentService = MixinTreatmentService()
    }

    func setView(view: WeekScheduleView) {
        self.view = view
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
        view?.showWeekSchedule()
    }

    func present(exerciseWithType type: ExerciseType, fromDaySchedule schedule: DaySchedule) {
        view?.show(loader: true)
        loadExercise(withType: type, weekDay: schedule.weekDay) { [weak self] exercise in
            self?.view?.show(loader: false)
            self?.delegate?.show(exercise: exercise)
        }
    }

    func dismissWeekSchedule() {
        delegate?.close()
    }

    private func loadExercise(withType type: ExerciseType, weekDay: Day, completion: @escaping (Exercise) -> Void) {
        treatmentService.load(exerciseWithType: type, forDay: weekDay, inWeek: weekNumber) { [unowned self] result in
            guard let r = result else {
                completion(self.emptyExercise(withType: type, weekDay: weekDay))
                return
            }
            completion(r)
        }

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
