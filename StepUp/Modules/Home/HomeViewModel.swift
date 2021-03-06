import Foundation
import App
import CollectionViewKit

protocol HomeViewOutput: class {
    func showTreatments(index: IndexPath)
    func presentTreatmentWeek(viewModel: WeekScheduleViewModel)
    func presentReminderSettings(viewModel: MixinReminderViewModel)
    func sendTreatment(toEmail email: String, name: String, withResults results: String)
    func confirmation(message: String)
}

protocol HomeViewModel: class {
    var dataHandler: SectionDataHandler<Section<MixedEntity>> { get }
    func setModel(output: HomeViewOutput)
    func start()
    func presentTreatment(weekNumber number: Int)
    func getReminderSettings()
    func getTreatmentResults(email: String, name: String)
    func promptForExercisesRemoval()
    func deleteExercises()
}

protocol UsesHomeViewModel {
    var homeViewModel: HomeViewModel { get }
}

class HomeViewModelImplementation: HomeViewModel, UsesTreatmentService {
    private weak var output: HomeViewOutput?
    internal let treatmentService: TreatmentService
    let dataHandler: SectionDataHandler<Section<MixedEntity>>
    var firstLaunch: Bool = true
    
    init() {
        // swiftlint:disable line_length
        let treatments = Section(title: "Treatments", rows: MixedEntity.treatment(Treatment(title: "Behandeling 1", description: "Step up en stap in omdat gezond bewegen goed voor je gezondheid is,een positieve invloed op je stemming heeft, je zelfvertrouwen vergroot en de kans op het gebruik van medicijnen doet afnemen.", number: 1)),
                              MixedEntity.treatment(Treatment(title: "Behandeling 2", description: "Veel van onze dagelijkse handelingen gaan op de automatische piloot. Tijd om bewust te worden!", number: 2)),
                              MixedEntity.treatment(Treatment(title: "Behandeling 3", description: "Deal met hindernissen en kies een activiteit die je leuk vindt om te doen! Zorg ervoor dat jouw beweegactiviteit in je wekelijkse schema ingeroosterd wordt.", number: 3)),
                              MixedEntity.treatment(Treatment(title: "Behandeling 4", description: "De ademhaling is een hulpmiddel om te allen tijde naar het hier en nu te komen.", number: 4)),
                              MixedEntity.treatment(Treatment(title: "Behandeling 5", description: "Ademnood? Stapje terug maar blijf trainen!", number: 5)),
                              MixedEntity.treatment(Treatment(title: "Behandeling 6", description: "Wordt je bewust van je automatische, negatieve gedachten. Pas als je bewust wordt van deze negatieve gedachten, kan je ze veranderen.", number: 6)),
                              MixedEntity.treatment(Treatment(title: "Behandeling 7", description: "Houd je gedachten waardevrij, het is zoals het is.", number: 7)),
                              MixedEntity.treatment(Treatment(title: "Behandeling 8", description: "Richt je op positieve dingen.", number: 8)))
        let settings = Section(title: "Settings", rows: MixedEntity.setting(Setting(email: "email", name: "name")))
        // swiftlint:enable line_length
        dataHandler = SectionDataHandler(data: [settings, treatments])
        treatmentService = MixinTreatmentService()
    }
    
    func setModel(output: HomeViewOutput) {
        self.output = output
    }
    
    func start() {
        if firstLaunch {
            output?.showTreatments(index: IndexPath(row: 0, section: 1))
            firstLaunch = false
        }
    }
    
    func presentTreatment(weekNumber number: Int) {
        output?.presentTreatmentWeek(viewModel: WeekScheduleViewModelImplementation(weekNumber: number))
    }
    
    func getReminderSettings() {
        output?.presentReminderSettings(viewModel: MixinReminderViewModel())
    }

    func getTreatmentResults(email: String, name: String) {
        treatmentService.loadAllExercise() { [unowned self] result in
            let message = self.convertToHTMLTable(exercises: result)
            self.output?.sendTreatment(toEmail: email, name: name, withResults: message)
        }
    }
    
    func promptForExercisesRemoval() {
        output?.confirmation(message: "Weet je zeker dat je alle resultaten wil verwijderen?")
    }
    
    func deleteExercises() {
        treatmentService.cleanAll()
    }
    
    private func convertToHTMLTable(exercises: [Exercise]) -> String {
        var html: [String] = exercises.map { e in
            e.toHTML()
        }
        html.insert("<html><body><table>", at: 0)
        html.append("</table></body></html>")
        return html.joined()
    }
}

