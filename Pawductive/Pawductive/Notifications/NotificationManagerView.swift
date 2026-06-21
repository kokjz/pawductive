//
//  NotificationManagerView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/6/26.
//

import SwiftUI
import SwiftData

struct NotificationManagerView: View {
    @Query private var notificationManagers: [NotificationManager]
    private var notificationManager: NotificationManager {
        notificationManagers.first!
    }
    
    var body: some View {
        @Bindable var notificationManager = notificationManager
        Form {
            Section("Pet") {
                Toggle("Notify when mood is low", isOn: $notificationManager.showLowMoodNotification)
                Toggle("Notify when energy is low", isOn: $notificationManager.showLowEnergyNotification)
            }
            
            Section("User") {
                Toggle("Notify before streak expires", isOn: $notificationManager.showStreakExpiringNotification)
                Picker("Before streak expires", selection: $notificationManager.minutesBeforeStreakExpires) {
                    Text("15 minutes").tag(15)
                    Text("30 minutes").tag(30)
                    Text("1 hour").tag(60)
                }
                .disabled(!notificationManager.showStreakExpiringNotification)
            }
        }
        .navigationTitle("Manage Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    NavigationStack {
        NotificationManagerView()
    }
    .modelContainer(DataContainer().modelContainer)
}
