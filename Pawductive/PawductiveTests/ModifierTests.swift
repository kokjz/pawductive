//
//  ModifierTests.swift
//  PawductiveTests
//
//  Created by Lee Zi Rong on 25/6/26.
//

import Foundation
import Testing
@testable import Pawductive

struct ModifierTests {
    let room = Background(name: "Room", imageName: "room")

    @Test @MainActor func testPetMoodModifier() async throws {
        let moodDecayModifier = Modifier(label: "pet.mood", name: "Conserve Mood", details: "Mood decreases at a slower rate", level: 0, maxLevel: 5)
        let pet = Pet(background: room)
        #expect(pet.moodHalfLife(moodDecayModifier: moodDecayModifier) == 1)
        
        
        var lowMoodFutureDate = try #require(pet.lowMoodFutureDate(moodDecayModifier: moodDecayModifier))
        var futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 1.0 * 2)
        #expect(abs(lowMoodFutureDate.timeIntervalSince(futureDate)) < 1)
        
        
        moodDecayModifier.level = 1
        #expect(pet.moodHalfLife(moodDecayModifier: moodDecayModifier) == 1.2)
        
        lowMoodFutureDate = try #require(pet.lowMoodFutureDate(moodDecayModifier: moodDecayModifier))
        futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 1.2 * 2)
        #expect(abs(lowMoodFutureDate.timeIntervalSince(futureDate)) < 1)
        
        
        moodDecayModifier.level = 5
        #expect(pet.moodHalfLife(moodDecayModifier: moodDecayModifier) == 2)
        
        lowMoodFutureDate = try #require(pet.lowMoodFutureDate(moodDecayModifier: moodDecayModifier))
        futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 2.0 * 2)
        #expect(abs(lowMoodFutureDate.timeIntervalSince(futureDate)) < 1)
    }
    
    @Test @MainActor func testPetEnergyModifier() async throws {
        let energyDecayModifier = Modifier(label: "pet.energy", name: "Conserve Energy", details: "Energy decreases at a slower rate", level: 0, maxLevel: 5)
        let pet = Pet(background: room)
        #expect(pet.dailyEnergyConsumption(energyDecayModifier: energyDecayModifier) == 20)
        
        var lowEnergyFutureDate = try #require(pet.lowEnergyFutureDate(energyDecayModifier: energyDecayModifier))
        var futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 75 / 20.0)
        #expect(abs(lowEnergyFutureDate.timeIntervalSince(futureDate)) < 1)
        
        
        energyDecayModifier.level = 1
        #expect(pet.dailyEnergyConsumption(energyDecayModifier: energyDecayModifier) == 18)
        
        lowEnergyFutureDate = try #require(pet.lowEnergyFutureDate(energyDecayModifier: energyDecayModifier))
        futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 75 / 18.0)
        #expect(abs(lowEnergyFutureDate.timeIntervalSince(futureDate)) < 1)
        
        
        energyDecayModifier.level = 5
        #expect(pet.dailyEnergyConsumption(energyDecayModifier: energyDecayModifier) == 10)
        
        lowEnergyFutureDate = try #require(pet.lowEnergyFutureDate(energyDecayModifier: energyDecayModifier))
        futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 75 / 10.0)
        #expect(abs(lowEnergyFutureDate.timeIntervalSince(futureDate)) < 1)
    }
    
    @Test @MainActor func testFoodCostModifier() async throws {
        let foodCostModifier = Modifier(label: "food.cost", name: "Lower Price", details: "Decrease cost of food", level: 0, maxLevel: 2)
        let porkBelly = Food(name: "Pork Belly", value: 50, image: .porkBelly)
        #expect(porkBelly.cost(costModifier: foodCostModifier) == 50)
        
        foodCostModifier.level = 1
        #expect(porkBelly.cost(costModifier: foodCostModifier) == 40)
        
        foodCostModifier.level = 2
        #expect(porkBelly.cost(costModifier: foodCostModifier) == 30)
    }
    
    @Test @MainActor func testFoodMoodModifier() async throws {
        let foodMoodModifier = Modifier(label: "food.mood", name: "Improve Taste", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
        let porkBelly = Food(name: "Pork Belly", value: 50, image: .porkBelly)
        #expect(porkBelly.moodEffects(moodModifier: foodMoodModifier) == 10)
        
        foodMoodModifier.level = 1
        #expect(porkBelly.moodEffects(moodModifier: foodMoodModifier) == 12)
        
        foodMoodModifier.level = 5
        #expect(porkBelly.moodEffects(moodModifier: foodMoodModifier) == 20)
    }
    
    @Test @MainActor func testFoodEnergyModifier() async throws {
        let foodEnergyModifier = Modifier(label: "food.energy", name: "Increase Calories", details: "Energy increases by a larger amount", level: 0, maxLevel: 5)
        let porkBelly = Food(name: "Pork Belly", value: 50, image: .porkBelly)
        #expect(porkBelly.energyEffects(energyModifier: foodEnergyModifier) == 50)
        
        foodEnergyModifier.level = 1
        #expect(porkBelly.energyEffects(energyModifier: foodEnergyModifier) == 60)
        
        foodEnergyModifier.level = 5
        #expect(porkBelly.energyEffects(energyModifier: foodEnergyModifier) == 100)
    }
    
    @Test @MainActor func testToyCostModifier() async throws {
        let toyCostModifier = Modifier(label: "toy.cost", name: "Lower Price", details: "Decrease cost of toys", level: 0, maxLevel: 2)
        let rubberDuck = Toy(name: "Rubber Duck", value: 80, image: .rubberDuck)

        #expect(rubberDuck.cost(costModifier: toyCostModifier) == 80)
        
        toyCostModifier.level = 1
        #expect(rubberDuck.cost(costModifier: toyCostModifier) == 64)
        
        toyCostModifier.level = 2
        #expect(rubberDuck.cost(costModifier: toyCostModifier) == 48)
    }
    
    @Test @MainActor func testToyMoodModifier() async throws {
        let toyMoodModifier = Modifier(label: "toy.mood", name: "Improve Design", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
        let rubberDuck = Toy(name: "Rubber Duck", value: 80, image: .rubberDuck)
        #expect(rubberDuck.moodEffects(moodModifier: toyMoodModifier) == 80)
        
        toyMoodModifier.level = 1
        #expect(rubberDuck.moodEffects(moodModifier: toyMoodModifier) == 96)
        
        toyMoodModifier.level = 5
        #expect(rubberDuck.moodEffects(moodModifier: toyMoodModifier) == 160)
    }
    
    @Test @MainActor func testToyEnergyModifier() async throws {
        let toyEnergyModifier = Modifier(label: "toy.energy", name: "Reduce Weight", details: "Energy decreases by a smaller amount", level: 0, maxLevel: 5)
        let rubberDuck = Toy(name: "Rubber Duck", value: 80, image: .rubberDuck)
        #expect(rubberDuck.energyEffects(energyModifier: toyEnergyModifier) == -16)
        
        toyEnergyModifier.level = 1
        #expect(rubberDuck.energyEffects(energyModifier: toyEnergyModifier) == -14.4)
        
        toyEnergyModifier.level = 5
        #expect(rubberDuck.energyEffects(energyModifier: toyEnergyModifier) == -8)
    }
}
