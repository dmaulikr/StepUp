import UIKit
import App

protocol ExerciseResult {
    func result() -> Exercise
}

class ExerciseViewController: UIViewController,
                              UsesExerciseViewModel,
                              ExerciseViewOutput {

    internal let exerciseViewModel: ExerciseViewModel
    private var activeVC: UIViewController!
    
    init(viewModel: ExerciseViewModel) {
        exerciseViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        exerciseViewModel.setOutput(output: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        exerciseViewModel.start()
    }
    
    // MARK: ViewModelOuputView
    
    func show(exercise: Exercise) {
        switch exercise.type {
        case .active:
            activeVC = ActiveViewController(exercise: exercise)
            add(viewController: activeVC)
            return
        case .positive:
            activeVC = PositiveViewController(exercise: exercise)
            add(viewController: activeVC)
            return
        case .mindfulness:
            activeVC = MindfulnessViewController(exercise: exercise)
            add(viewController: activeVC)
            return
        }
    }
    
    func pop() {
        activeVC.view.removeFromSuperview()
        activeVC.removeFromParentViewController()
        activeVC = nil
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    private func add(viewController vc: UIViewController) {
        addChildViewController(vc)
        view.addSubview(vc.view)
        vc.didMove(toParentViewController: self)
    }
    
    private func setup() {
        let leftButton = UIBarButtonItem(title: "Annuleren",
                                         style: .plain,
                                         target: self,
                                         action: #selector(cancel(sender:)))
        leftButton.tintColor = .cancelAction
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(title: "Opslaan",
                                          style: .done,
                                          target: self,
                                          action: #selector(save(sender:)))
        rightButton.tintColor = .actionGreen
        navigationItem.rightBarButtonItem = rightButton
        view.backgroundColor = .white
    }
    
    @objc private func cancel(sender: UIBarButtonItem) {
        exerciseViewModel.cancel()
    }
    
    @objc private func save(sender: UIBarButtonItem) {
        guard let vc = activeVC as? ExerciseResult else { return }
        exerciseViewModel.save(exercise: vc.result())
    }
}
