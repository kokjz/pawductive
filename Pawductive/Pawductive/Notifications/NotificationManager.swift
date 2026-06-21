//
//  NotificationManager.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/6/26.
//

import Foundation
import SwiftData
import UserNotifications

@Model
class NotificationManager {
    var showLowMoodNotification: Bool
    var showLowEnergyNotification: Bool
    var showStreakExpiringNotification: Bool
    var minutesBeforeStreakExpires: Int = 60
    
    init(showLowMoodNotification: Bool = false,
         showLowEnergyNotification: Bool = false,
         showStreakExpiringNotification: Bool = false,
         minutesBeforeStreakExpires: Int = 60
    ) {
        self.showLowMoodNotification = showLowMoodNotification
        self.showLowEnergyNotification = showLowEnergyNotification
        self.showStreakExpiringNotification = showStreakExpiringNotification
        self.minutesBeforeStreakExpires = minutesBeforeStreakExpires
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound]
        ) { granted, error in
            print("Granted:", granted)
        }
    }
    
    func scheduleNotifications(pet: Pet, userStats: UserStats) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        if showLowMoodNotification {
            scheduleLowMoodNotification(pet: pet)
        }
        
        if showLowEnergyNotification {
            scheduleLowEnergyNotification(pet: pet)
        }
        
        if showStreakExpiringNotification {
            scheduleStreakExpiringNotification(userStats: userStats)
        }
    }
    
    private func scheduleLowMoodNotification(pet: Pet) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized)
                    || (settings.authorizationStatus == .provisional) else { return }
            
            guard let futureDate = pet.lowMoodFutureDate() else { return }
            
            center.add(self.notification(
                identifier: "pet.lowMood",
                title: "\(pet.name.capitalized) is angry 😠",
                body: "Give \(pet.name.lowercased()) some toys!",
                futureDate: futureDate
            ))
            
            print("Scheduled notification for low mood at \(futureDate.formatted())")
        }
    }
    
    private func scheduleLowEnergyNotification(pet: Pet) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized)
                    || (settings.authorizationStatus == .provisional) else { return }
            
            guard let futureDate = pet.lowEnergyFutureDate() else { return }
            
            center.add(self.notification(
                identifier: "pet.lowEnergy",
                title: "\(pet.name.capitalized) is hungry 🤤",
                body: "Give \(pet.name.lowercased()) some food!",
                futureDate: futureDate
            ))
            
            print("Scheduled notification for low energy at \(futureDate.formatted())")
        }
    }
    
    private func scheduleStreakExpiringNotification(userStats: UserStats) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized)
                    || (settings.authorizationStatus == .provisional) else { return }
            
            guard let date = userStats.lastActiveDate else { return }
            let components = DateComponents(day: 2, minute: -1 * self.minutesBeforeStreakExpires)
            guard let futureDate = Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: date)) else { return }
            
            center.add(self.notification(
                identifier: "user.streakExpiring",
                title: "Streak expiring soon! 🥲",
                body: "Complete a task to keep your streak going",
                futureDate: futureDate
            ))
            
            print("Scheduled notification for streak expiry at \(futureDate.formatted())")
        }
    }
    
    private func notification(identifier: String, title: String, body: String, futureDate: Date) -> UNNotificationRequest {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: futureDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
}
