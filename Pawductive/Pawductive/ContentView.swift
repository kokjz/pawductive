//
//  ContentView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

import WidgetKit
import SwiftUI
import SwiftData

enum TabKind: Hashable {
    case tasks, pet, shop, profile
}

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
    
    @State private var selectedTab: TabKind = .tasks
    
    var body: some View {
        //tab view at bottom of screen
        TabView(selection: $selectedTab) {
            //tab 1: task queue and timer
            NavigationStack {
                TaskQueueView()
            }
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }
            .tag(TabKind.tasks)
            
            //tab 2: pet simulator
            NavigationStack {
                PetSimulatorView()
            }
            .tabItem{
                Label("Pet", systemImage: "pawprint.circle.fill")
            }
            .tag(TabKind.pet)
            
            //tab 3: shop view
            ShopView()
                .tabItem {
                    Label("Shop", systemImage: "bag.fill")
                }
                .tag(TabKind.shop)
            
            //tab 4: profile view
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.circle.fill")
            }
            .tag(TabKind.profile)
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
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
        .onOpenURL { url in
            guard let tab = url.tabKind else { return }
            self.selectedTab = tab
        }
    }
}

extension URL {
    var isDeepLink: Bool {
        return scheme == "pawductive"
    }
    
    var tabKind: TabKind? {
        guard isDeepLink else { return nil }
        
        switch host {
        case "tasks": return .tasks
        case "pet": return .pet
        case "shop": return .shop
        case "profile": return .profile
        default: return nil
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(DataContainer(experiencePoints: 33000).modelContainer)
}
