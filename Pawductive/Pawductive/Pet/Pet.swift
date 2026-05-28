//
//  Pet.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 22/5/26.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Pet {
    var name: String
    var createdOn: Date
    var ageInDays: Int
    
    var mood: Double
    var maxMood: Double = 100
    var energy: Double
    var maxEnergy: Double = 100
    
    var lastUpdatedOn: Date
    
    init(name: String = "<name>", mood: Double = 100, energy: Double = 100) {
        self.name = name
        self.mood = mood
        self.energy = energy
        self.ageInDays = 0
        
        let currDate = Date.now
        self.createdOn = currDate
        self.lastUpdatedOn = currDate
    }

    // Taken From: https://www.magnific.com/free-vector/kawaii-happy-shiba-inu-dog-doing-various-activities_9925813.htm
    var image: ImageResource {
        switch self.mood {
        case 0...25:
            return .unhappy
        case 75...100:
            return .happy
        default:
            return .standing
        }
    }
    
    func canReceive(food: FoodCatalog) -> Bool {
        return self.energy < maxEnergy
    }
    
    func receive(food: FoodCatalog) {
        guard canReceive(food: food) else { return }
        self.mood = min(self.mood + food.changeMood, maxMood)
        self.energy = min(self.energy + food.changeEnergy, maxEnergy)
    }
    
    func canReceive(toy: ToyCatalog) -> Bool {
        return self.mood < maxMood && self.energy + toy.changeEnergy >= 0
    }
    
    func receive(toy: ToyCatalog) {
        guard canReceive(toy: toy) else { return }
        self.mood = min(self.mood + toy.changeMood, maxMood)
        self.energy = self.energy + toy.changeEnergy
    }
    
    func update(currDate: Date) {
        guard currDate >= lastUpdatedOn else { return }
        self.updateMood(currDate)
        self.updateEnergy(currDate)
        self.updateAge(currDate)
        lastUpdatedOn = currDate
    }
    
    private func updateMood(_ currDate: Date) {
        let halfLife: Double = 1.0 // Days required to reduce mood to half its current value
        let daysPassed: Double = (currDate).timeIntervalSince(lastUpdatedOn) / (24 * 3600.0)
        self.mood = mood / pow(2.0, daysPassed / halfLife)
    }
    
    private func updateEnergy(_ currDate: Date) {
        let dailyConsumption: Double = 20.0 // Amount of energy consumed in one day
        let daysPassed: Double = (currDate).timeIntervalSince(lastUpdatedOn) / (24 * 3600.0)
        self.energy = max(0, energy - dailyConsumption * daysPassed)
    }
    
    private func updateAge(_ currDate: Date) {
        self.ageInDays = Calendar.current.dateComponents([.day], from: createdOn, to: currDate).day ?? 0
    }
}
