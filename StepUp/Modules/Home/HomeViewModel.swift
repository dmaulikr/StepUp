import Foundation

protocol HomeViewOutput: class {
    func showTreatments()
    func presentTreatmentWeek(viewModel: WeekScheduleViewModel)
}

protocol HomeViewModel: class {
    var dataHandler: ArrayDataHandler<Treatment> { get }
    func setModel(output: HomeViewOutput)
    func start()
    func presentTreatment(weekNumber number: Int)
}

protocol UsesHomeViewModel {
    var homeViewModel: HomeViewModel { get }
}

class HomeViewModelImplementation: HomeViewModel {
    private weak var output: HomeViewOutput?
    let dataHandler: ArrayDataHandler<Treatment>
    
    init() {
        // swiftlint:disable line_length
        dataHandler = ArrayDataHandler(data: [Treatment(title: "Behandeling 1", description: "Step up en stap in omdat gezond bewegen goed voor je gezondheid is,een positieve invloed op je stemming heeft, je zelfvertrouwen vergroot en de kans op het gebruik van medicijnen doet afnemen.", number: 1),
                                              Treatment(title: "Behandeling 2", description: "Veel van onze dagelijkse handelingen gaan op de automatische piloot. Tijd om bewust te worden!", number: 2),
                                              Treatment(title: "Behandeling 3", description: "Deal met hindernissen en kies een activiteit die je leuk vindt om te doen! Zorg ervoor dat jouw beweegactiviteit in je wekelijkse schema ingeroosterd wordt.", number: 3),
                                              Treatment(title: "Behandeling 4", description: "De ademhaling is een hulpmiddel om te allen tijde naar het hier en nu te komen.", number: 4),
                                              Treatment(title: "Behandeling 5", description: "Ademnood? Stapje terug maar blijf trainen!", number: 5),
                                              Treatment(title: "Behandeling 6", description: "Wordt je bewust van je automatische, negatieve gedachten. Pas als je bewust wordt van deze negatieve gedachten, kan je ze veranderen.", number: 6),
                                              Treatment(title: "Behandeling 7", description: "Houd je gedachten waardevrij, het is zoals het is.", number: 7),
                                              Treatment(title: "Behandeling 8", description: "Richt je op positieve dingen.", number: 8)])
        // swiftlint:enable line_length
    }
    
    func setModel(output: HomeViewOutput) {
        self.output = output
    }
    
    func start() {
        output?.showTreatments()
    }
    
    func presentTreatment(weekNumber number: Int) {
        output?.presentTreatmentWeek(viewModel: WeekScheduleViewModelImplementation(weekNumber: number))
    }
}
