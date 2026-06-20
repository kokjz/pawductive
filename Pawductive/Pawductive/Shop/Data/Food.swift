//
//  Food.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 5/6/26.
//

import Foundation
import SwiftData
import SwiftUI

@Observable
class Food: Identifiable {
    var id = UUID()
    var name: String
    var value: Double
    var image: ImageResource
    
    var costModifier: Modifier?
    var cost: Int {
        guard let costModifier else { return Int(value) }
        return Int(Double(value) * (1.0 - Double(costModifier.level) * 0.2))
    }
    
    var moodModifier: Modifier?
    var moodEffects: Double {
        guard let moodModifier else { return value / 5.0 }
        let levelRatio = Double(moodModifier.level) / Double(moodModifier.maxLevel)
        return (value / 5.0) * (1.0 + levelRatio * 1.0)
    }
    
    var energyModifier: Modifier?
    var energyEffects: Double {
        guard let energyModifier else { return value }
        let levelRatio = Double(energyModifier.level) / Double(energyModifier.maxLevel)
        return value * (1.0 + levelRatio * 1.0)
    }
    
    var experiencePoints: Int {
        return Int(value);
    }
    
    private init(name: String, value: Double, image: ImageResource) {
        self.name = name
        self.value = value
        self.image = image
    }
}

extension Food {
    static let allFoods: [Food] = [.corn, .pumpkin, .chickenEgg, .chickenWing, .chickenDrumstick, .porkBelly]
    static let corn = Food(name: "Corn", value: 5, image: .corn)
    static let pumpkin = Food(name: "Pumpkin", value: 10, image: .pumpkin)
    static let chickenEgg = Food(name: "Chicken Egg", value: 15, image: .chickenEgg)
    static let chickenWing = Food(name: "Chicken Wing", value: 25, image: .chickenWing)
    static let chickenDrumstick = Food(name: "Chicken Drumstick", value: 30, image: .chickenDrumstick)
    static let porkBelly = Food(name: "Pork Belly", value: 50, image: .porkBelly)
}
