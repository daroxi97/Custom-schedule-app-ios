//
//  PushAlertUseCase.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 21/9/24.
//

import Foundation
import UserNotifications
class PushAlertUseCase {
    
    /*
     func checkForPermission (){
     let notificationCenter = UNUserNotificationCenter.current()
     notificationCenter.getNotificationSettings { settings in
     switch settings.authorizationStatus{
     case .authorized:
     self.dispatchNotification()
     case .denied:
     return
     case .notDetermined:
     notificationCenter.requestAuthorization(options: [.alert, .sound]) { didAllow, error in
     if didAllow {
     self.dispatchNotification()
     }
     
     }
     default:
     return
     }
     }
     }
     
     func dispatchNotification (){
     let identifier = "notificacio"
     let title = "molt de sexe"
     let body = "mmmmmmm"
     let hour = 23
     let minute = 51
     let isDaily =  true
     let notificationCenter = UNUserNotificationCenter.current()
     let content = UNMutableNotificationContent()
     content.title = title
     content.body = body
     content.sound = .default
     let calendar = Calendar.current
     var dateComponents = DateComponents (calendar: calendar, timeZone: TimeZone.current)
     dateComponents.hour = hour
     dateComponents.minute = minute
     
     let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: isDaily)
     let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
     
     notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
     notificationCenter.add(request)
     }
     */
    func askPermission() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("Access granted!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func sendNotification(date: Date, type: String, timeInterval: Double = 10, title: String, body: String, alarm: Bool) {
        var trigger: UNNotificationTrigger?
        // Create a trigger (either from date or time based)
        if type == "date" {
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date)
            trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        } else if type == "time" {
            trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        }
        
        // Customise the content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if (alarm){
            content.sound = UNNotificationSound(named: UNNotificationSoundName("alarm sound.wav"))
            
        } else {
            content.sound = UNNotificationSound.default
            
        }
        
        // Create the request
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}
