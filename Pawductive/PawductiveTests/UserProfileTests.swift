//
//  UserProfileTests.swift
//  PawductiveTests
//
//  Created by Lee Zi Rong on 29/5/26.
//

import Testing
@testable import Pawductive

struct UserProfileTests {
    let foodCostModifier = Modifier(label: "food.cost", name: "Lower Price", details: "Decrease cost of food", level: 0, maxLevel: 2)
    let toyCostModifier = Modifier(label: "toy.cost", name: "Lower Price", details: "Decrease cost of toys", level: 0, maxLevel: 2)
    
    @Test @MainActor func testCanAfford() async throws {
        let user = UserProfile(coins: 100)
        #expect(user.canAfford(cost: 0))
        #expect(user.canAfford(cost: 100))
        #expect(!user.canAfford(cost: 101))
    }
    
    @Test @MainActor func testBuyFood() async throws {
        let user = UserProfile(coins: 50)
        
        // Spend 30 coins
        user.buy(food: .chickenDrumstick, costModifier: foodCostModifier)
        #expect(user.coins == 20)
        #expect(user.foodInventory[Food.chickenDrumstick.name] == 1)
        
        // Insufficent coins
        user.buy(food: .chickenDrumstick, costModifier: foodCostModifier) // Cost 30 coins
        #expect(user.coins == 20)
        #expect(user.foodInventory[Food.chickenDrumstick.name] == 1)
        
        // Spend 10 coins
        user.buy(food: .pumpkin, costModifier: foodCostModifier)
        #expect(user.coins == 10)
        #expect(user.foodInventory[Food.pumpkin.name] == 1)
        
        // Spend 10 coins
        user.buy(food: .pumpkin, costModifier: foodCostModifier)
        #expect(user.coins == 0)
        #expect(user.foodInventory[Food.pumpkin.name] == 2)
        
        // Insufficient coins
        user.buy(food: .corn, costModifier: foodCostModifier) // Cost 5 coins
        #expect(user.coins == 0)
        #expect(user.foodInventory[Food.corn.name] == nil)
    }
    
    @Test @MainActor func testBuyToys() async throws {
        let user = UserProfile(coins: 100)
        
        // Spend 80 coins
        user.buy(toy: .rubberDuck, costModifier: toyCostModifier)
        #expect(user.coins == 20)
        #expect(user.toyInventory[Toy.rubberDuck.name] == 1)
        
        // Insufficient Coins
        user.buy(toy: .frisbee, costModifier: toyCostModifier) // Cost 30 coins
        #expect(user.coins == 20)
        #expect(user.toyInventory[Toy.frisbee.name] == nil)
        
        // Spend 10 coins
        user.buy(toy: .tennisBall, costModifier: toyCostModifier)
        #expect(user.coins == 10)
        #expect(user.toyInventory[Toy.tennisBall.name] == 1)
        
        // Spend 10 coins
        user.buy(toy: .tennisBall, costModifier: toyCostModifier)
        #expect(user.coins == 0)
        #expect(user.toyInventory[Toy.tennisBall.name] == 2)
        
        // Insufficient coins
        user.buy(toy: .treeBranch, costModifier: toyCostModifier) // Cost 5 coins
        #expect(user.coins == 0)
        #expect(user.toyInventory[Toy.treeBranch.name] == nil)
    }

    @Test @MainActor func testGiveFood() async throws {
        let user = UserProfile()
        user.foodInventory[Food.corn.name] = 2
        
        user.give(food: .corn)
        #expect(user.foodInventory[Food.corn.name] == 1)
        
        user.give(food: .corn)
        #expect(user.foodInventory[Food.corn.name] == nil)
        
        user.give(food: .corn)
        #expect(user.foodInventory[Food.corn.name] == nil)
    }
    
    @Test @MainActor func testGiveToy() async throws {
        let user = UserProfile()
        user.toyInventory[Toy.frisbee.name] = 2
        
        user.give(toy: .frisbee)
        #expect(user.toyInventory[Toy.frisbee.name] == 1)
        
        user.give(toy: .frisbee)
        #expect(user.toyInventory[Toy.frisbee.name] == nil)
        
        user.give(toy: .frisbee)
        #expect(user.toyInventory[Toy.frisbee.name] == nil)
    }
}
