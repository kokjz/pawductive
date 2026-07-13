//
//  PetTests.swift
//  PawductiveTests
//
//  Created by Lee Zi Rong on 29/5/26.
//

import Foundation
import Testing
@testable import Pawductive

struct PetTests {
    let room = Background(name: "Room", imageName: "room")
    
    let moodDecayModifier = Modifier(label: "pet.mood", name: "Conserve Mood", details: "Mood decreases at a slower rate", level: 0, maxLevel: 5)
    let energyDecayModifier = Modifier(label: "pet.energy", name: "Conserve Energy", details: "Energy decreases at a slower rate", level: 0, maxLevel: 5)
    let foodCostModifier = Modifier(label: "food.cost", name: "Lower Price", details: "Decrease cost of food", level: 0, maxLevel: 2)
    let foodMoodModifier = Modifier(label: "food.mood", name: "Improve Taste", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
    let foodEnergyModifier = Modifier(label: "food.energy", name: "Increase Calories", details: "Energy increases by a larger amount", level: 0, maxLevel: 5)
    let toyCostModifier = Modifier(label: "toy.cost", name: "Lower Price", details: "Decrease cost of toys", level: 0, maxLevel: 2)
    let toyMoodModifier = Modifier(label: "toy.mood", name: "Improve Design", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
    let toyEnergyModifier = Modifier(label: "toy.energy", name: "Reduce Weight", details: "Energy decreases by a smaller amount", level: 0, maxLevel: 5)

    @Test @MainActor func testCanReceiveFood() async throws {
        // Can receive food when energy is not full
        #expect(Pet(mood: 100, energy: 99, background: room).canReceive(food: .porkBelly))
        #expect(Pet(mood: 0, energy: 99, background: room).canReceive(food: .porkBelly))
        
        // Cannot receive food when energy is full
        #expect(!Pet(mood: 100, energy: 100, background: room).canReceive(food: .porkBelly))
        #expect(!Pet(mood: 0, energy: 100, background: room).canReceive(food: .porkBelly))
    }
    
    @Test @MainActor func testReceiveFood() async throws {
        let pet = Pet(mood: 10, energy: 50, background: room)
        
        pet.receive(food: .chickenDrumstick, moodModifier: foodMoodModifier, energyModifier: foodEnergyModifier)
        #expect(pet.mood == 16)
        #expect(pet.energy == 80)
        
        // Energy capped at 100
        pet.receive(food: .chickenDrumstick, moodModifier: foodMoodModifier, energyModifier: foodEnergyModifier)
        #expect(pet.mood == 22)
        #expect(pet.energy == 100)
        
        // Cannot receive food when energy is full
        pet.receive(food: .porkBelly, moodModifier: foodMoodModifier, energyModifier: foodEnergyModifier)
        #expect(pet.mood == 22)
        #expect(pet.energy == 100)
    }
    
    @Test @MainActor func testCanReceiveToy() async throws {
        // Can receive toy when mood is not full and pet has sufficient energy
        #expect(Pet(mood: 99, energy: 16, background: room).canReceive(toy: .rubberDuck, energyModifier: toyEnergyModifier))
        
        // Cannot receive toy when mood is full
        #expect(!Pet(mood: 100, energy: 16, background: room).canReceive(toy: .rubberDuck, energyModifier: toyEnergyModifier))
        
        // Cannot receive toy when pet does not have enough energy
        #expect(!Pet(mood: 99, energy: 15, background: room).canReceive(toy: .rubberDuck, energyModifier: toyEnergyModifier))
    }
    
    @Test @MainActor func testReceiveToy() async throws {
        let pet = Pet(mood: 0, energy: 30, background: room)
        
        pet.receive(toy: .rubberDuck, moodModifier: toyMoodModifier, energyModifier: toyEnergyModifier)
        #expect(pet.mood == 80)
        #expect(pet.energy == 14)
        
        // Insufficient energy
        pet.receive(toy: .rubberDuck, moodModifier: toyMoodModifier, energyModifier: toyEnergyModifier)
        #expect(pet.mood == 80)
        #expect(pet.energy == 14)
        
        // Mood capped at 100
        pet.receive(toy: .frisbee, moodModifier: toyMoodModifier, energyModifier: toyEnergyModifier)
        #expect(pet.mood == 100)
        #expect(pet.energy == 6)
        
        // Cannot receive toy when mood is full
        pet.receive(toy: .tennisBall, moodModifier: toyMoodModifier, energyModifier: toyEnergyModifier)
        #expect(pet.mood == 100)
        #expect(pet.energy == 6)
    }
    
    @Test @MainActor func testUpdatePet() async throws {
        let pet = Pet(mood: 100, energy: 100, background: room)
        #expect(pet.ageInDays == 0)
        
        let afterOneDay = Calendar.current.date(byAdding: .day, value: 1, to: pet.createdOn)
        pet.update(currDate: afterOneDay!, moodDecayModifier: moodDecayModifier, energyDecayModifier: energyDecayModifier)
        #expect(pet.mood.rounded() == 50)
        #expect(pet.energy.rounded() == 80)
        #expect(pet.ageInDays == 1)
        
        let afterTwoDays = Calendar.current.date(byAdding: .day, value: 2, to: pet.createdOn)
        pet.update(currDate: afterTwoDays!, moodDecayModifier: moodDecayModifier, energyDecayModifier: energyDecayModifier)
        #expect(pet.mood.rounded() == 25)
        #expect(pet.energy.rounded() == 60)
        #expect(pet.ageInDays == 2)
        
        // Mood follows exponential decay
        let afterFiveDays = Calendar.current.date(byAdding: .day, value: 5, to: pet.createdOn)
        pet.update(currDate: afterFiveDays!, moodDecayModifier: moodDecayModifier, energyDecayModifier: energyDecayModifier)
        #expect(floor(pet.mood) == 3)
        #expect(pet.energy.rounded() == 0)
        #expect(pet.ageInDays == 5)
        
        // Energy does not fall below 0
        let afterSixDays = Calendar.current.date(byAdding: .day, value: 6, to: pet.createdOn)
        pet.update(currDate: afterSixDays!, moodDecayModifier: moodDecayModifier, energyDecayModifier: energyDecayModifier)
        #expect(floor(pet.mood) == 1)
        #expect(pet.energy == 0)
        #expect(pet.ageInDays == 6)
        
        pet.mood = 100
        pet.energy = 100
        
        pet.isHibernating = true
        let afterSevenDays = Calendar.current.date(byAdding: .day, value: 7, to: pet.createdOn)
        pet.update(currDate: afterSevenDays!, moodDecayModifier: moodDecayModifier, energyDecayModifier: energyDecayModifier)
        #expect(pet.mood == 100)
        #expect(pet.energy == 100)
        #expect(pet.ageInDays == 7)
        
        pet.isHibernating = false
        let afterEightDays = Calendar.current.date(byAdding: .day, value: 8, to: pet.createdOn)
        pet.update(currDate: afterEightDays!, moodDecayModifier: moodDecayModifier, energyDecayModifier: energyDecayModifier)
        #expect(pet.mood.rounded() == 50)
        #expect(pet.energy.rounded() == 80)
        #expect(pet.ageInDays == 8)
    }
    
    @Test @MainActor func testExperiencePoints() async throws {
        let pet = Pet(mood: 100, energy: 100, background: room)
        #expect(pet.totalExperiencePoints == 0)
        #expect(pet.modifierPoints == 1)
        #expect(pet.level == 0)
        #expect(pet.maxMood == 100)
        #expect(pet.energy == 100)
        
        pet.totalExperiencePoints = 248
        #expect(pet.totalExperiencePoints == 248)
        #expect(pet.modifierPoints == 4)
        #expect(pet.level == 1)
        #expect(pet.maxMood == 110)
        #expect(pet.maxEnergy == 110)
        
        pet.totalExperiencePoints = 24794
        #expect(pet.totalExperiencePoints == 24794)
        #expect(pet.modifierPoints == 31)
        #expect(pet.level == 10)
        #expect(pet.maxMood == 200)
        #expect(pet.maxEnergy == 200)
        
        pet.totalExperiencePoints = 30000
        #expect(pet.totalExperiencePoints == 30000)
        #expect(pet.modifierPoints == 34)
        #expect(pet.level == 11)
        #expect(pet.maxMood == 200)
        #expect(pet.maxEnergy == 200)
        
        pet.totalExperiencePoints = 35703
        #expect(pet.totalExperiencePoints == 35703)
        #expect(pet.modifierPoints == 34)
        #expect(pet.level == 11)
        #expect(pet.maxMood == 200)
        #expect(pet.maxEnergy == 200)
    }
    
    @Test @MainActor func testImageState() async throws {
        let pet = Pet(mood: 100, energy: 100, background: room)
        #expect(pet.image == .happy)
        
        pet.mood = 75
        #expect(pet.image == .normal)
        
        pet.mood = 25
        #expect(pet.image == .angry)
        
        pet.energy = 25
        #expect(pet.image == .sleeping)
        
        pet.state = .eating
        #expect(pet.image == .eating)
        
        pet.state = .playing
        #expect(pet.image == .playing)
    }
    
    @Test @MainActor func testFoodStatistics() async throws {
        let pet = Pet(mood: 100, energy: 0, background: Background(name: "Room", imageName: "room"))
        #expect(pet.totalFoodReceived == 0)
        
        pet.receive(food: Food.chickenDrumstick, moodModifier: nil, energyModifier: nil)
        #expect(pet.totalFoodReceived == 1)
    }
    
    @Test @MainActor func testToyStatistics() async throws {
        let pet = Pet(mood: 0, energy: 100, background: Background(name: "Room", imageName: "room"))
        #expect(pet.totalToysReceived == 0)

        pet.receive(toy: Toy.frisbee, moodModifier: nil, energyModifier: nil)
        #expect(pet.totalToysReceived == 1)
    }
    
    @Test @MainActor func testMoodStreak() async throws {
        var pet = Pet(mood: 25, energy: 100, background: Background(name: "Room", imageName: "room"))
        #expect(pet.highMoodSince == nil)
        
        pet = Pet(mood: 26, energy: 100, background: Background(name: "Room", imageName: "room"))
        let highMoodSince: Date = try #require(pet.highMoodSince)
        #expect(pet.highMoodStreak(now: pet.lastUpdatedOn) == 0)
        #expect(pet.maxHighMoodStreak == 0)
        
        // Mood stays above threshold
        pet.mood = 100
        pet.update(currDate: highMoodSince.addingTimeInterval(24 * 3600 * 1), moodDecayModifier: nil, energyDecayModifier: nil)
        #expect(pet.mood > 25)
        #expect(pet.highMoodSince == highMoodSince)
        #expect(pet.highMoodStreak(now: pet.lastUpdatedOn) == 1)
        #expect(pet.maxHighMoodStreak == 1)
        
        // Mood drops below threshold
        pet.mood = 25
        pet.update(currDate: highMoodSince.addingTimeInterval(24 * 3600 * 2), moodDecayModifier: nil, energyDecayModifier: nil)
        #expect(pet.mood <= 25)
        #expect(pet.highMoodSince == nil)
        #expect(pet.highMoodStreak(now: pet.lastUpdatedOn) == 0)
        #expect(pet.maxHighMoodStreak == 1)
    }
    
    @Test @MainActor func testEnergyStreak() async throws {
        var pet = Pet(mood: 100, energy: 25, background: Background(name: "Room", imageName: "room"))
        #expect(pet.highEnergySince == nil)
        
        pet = Pet(mood: 100, energy: 26, background: Background(name: "Room", imageName: "room"))
        let highEnergySince: Date = try #require(pet.highEnergySince)
        #expect(pet.highEnergyStreak(now: pet.lastUpdatedOn) == 0)
        #expect(pet.maxHighEnergyStreak == 0)
        
        // Energy stays above threshold
        pet.energy = 100
        pet.update(currDate: highEnergySince.addingTimeInterval(24 * 3600 * 1), moodDecayModifier: nil, energyDecayModifier: nil)
        #expect(pet.energy > 25)
        #expect(pet.highEnergySince == highEnergySince)
        #expect(pet.highEnergyStreak(now: pet.lastUpdatedOn) == 1)
        #expect(pet.maxHighEnergyStreak == 1)
        
        // Energy drops below threshold
        pet.energy = 25
        pet.update(currDate: highEnergySince.addingTimeInterval(24 * 3600 * 2), moodDecayModifier: nil, energyDecayModifier: nil)
        #expect(pet.energy <= 25)
        #expect(pet.highEnergySince == nil)
        #expect(pet.highEnergyStreak(now: pet.lastUpdatedOn) == 0)
        #expect(pet.maxHighEnergyStreak == 1)
    }
}
