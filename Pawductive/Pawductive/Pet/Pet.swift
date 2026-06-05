//
//  Pet.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 22/5/26.
//

import Foundation
import SwiftData
import SwiftUI
import UserNotifications

@Model
class Pet {
    var name: String
    var ageInDays: Int
    var createdOn: Date
    var lastUpdatedOn: Date
    
    var mood: Double
    var maxMood: Double = 100
    var moodDescription: String {
        switch self.mood {
        case 0 ... 0.25 * maxMood: return "Depressed"
        case 0.25 * maxMood ... 0.50 * maxMood: return "Anxious"
        case 0.50 * maxMood ... 0.75 * maxMood: return "Normal"
        case 0.75 * maxMood ... maxMood: return "Happy"
        default: return ""
        }
    }
    
    var moodDecayModifier: Modifier?
    var moodHalfLife: Double {
        guard let moodDecayModifier else { return 1 }
        return 1 + Double(moodDecayModifier.level) * 0.2
    }
    
    var energy: Double
    var maxEnergy: Double = 100
    var energyDescription: String {
        switch self.energy {
        case 0 ... 0.25 * maxEnergy: return "Low"
        case 0.25 * maxEnergy ... 0.75 * maxEnergy: return "Average"
        case 0.75 * maxEnergy ... maxEnergy: return "High"
        default: return ""
        }
    }
    
    var energyDecayModifier: Modifier?
    var dailyEnergyConsumption: Double {
        guard let energyDecayModifier else { return 20 }
        return 20 - Double(energyDecayModifier.level) * 2
    }
    
    init(name: String = "Dog", mood: Double = 100, energy: Double = 100) {
        self.name = name
        self.mood = mood
        self.energy = energy
        
        self.ageInDays = 0
        self.createdOn = Date.now
        self.lastUpdatedOn = Date.now
    }

    // Taken From: https://www.magnific.com/free-vector/kawaii-happy-shiba-inu-dog-doing-various-activities_9925813.htm
    var image: ImageResource {
        switch self.moodDescription {
        case "Happy":
            return .happy
        case "Depressed":
            return .unhappy
        default:
            return .standing
        }
    }
    
    func canReceive(food: Food) -> Bool {
        return self.energy < maxEnergy
    }
    
    func receive(food: Food) {
        guard canReceive(food: food) else { return }
        self.mood = min(self.mood + food.moodEffects, maxMood)
        self.energy = min(self.energy + food.energyEffects, maxEnergy)
    }
    
    func canReceive(toy: Toy) -> Bool {
        return self.mood < maxMood && self.energy + toy.energyEffects >= 0
    }
    
    func receive(toy: Toy) {
        guard canReceive(toy: toy) else { return }
        self.mood = min(self.mood + toy.moodEffects, maxMood)
        self.energy = self.energy + toy.energyEffects
    }
    
    func update(currDate: Date) {
        guard currDate >= lastUpdatedOn else { return }
        self.updateMood(currDate)
        self.updateEnergy(currDate)
        self.updateAge(currDate)
        lastUpdatedOn = currDate
        scheduleNotifications()
    }
    
    private func updateMood(_ currDate: Date) {
        let daysPassed: Double = (currDate).timeIntervalSince(lastUpdatedOn) / (24 * 3600.0)
        self.mood = mood / pow(2.0, daysPassed / moodHalfLife)
    }

    private func updateEnergy(_ currDate: Date) {
        let daysPassed: Double = (currDate).timeIntervalSince(lastUpdatedOn) / (24 * 3600.0)
        self.energy = max(0, energy - dailyEnergyConsumption * daysPassed)
    }
    
    private func updateAge(_ currDate: Date) {
        self.ageInDays = Calendar.current.dateComponents([.day], from: createdOn, to: currDate).day ?? 0
    }
    
    private func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        
        // Obtain the notification settings.
        center.getNotificationSettings { settings in
            
            // Verify the authorization status.
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
            
            // Remove outdated notification requests.
            center.removePendingNotificationRequests(
                withIdentifiers: ["pet.lowMood", "pet.lowEnergy"]
            )
            
            // Schedule low mood notification.
            if let date = self.lowMoodFutureDate() {
                center.add(self.notification(
                    identifier: "pet.lowMood",
                    title: "\(self.name) is sad 😔",
                    body: "Give \(self.name) some toys!",
                    futureDate: date
//                    futureDate: Date().addingTimeInterval(10) // FOR TESTING ONLY
                ))
            }
            
            // Schedule low energy notification.
            if let date = self.lowEnergyFutureDate() {
                center.add(self.notification(
                    identifier: "pet.lowEnergy",
                    title: "\(self.name) is hungry 🤤",
                    body: "Give \(self.name) some food!",
                    futureDate: date
//                    futureDate: Date().addingTimeInterval(10) // FOR TESTING ONLY
                ))
            }
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
    
    private func lowMoodFutureDate() -> Date? {
        let lowMood = 0.25 * maxMood
        guard self.mood > lowMood else { return nil }
        let daysToLowMood = moodHalfLife * log2(self.mood / lowMood)
        return self.lastUpdatedOn.addingTimeInterval(daysToLowMood * 24 * 60 * 60)
    }
    
    private func lowEnergyFutureDate() -> Date? {
        let lowEnergy = 0.25 * maxEnergy
        guard self.energy > lowEnergy else { return nil }
        let daysToLowEnergy = (self.energy - lowEnergy) / dailyEnergyConsumption
        return self.lastUpdatedOn.addingTimeInterval(daysToLowEnergy * 24 * 60 * 60)
    }
}
