//
//  UserProfile.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

import Foundation
import SwiftData

@Model
class UserProfile {
    var id: UUID
    var coins: Int
    var foodInventory: [FoodCatalog: Int] = [:]
    var toyInventory: [ToyCatalog: Int] = [:]
    
    init(coins: Int = 100) {
        self.id = UUID()
        self.coins = coins
    }
    
    func canAfford(_ cost: Int) -> Bool {
        return self.coins >= cost
    }
    
    func buyFood(_ food: FoodCatalog) {
        guard canAfford(food.cost) else { return }
        self.coins -= food.cost
        foodInventory[food, default: 0] += 1
    }
    
    func buyToy(_ toy: ToyCatalog) {
        guard canAfford(toy.cost) else { return }
        self.coins -= toy.cost
        toyInventory[toy, default: 0] += 1
    }
}
