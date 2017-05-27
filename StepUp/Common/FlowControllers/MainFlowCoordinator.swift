import Foundation
import UIKit

protocol MainFlowControllerProvider: class {
    var mainFlowController: UIViewController { get }
}

typealias MainFlowController = FlowController & MainFlowControllerProvider
