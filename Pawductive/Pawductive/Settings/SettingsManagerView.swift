//
//  SettingsManagerView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 23/6/26.
//

import SwiftUI

struct SettingsManagerView: View {
    @State private var settingsManager = SettingsManager.shared
    
    var body: some View {
        @Bindable var settingsManager = settingsManager
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
}
