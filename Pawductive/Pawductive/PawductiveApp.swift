//
//  PawductiveApp.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 17/5/26.
//

import SwiftUI
import SwiftData

@main
struct PawductiveApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(DataContainer(user: UserProfile(coins: 100), inMemory: false).modelContainer)
    }
}
