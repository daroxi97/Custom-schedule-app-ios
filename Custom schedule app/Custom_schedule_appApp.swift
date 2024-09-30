//
//  Custom_schedule_appApp.swift
//  Custom schedule app
//
//  Created by Dan Roeniger Xiberta on 19/9/24.
//

import SwiftUI
import SwiftData

@main
struct Custom_schedule_appApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            BasicCalendarView()
        }
        .modelContainer(sharedModelContainer)
    }
}
