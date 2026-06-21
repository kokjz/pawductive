//
//  Toy.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 5/6/26.
//


import Foundation
import SwiftData
import SwiftUI

@Observable
class Toy: Identifiable {
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
        guard let moodModifier else { return value }
        let levelRatio = Double(moodModifier.level) / Double(moodModifier.maxLevel)
        return value * (1.0 + levelRatio * 1.0)
    }
    
    var energyModifier: Modifier?
    var energyEffects: Double {
        guard let energyModifier else { return -1 * (value / 5.0) }
        let levelRatio = Double(energyModifier.level) / Double(energyModifier.maxLevel)
        return -1 * (value / 5.0) * (1.0 - levelRatio * 0.5)
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

extension Toy {
    static let allToys: [Toy] = [.treeBranch, .tennisBall, .kitchenTowel, .frisbee, .rubberDuck]
    static let treeBranch = Toy(name: "Tree Branch", value: 5, image: .treeBranch)
    static let tennisBall = Toy(name: "Tennis Ball", value: 10, image: .tennisBall)
    static let kitchenTowel = Toy(name: "Kitchen Towel", value: 20, image: .kitchenTowel)
    static let frisbee = Toy(name: "Frisbee", value: 40, image: .frisbee)
    static let rubberDuck = Toy(name: "Rubber Duck", value: 80, image: .rubberDuck)
}
