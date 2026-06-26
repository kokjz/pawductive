//
//  ContentView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @Query private var notificationManagers: [NotificationManager]
    private var notificationManager: NotificationManager {
        notificationManagers.first!
    }
    
    @Query private var pets: [Pet]
    private var pet: Pet {
        pets.first!
    }
    
    @Query private var userStatsList: [UserStats]
    private var userStats: UserStats {
        userStatsList.first!
    }
    
    @Query private var modifiers: [Modifier]
    private var moodDecayModifier: Modifier? {
        modifiers.first(where: { $0.label == "pet.mood" })
    }
    private var energyDecayModifier: Modifier? {
        modifiers.first(where: { $0.label == "pet.energy" })
    }
    
    var body: some View {
        //tab view at bottom of screen
        TabView {
            //tab 1: task queue and timer
            NavigationStack {
                TaskQueueView()
            }
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }
            
            //tab 2: pet simulator
            NavigationStack {
                PetSimulatorView()
            }
            .tabItem{
                Label("Pet", systemImage: "pawprint.circle.fill")
            }
            
            //tab 3: shop view
            ShopView()
                .tabItem {
                    Label("Shop", systemImage: "bag.fill")
                }
            
            //tab 4: profile view
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle.fill")
            }
        }
        .accentColor(.orange)
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                notificationManager.scheduleNotifications(
                    userStats: userStats,
                    pet: pet,
                    moodDecayModifier: moodDecayModifier,
                    energyDecayModifier: energyDecayModifier
                )
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(DataContainer(experiencePoints: 33000).modelContainer)
}
