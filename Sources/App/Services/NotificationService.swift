import Foundation
import UserNotifications

public enum NotificationServiceResult {
    case ok
    case nok
}

public protocol NotificationService {
    func checkNotificationStatus(completion: @escaping (NotificationServiceResult) -> Void)
    func scheduleLocalNotification(title: String,
                                   body: String,
                                   atTime time: TimeInterval,
                                   withIdentifier identifier: String,
                                   repeats: Bool)
}

public protocol UsesNotificationService {
    var notificationService: NotificationService { get }
}

public class MixinNotificationService: NotificationService {
    public init() { }

    public func checkNotificationStatus(completion: @escaping (NotificationServiceResult) -> Void) {
        checkPermissions { status in
            switch status {
            case .authorized:
                DispatchQueue.main.async {
                    completion(.ok)
                }
                return
            case .denied:
                DispatchQueue.main.async {
                    completion(.nok)
                }
                return
            case .notDetermined:
                self.requestPushPermission(completion: { granted in
                    DispatchQueue.main.async {
                        granted ? completion(.ok) : completion(.nok)
                    }
                })
                return
            }
        }
    }

    public func scheduleLocalNotification(title: String,
                                          body: String,
                                          atTime time: TimeInterval,
                                          withIdentifier identifier: String,
                                          repeats: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body

        content.sound = UNNotificationSound.default()
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time,
                                                        repeats: repeats)
        let request = UNNotificationRequest(identifier: identifier,
            content: content,
            trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }

    private func checkPermissions(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            completion(settings.authorizationStatus)
        }
    }

    private func requestPushPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) { (granted, _) in
            completion(granted)
        }
    }
}
