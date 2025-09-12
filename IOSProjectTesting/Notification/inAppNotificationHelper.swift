import UserNotifications
import UIKit

class NotificationHelper: NSObject, UNUserNotificationCenterDelegate {
    
    static func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("✅ Notification permission granted")
            } else if let error = error {
                print("❌ Notification permission error: \(error.localizedDescription)")
            }
        }
        
        // ✅ Set delegate so notifications appear in foreground
        center.delegate = NotificationHelper.shared
    }
    
    static let shared = NotificationHelper()
    
    static func showNotification(title: String, body: String, badge: Int? = nil, assetName: String? = nil, assetType: String? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        if let badge = badge {
            content.badge = NSNumber(value: badge)
        }

        if let assetName = assetName, let assetType = assetType,
           let attachment = attachmentFromAsset(named: assetName, type: assetType) {
            content.attachments = [attachment]
        }

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    
    static func attachmentFromAsset(named name: String, type: String) -> UNNotificationAttachment? {
        guard let image = UIImage(named: name) else {
            print("❌ Asset not found: \(name)")
            return nil
        }

        // Create a temporary file URL
        let tempDir = URL(fileURLWithPath: NSTemporaryDirectory())
        let fileURL = tempDir.appendingPathComponent("\(name).\(type)")

        // Save UIImage as data to the temp URL
        do {
            let data: Data
            switch type.lowercased() {
            case "png":
                data = image.pngData()!
            case "jpg", "jpeg":
                data = image.jpegData(compressionQuality: 1.0)!
            default:
                print("❌ Unsupported image type")
                return nil
            }

            try data.write(to: fileURL)
            return try UNNotificationAttachment(identifier: UUID().uuidString, url: fileURL, options: nil)
        } catch {
            print("❌ Failed to create attachment: \(error)")
            return nil
        }
    }


    
    // ✅ Foreground notifications
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

