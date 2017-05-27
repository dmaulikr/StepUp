import Foundation

protocol FlowController: class {
    var childFlowControllers: [FlowController] { get set }
}

extension FlowController {
    func add(childFlowController child: FlowController) {
        self.childFlowControllers.append(child)
    }

    func remove(childFlowController child: FlowController) {
        self.childFlowControllers = self.childFlowControllers.filter { flowController in
            flowController !== child
        }
    }

    public subscript (index: Int) -> FlowController {
        get {
            return childFlowControllers[index]
        }
        set {
            childFlowControllers[index] = newValue
        }
    }
}
