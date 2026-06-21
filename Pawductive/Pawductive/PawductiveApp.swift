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
        }
        .modelContainer(DataContainer(coins: 0, loadInventory: false, loadDecorations: false, inMemory: false).modelContainer)
    }
}
