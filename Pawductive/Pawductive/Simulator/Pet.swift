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
    var maxMood: Double {
        Double(min(200, 100 + level * 10))
    }
    var moodDescription: String {
        switch self.mood {
        case 0 ... 0.25 * maxMood: 
            return "Angry"
        case 0.25 * maxMood ... 0.75 * maxMood: 
            return "Normal"
        case 0.75 * maxMood ... maxMood: 
            return "Happy"
        default: return ""
        }
    }
    func moodHalfLife(moodDecayModifier: Modifier?) -> Double {
        guard let moodDecayModifier else { return 1 }
        guard moodDecayModifier.label == "pet.mood" else { return 1 }
        let levelRatio = Double(moodDecayModifier.level) / Double(moodDecayModifier.maxLevel)
        return 1.0 + levelRatio * 1.0
    }
    
    var energy: Double
    var maxEnergy: Double {
        Double(min(200, 100 + level * 10))
    }
    var energyDescription: String {
        switch self.energy {
        case 0 ... 0.25 * maxEnergy: 
            return "Low"
        case 0.25 * maxEnergy ... 0.75 * maxEnergy: 
            return "Average"
        case 0.75 * maxEnergy ... maxEnergy: 
            return "High"
        default: return ""
        }
    }
    func dailyEnergyConsumption(energyDecayModifier: Modifier?) -> Double {
        guard let energyDecayModifier else { return 0.2 * maxEnergy }
        guard energyDecayModifier.label == "pet.energy" else { return 0.2 * maxEnergy }
        let levelRatio = Double(energyDecayModifier.level) / Double(energyDecayModifier.maxLevel)
        return (0.2 * maxEnergy) * (1.0 - levelRatio * 0.5)
    }
    
    var maxLevel: Int = 11
    var maxExperiencePoints: Double = 30000
    var levelCoefficient: Double {
        maxExperiencePoints / pow(Double(maxLevel), 2)
    }
    
    var totalExperiencePoints: Int
    var level: Int {
        let currentLevel = Int(sqrt(Double(totalExperiencePoints) / levelCoefficient))
        return currentLevel > maxLevel ? maxLevel : currentLevel
    }
    func experiencePointsAt(_ level: Int) -> Int {
        return Int(ceil(levelCoefficient * pow(Double(level), 2)))
    }
    var currentExperiencePoints: Int {
        return totalExperiencePoints - experiencePointsAt(level)
    }
    var pointsToNextLevel: Int {
        return experiencePointsAt(level + 1) - experiencePointsAt(level)
    }
    var currentProgress: Double {
        guard level < maxLevel else { return 1.0 }
        return Double(currentExperiencePoints) / Double(pointsToNextLevel)
    }
    
    var modifierPoints: Int {
        return 1 + level * 3
    }
    
    @Relationship var background: Background
    
    var isHibernating: Bool = false
    
    var totalFoodReceived: Int = 0
    var totalToysReceived: Int = 0
    var highMoodSince: Date?
    func highMoodStreak(now: Date) -> Int {
        guard let highMoodSince else { return 0 }
        return Calendar.current.dateComponents([.day], from: highMoodSince, to: now).day!
    }
    var maxHighMoodStreak: Int = 0
    var highEnergySince: Date?
    func highEnergyStreak(now: Date) -> Int {
        guard let highEnergySince else { return 0 }
        return Calendar.current.dateComponents([.day], from: highEnergySince, to: now).day!
    }
    var maxHighEnergyStreak: Int = 0
    
    init(name: String = "DOG", mood: Double = 100, energy: Double = 100, experiencePoints: Int = 0, background: Background) {
        self.name = name
        self.mood = mood
        self.energy = energy
        self.totalExperiencePoints = experiencePoints
        self.background = background
        
        self.ageInDays = 0
        self.createdOn = Date.now
        self.lastUpdatedOn = Date.now
        self.highMoodSince = (mood > maxMood * 0.25) ? Date.now : nil
        self.highEnergySince = (energy > maxEnergy * 0.25) ? Date.now : nil
    }

    var state = PetState.resting

    var image: ImageResource {
        switch self.state {
        case .eating:
            return .eating
        case .playing:
            return .playing
        case .resting:
            if self.energyDescription == "Low" {
                return .sleeping
            }
            switch self.moodDescription {
            case "Angry":
                return .angry
            case "Happy":
                return .happy
            default:
                return .normal
            }
        }
    }
    
    func canReceive(food: Food) -> Bool {
        return self.energy < maxEnergy
    }
    
    func receive(food: Food, moodModifier: Modifier?, energyModifier: Modifier?) {
        guard canReceive(food: food) else { return }
        self.mood = min(self.mood + food.moodEffects(moodModifier: moodModifier), maxMood)
        self.energy = min(self.energy + food.energyEffects(energyModifier: energyModifier), maxEnergy)
        self.totalExperiencePoints += food.experiencePoints
        self.totalFoodReceived += 1
    }
    
    func canReceive(toy: Toy, energyModifier: Modifier?) -> Bool {
        return self.mood < maxMood && self.energy + toy.energyEffects(energyModifier: energyModifier) >= 0
    }
    
    func receive(toy: Toy, moodModifier: Modifier?, energyModifier: Modifier?) {
        guard canReceive(toy: toy, energyModifier: energyModifier) else { return }
        self.mood = min(self.mood + toy.moodEffects(moodModifier: moodModifier), maxMood)
        self.energy = self.energy + toy.energyEffects(energyModifier: energyModifier)
        self.totalExperiencePoints += toy.experiencePoints
        self.totalToysReceived += 1
    }
    
    func update(currDate: Date, moodDecayModifier: Modifier?, energyDecayModifier: Modifier?) {
        guard currDate >= lastUpdatedOn else { return }
        if !isHibernating {
            self.updateMood(currDate, moodDecayModifier)
            self.updateEnergy(currDate, energyDecayModifier)
        }
        self.updateAge(currDate)
        
        if self.mood <= maxMood * 0.25 {
            highMoodSince = nil
        } else if highMoodSince == nil {
            highMoodSince = currDate
        }
        maxHighMoodStreak = max(maxHighMoodStreak, highMoodStreak(now: currDate))
        
        if self.energy <= maxEnergy * 0.25 {
            highEnergySince = nil
        } else if highEnergySince == nil {
            highEnergySince = currDate
        }
        maxHighEnergyStreak = max(maxHighEnergyStreak, highEnergyStreak(now: currDate))
        
        lastUpdatedOn = currDate
    }
    
    private func updateMood(_ currDate: Date, _ moodDecayModifier: Modifier?) {
        let daysPassed: Double = (currDate).timeIntervalSince(lastUpdatedOn) / (24 * 3600.0)
        self.mood = mood / pow(2.0, daysPassed / moodHalfLife(moodDecayModifier: moodDecayModifier))
    }

    private func updateEnergy(_ currDate: Date, _ energyDecayModifier: Modifier?) {
        let daysPassed: Double = (currDate).timeIntervalSince(lastUpdatedOn) / (24 * 3600.0)
        self.energy = max(0, energy - dailyEnergyConsumption(energyDecayModifier: energyDecayModifier) * daysPassed)
    }
    
    private func updateAge(_ currDate: Date) {
        self.ageInDays = Calendar.current.dateComponents([.day], from: createdOn, to: currDate).day ?? 0
    }
    
    func lowMoodFutureDate(moodDecayModifier: Modifier?) -> Date? {
        let lowMood = 0.25 * maxMood
        guard self.mood > lowMood && !isHibernating else { return nil }
        let daysToLowMood = moodHalfLife(moodDecayModifier: moodDecayModifier) * log2(self.mood / lowMood)
        return self.lastUpdatedOn.addingTimeInterval(daysToLowMood * 24 * 60 * 60)
    }
    
    func lowEnergyFutureDate(energyDecayModifier: Modifier?) -> Date? {
        let lowEnergy = 0.25 * maxEnergy
        guard self.energy > lowEnergy && !isHibernating else { return nil }
        let daysToLowEnergy = (self.energy - lowEnergy) / dailyEnergyConsumption(energyDecayModifier: energyDecayModifier)
        return self.lastUpdatedOn.addingTimeInterval(daysToLowEnergy * 24 * 60 * 60)
    }
}

enum PetState: String, Codable {
    case eating, playing, resting
}
