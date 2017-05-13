import UIKit
import MessageUI

protocol MailComposer {
    func presentMailComposerView(recipients: [String],
                                 subject: String,
                                 message: String,
                                 isHTML: Bool,
                                 appendDebugInfo debug: Bool)
    func canSendMail() -> Bool
}

extension MailComposer where Self: UIViewController {
    func presentMailComposerView(recipients: [String],
                                 subject: String,
                                 message: String,
                                 isHTML: Bool = true,
                                 appendDebugInfo debug: Bool = false) {
        let mailComposer = MailComposerViewController(recipients: recipients,
                                                      subject: subject,
                                                      message: message,
                                                      isHTML: isHTML,
                                                      appendDebugInfo: debug)
        present(mailComposer, animated: true, completion: nil)
    }

    func canSendMail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
}

final class MailComposerViewController: MFMailComposeViewController,
                                  MFMailComposeViewControllerDelegate {

    init(recipients: [String],
         subject: String,
         message: String,
         isHTML: Bool = true,
         appendDebugInfo debug: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        mailComposeDelegate = self
        setToRecipients(recipients)
        setSubject(subject)
        setMessageBody(debug ? append(keyValues: getSpecKeyList(), toMessage: message) : message, isHTML: isHTML)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: MFMailComposeViewControllerDelegate Method

    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult,
                               error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    private func getAppVersion() -> String {
        guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
            let shortBundleVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                fatalError("App version and or buidnr not defined")
        }
        return "\(shortBundleVersion)(\(bundleVersion))"
    }

    private func getSpecKeyList() -> [String: String] {
        return  ["App versie": "\(getAppVersion())",
                "SysVersion": "\(UIDevice.current.systemVersion)",
                "Platform": "\(UIDevice.current.systemName)"]
    }

    private func append(keyValues: [String: String], toMessage message: String) -> String {
        var messageWithSpecs: String = message
        for key in keyValues.keys {
            messageWithSpecs = messageWithSpecs.appending("\(key): \(keyValues[key]!)\n")
        }
        return messageWithSpecs
    }
}
