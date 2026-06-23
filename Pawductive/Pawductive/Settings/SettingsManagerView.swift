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
            }
        }
        .navigationTitle("Manage Settings")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        SettingsManagerView()
    }
}
