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
    var foodInventory: [String: Int] = [:]
    var toyInventory: [String: Int] = [:]
    
    init(coins: Int = 100) {
        precondition(coins >= 0)
        self.id = UUID()
        self.coins = coins
    }
    
    func canAfford(cost: Int) -> Bool {
        precondition(cost >= 0)
        return self.coins >= cost
    }
    
    func buy(food: Food) {
        guard canAfford(cost: food.cost) else { return }
        self.coins -= food.cost
        foodInventory[food.name, default: 0] += 1
    }
    
    func buy(toy: Toy) {
        guard canAfford(cost: toy.cost) else { return }
        self.coins -= toy.cost
        toyInventory[toy.name, default: 0] += 1
    }
    
    func give(food: Food) {
        guard let count = foodInventory[food.name], count > 0 else { return }
        if count == 1 {
            foodInventory.removeValue(forKey: food.name)
        } else {
            foodInventory[food.name] = count - 1
        }
    }
    
    func give(toy: Toy) {
        guard let count = toyInventory[toy.name], count > 0 else { return }
        if count == 1 {
            toyInventory.removeValue(forKey: toy.name)
        } else {
            toyInventory[toy.name] = count - 1
        }
    }
}
