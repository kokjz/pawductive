//
//  ContentView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    //access database to fetch userstats
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [UserStats]
    
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
        }
        .accentColor(.orange)
        
        //first launch check
        .onAppear {
            firstTimeStatInit()
        }
    }
    
    //helper fn for first-time stat init
    private func firstTimeStatInit() {
        if stats.isEmpty {
            let initStats = UserStats()
            modelContext.insert(initStats)
            try? modelContext.save()
            print("Default user stats initialised success")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(DataContainer().modelContainer)
}
