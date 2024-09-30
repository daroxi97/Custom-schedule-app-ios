//
//  AppForegroundNotificationsDelegate.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 24/9/24.
//

import Foundation

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Show local notification in foreground
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}
