import UIKit
import App

protocol ExerciseResult {
    func result() -> Exercise
}

class ExerciseViewController: UIViewController,
                              UsesExercisePresenter,
                              ExerciseView {

    internal let exercisePresenter: ExercisePresenter
    private var activeVC: UIViewController!

    init(presenter: ExercisePresenter) {
        exercisePresenter = presenter
        super.init(nibName: nil, bundle: nil)
        exercisePresenter.setView(view: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        exercisePresenter.start()
    }

    // MARK: PresenterOuputView

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

    private func add(viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
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
        exercisePresenter.cancel()
    }

    @objc private func save(sender: UIBarButtonItem) {
        guard let vc = activeVC as? ExerciseResult else { return }
        exercisePresenter.save(exercise: vc.result())
    }
}
