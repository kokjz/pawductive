//
//  SettingsManagerView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 23/6/26.
//

import SwiftUI
import SwiftData

struct SettingsManagerView: View {
    @State private var settingsManager = SettingsManager.shared
    @State private var showHibernationAlert: Bool = false
    @Query private var pets: [Pet]
    private var pet: Pet {
        return pets.first!
    }
    
    var body: some View {
        @Bindable var settingsManager = settingsManager
        @Bindable var pet = pet
        Form {
            Section("Timer Configuration") {
                Toggle("Enable Timer Pausing", isOn: $settingsManager.isTimerPauseEnabled)
                NavigationLink(destination: GracePeriodPickerView()) {
                    HStack {
                        Text("App Switchout Grace Period")
                        Spacer()
                        Text(formatGracePeriod(settingsManager.gracePeriodSeconds)).foregroundColor(.secondary)
                    }
                }
            }
            
            Section("Task Categories") {
                NavigationLink(destination: CategoryManagerView()) {
                    HStack {
                        Text("Manage Categories")
                        Spacer()
                    }
                }
            }
            
            Section("Simulator Settings") {
                Toggle("Enable Hibernation", isOn: $pet.isHibernating)
                    .onChange(of: pet.isHibernating) { oldValue, newValue in
                        if !oldValue && newValue {
                            showHibernationAlert = true
                        }
                    }
            }
            .alert("Pet Hibernation Alert", isPresented: $showHibernationAlert) {
                Button("Cancel", role: .cancel) {
                    pet.isHibernating = false
                }
                Button("Confirm") {}
            } message: {
                Text("Mood and energy levels will not decay. Press confirm if you wish to proceed.")
            }
        }
        .navigationTitle("Manage Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func formatGracePeriod(_ seconds: Int) -> String {
        if seconds == 0 { return "Instant Failure" }
        let mins = seconds / 60
        let secs = seconds % 60
        if mins == 0 { return "\(secs)s" } else { return "\(mins)m \(secs)s" }
    }
}

#Preview {
    NavigationStack {
        SettingsManagerView()
    }
    .modelContainer(DataContainer().modelContainer)
}
