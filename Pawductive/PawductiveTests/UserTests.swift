//
//  UserTests.swift
//  PawductiveTests
//
//  Created by Lee Zi Rong on 29/5/26.
//

import Testing
@testable import Pawductive

struct UserTests {
    
    @Test @MainActor func testCanAfford() async throws {
        let user = UserProfile(coins: 100)
        #expect(user.canAfford(cost: 0))
        #expect(user.canAfford(cost: 100))
        #expect(!user.canAfford(cost: 101))
    }
    
    @Test @MainActor func testBuyFood() async throws {
        let user = UserProfile(coins: 50)
        
        // Spend 30 coins
        user.buy(food: .chickenDrumstick)
        #expect(user.coins == 20)
        #expect(user.foodInventory[.chickenDrumstick] == 1)
        
        // Insufficent coins
        user.buy(food: .chickenDrumstick) // Cost 30 coins
        #expect(user.coins == 20)
        #expect(user.foodInventory[.chickenDrumstick] == 1)
        
        // Spend 10 coins
        user.buy(food: .pumpkin)
        #expect(user.coins == 10)
        #expect(user.foodInventory[.pumpkin] == 1)
        
        // Spend 10 coins
        user.buy(food: .pumpkin)
        #expect(user.coins == 0)
        #expect(user.foodInventory[.pumpkin] == 2)
        
        // Insufficient coins
        user.buy(food: .corn) // Cost 5 coins
        #expect(user.coins == 0)
        #expect(user.foodInventory[.corn] == nil)
    }
    
    @Test @MainActor func testBuyToys() async throws {
        let user = UserProfile(coins: 100)
        
        // Spend 80 coins
        user.buy(toy: .rubberDuck)
        #expect(user.coins == 20)
        #expect(user.toyInventory[.rubberDuck] == 1)
        
        // Insufficient Coins
        user.buy(toy: .frisbee) // Cost 30 coins
        #expect(user.coins == 20)
        #expect(user.toyInventory[.frisbee] == nil)
        
        // Spend 10 coins
        user.buy(toy: .tennisBall)
        #expect(user.coins == 10)
        #expect(user.toyInventory[.tennisBall] == 1)
        
        // Spend 10 coins
        user.buy(toy: .tennisBall)
        #expect(user.coins == 0)
        #expect(user.toyInventory[.tennisBall] == 2)
        
        // Insufficient coins
        user.buy(toy: .treeBranch) // Cost 5 coins
        #expect(user.coins == 0)
        #expect(user.toyInventory[.treeBranch] == nil)
    }

    @Test @MainActor func testGiveFood() async throws {
        let user = UserProfile()
        user.foodInventory[.corn] = 2
        
        user.give(food: .corn)
        #expect(user.foodInventory[.corn] == 1)
        
        user.give(food: .corn)
        #expect(user.foodInventory[.corn] == nil)
        
        user.give(food: .corn)
        #expect(user.foodInventory[.corn] == nil)
    }
    
    @Test @MainActor func testGiveToy() async throws {
        let user = UserProfile()
        user.toyInventory[.frisbee] = 2
        
        user.give(toy: .frisbee)
        #expect(user.toyInventory[.frisbee] == 1)
        
        user.give(toy: .frisbee)
        #expect(user.toyInventory[.frisbee] == nil)
        
        user.give(toy: .frisbee)
        #expect(user.toyInventory[.frisbee] == nil)
    }
}
