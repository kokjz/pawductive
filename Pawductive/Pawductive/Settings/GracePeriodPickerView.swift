//
//  GracePeriodPickerView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 24/6/26.
//

import SwiftUI

struct GracePeriodPickerView: View {
    @State private var settingsManager = SettingsManager.shared
    @State private var selectedMinutes: Int = 0
    @State private var selectedSeconds: Int = 0
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    //mins wheel
                    HStack(spacing: 0) {
                        Picker("Minutes", selection: $selectedMinutes) {
                            ForEach(0...9, id: \.self) { minute in
                                Text("\(minute)").tag(minute)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 70)
                        Text("min")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    //secs wheel
                    HStack(spacing: 0) {
                        Picker("Seconds", selection: $selectedSeconds) {
                            ForEach(0...59, id: \.self) { second in
                                Text("\(second)").tag(second)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 70)
                        
                        Text("sec")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                .frame(height: 160)
            } header: {
                Text("Set Grace Period Duration")
            } footer: {
                Text("The focus timer will remain paused when you switch out of the app. You must return within the set grace period, or the session will fail. To have the session fail instantly on switching out, leave this set at 0min 0sec.")
            }
        }
        .navigationTitle("Grace Period")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            let totalSeconds = settingsManager.gracePeriodSeconds
            selectedMinutes = totalSeconds / 60
            selectedSeconds = totalSeconds % 60
        }
        .onChange(of: selectedMinutes) { _, _ in
            updateGracePeriod()
        }
        .onChange(of: selectedSeconds) { _, _ in
            updateGracePeriod()
        }
    }
    
    private func updateGracePeriod() {
        let totalSeconds = (selectedMinutes * 60) + selectedSeconds
        settingsManager.gracePeriodSeconds = totalSeconds
    }
}

#Preview {
    NavigationStack {
        GracePeriodPickerView()
    }
}
