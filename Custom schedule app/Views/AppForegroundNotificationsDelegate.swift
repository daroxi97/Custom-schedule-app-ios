//
//  AppForegroundNotificationsDelegate.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 24/9/24.
//

import Foundation
import SwiftUI

 class AppDelegate: NSObject, UIApplicationDelegate , UNUserNotificationCenterDelegate{
 
 func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
 // Show local notification in foreground
 UNUserNotificationCenter.current().delegate = self
 
 return true
 }
 
 func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 completionHandler([.alert, .badge, .sound])
 }
 
 }
