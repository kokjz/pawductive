//
//  ContentView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
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
            PetSimulatorView()
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
    }
}

#Preview {
    ContentView()
        .modelContainer(DataContainer().modelContainer)
}
