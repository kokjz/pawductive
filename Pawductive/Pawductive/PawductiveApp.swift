//
//  PawductiveApp.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 17/5/26.
//

import SwiftUI
import SwiftData
import UserNotifications

@main
struct PawductiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        if settings.authorizationStatus == .notDetermined {
                            requestNotificationPermission()
                        }
                    }
                }
        }
        .modelContainer(DataContainer(user: UserProfile(coins: 0), loadInventory: false, inMemory: false).modelContainer)
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            print("Granted:", granted)
        }
    }
}
