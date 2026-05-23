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
    
    func buy(food: FoodCatalog) {
        guard canAfford(food.cost) else { return }
        self.coins -= food.cost
        foodInventory[food, default: 0] += 1
    }
    
    func buy(toy: ToyCatalog) {
        guard canAfford(toy.cost) else { return }
        self.coins -= toy.cost
        toyInventory[toy, default: 0] += 1
    }
    
    func give(food: FoodCatalog) {
        guard let count = foodInventory[food], count > 0 else { return }
        if count == 1 {
            foodInventory.removeValue(forKey: food)
        } else {
            foodInventory[food] = count - 1
        }
    }
    
    func give(toy: ToyCatalog) {
        guard let count = toyInventory[toy], count > 0 else { return }
        if count == 1 {
            toyInventory.removeValue(forKey: toy)
        } else {
            toyInventory[toy] = count - 1
        }
    }
}
