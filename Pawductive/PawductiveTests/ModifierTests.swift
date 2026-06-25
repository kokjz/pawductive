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
        let pet = Pet(background: room)
        let moodDecayModifier = Modifier(label: "Pet1", name: "Conserve Mood", details: "Mood decreases at a slower rate", level: 0, maxLevel: 5)
        
        pet.moodDecayModifier = moodDecayModifier
        #expect(pet.moodHalfLife == 1)
        
        var lowMoodFutureDate = try #require(pet.lowMoodFutureDate())
        var futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 1.0 * 2)
        #expect(abs(lowMoodFutureDate.timeIntervalSince(futureDate)) < 1)
        
        
        moodDecayModifier.level = 1
        #expect(pet.moodHalfLife == 1.2)
        
        lowMoodFutureDate = try #require(pet.lowMoodFutureDate())
        futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 1.2 * 2)
        #expect(abs(lowMoodFutureDate.timeIntervalSince(futureDate)) < 1)
        
        
        moodDecayModifier.level = 5
        #expect(pet.moodHalfLife == 2)
        
        lowMoodFutureDate = try #require(pet.lowMoodFutureDate())
        futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 2.0 * 2)
        #expect(abs(lowMoodFutureDate.timeIntervalSince(futureDate)) < 1)
    }
    
    @Test @MainActor func testPetEnergyModifier() async throws {
        let pet = Pet(background: room)
        let energyDecayModifier = Modifier(label: "Pet1", name: "Conserve Mood", details: "Mood decreases at a slower rate", level: 0, maxLevel: 5)
        
        pet.energyDecayModifier = energyDecayModifier
        #expect(pet.dailyEnergyConsumption == 20)
        
        var lowEnergyFutureDate = try #require(pet.lowEnergyFutureDate())
        var futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 75 / 20.0)
        #expect(abs(lowEnergyFutureDate.timeIntervalSince(futureDate)) < 1)
        
        
        energyDecayModifier.level = 1
        #expect(pet.dailyEnergyConsumption == 18)
        
        lowEnergyFutureDate = try #require(pet.lowEnergyFutureDate())
        futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 75 / 18.0)
        #expect(abs(lowEnergyFutureDate.timeIntervalSince(futureDate)) < 1)
        
        
        energyDecayModifier.level = 5
        #expect(pet.dailyEnergyConsumption == 10)
        
        lowEnergyFutureDate = try #require(pet.lowEnergyFutureDate())
        futureDate = pet.createdOn.addingTimeInterval(60 * 60 * 24 * 75 / 10.0)
        #expect(abs(lowEnergyFutureDate.timeIntervalSince(futureDate)) < 1)
    }
    
    @Test @MainActor func testFoodCostModifier() async throws {
        let porkBelly = Food(name: "Pork Belly", value: 50, image: .porkBelly)
        let costModifier = Modifier(label: "Food1", name: "Lower Price", details: "Decrease cost of food", level: 0, maxLevel: 2)
        
        porkBelly.costModifier = costModifier
        #expect(porkBelly.cost == 50)
        
        costModifier.level = 1
        #expect(porkBelly.cost == 40)
        
        costModifier.level = 2
        #expect(porkBelly.cost == 30)
    }
    
    @Test @MainActor func testFoodMoodModifier() async throws {
        let porkBelly = Food(name: "Pork Belly", value: 50, image: .porkBelly)
        let moodModifier = Modifier(label: "Food2", name: "Improve Taste", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
        
        porkBelly.moodModifier = moodModifier
        #expect(porkBelly.moodEffects == 10)
        
        moodModifier.level = 1
        #expect(porkBelly.moodEffects == 12)
        
        moodModifier.level = 5
        #expect(porkBelly.moodEffects == 20)
    }
    
    @Test @MainActor func testFoodEnergyModifier() async throws {
        let porkBelly = Food(name: "Pork Belly", value: 50, image: .porkBelly)
        let energyModifier = Modifier(label: "Food3", name: "Increase Calories", details: "Energy increases by a larger amount", level: 0, maxLevel: 5)
        
        porkBelly.energyModifier = energyModifier
        #expect(porkBelly.energyEffects == 50)
        
        energyModifier.level = 1
        #expect(porkBelly.energyEffects == 60)
        
        energyModifier.level = 5
        #expect(porkBelly.energyEffects == 100)
    }
    
    @Test @MainActor func testToyCostModifier() async throws {
        let rubberDuck = Toy(name: "Rubber Duck", value: 80, image: .rubberDuck)
        let costModifier = Modifier(label: "Toy1", name: "Lower Price", details: "Decrease cost of toys", level: 0, maxLevel: 2)
        
        rubberDuck.costModifier = costModifier
        #expect(rubberDuck.cost == 80)
        
        costModifier.level = 1
        #expect(rubberDuck.cost == 64)
        
        costModifier.level = 2
        #expect(rubberDuck.cost == 48)
    }
    
    @Test @MainActor func testToyMoodModifier() async throws {
        let rubberDuck = Toy(name: "Rubber Duck", value: 80, image: .rubberDuck)
        let moodModifier = Modifier(label: "Toy2", name: "Improve Design", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
        
        rubberDuck.moodModifier = moodModifier
        #expect(rubberDuck.moodEffects == 80)
        
        moodModifier.level = 1
        #expect(rubberDuck.moodEffects == 96)
        
        moodModifier.level = 5
        #expect(rubberDuck.moodEffects == 160)
    }
    
    @Test @MainActor func testToyEnergyModifier() async throws {
        let rubberDuck = Toy(name: "Rubber Duck", value: 80, image: .rubberDuck)
        let energyModifier = Modifier(label: "Toy3", name: "Reduce Weight", details: "Energy decreases by a smaller amount", level: 0, maxLevel: 5)
        
        rubberDuck.energyModifier = energyModifier
        #expect(rubberDuck.energyEffects == -16)
        
        energyModifier.level = 1
        #expect(rubberDuck.energyEffects == -14.4)
        
        energyModifier.level = 5
        #expect(rubberDuck.energyEffects == -8)
    }
}
