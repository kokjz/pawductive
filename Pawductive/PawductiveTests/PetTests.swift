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

    @Test @MainActor func testCanReceiveFood() async throws {
        // Can receive food when energy is not full
        #expect(Pet(mood: 100, energy: 99).canReceive(food: .porkBelly))
        #expect(Pet(mood: 0, energy: 99).canReceive(food: .porkBelly))
        
        // Cannot receive food when energy is full
        #expect(!Pet(mood: 100, energy: 100).canReceive(food: .porkBelly))
        #expect(!Pet(mood: 0, energy: 100).canReceive(food: .porkBelly))
    }
    
    @Test @MainActor func testReceiveFood() async throws {
        let pet = Pet(mood: 10, energy: 50)
        
        pet.receive(food: .chickenDrumstick)
        #expect(pet.mood == 16)
        #expect(pet.energy == 80)
        
        // Energy capped at 100
        pet.receive(food: .chickenDrumstick)
        #expect(pet.mood == 22)
        #expect(pet.energy == 100)
        
        // Cannot receive food when energy is full
        pet.receive(food: .porkBelly)
        #expect(pet.mood == 22)
        #expect(pet.energy == 100)
    }
    
    @Test @MainActor func testCanReceiveToy() async throws {
        // Can receive toy when mood is not full and pet has sufficient energy
        #expect(Pet(mood: 99, energy: 16).canReceive(toy: .rubberDuck))
        
        // Cannot receive toy when mood is full
        #expect(!Pet(mood: 100, energy: 16).canReceive(toy: .rubberDuck))
        
        // Cannot receive toy when pet does not have enough energy
        #expect(!Pet(mood: 99, energy: 15).canReceive(toy: .rubberDuck))
    }
    
    @Test @MainActor func testReceiveToy() async throws {
        let pet = Pet(mood: 0, energy: 30)
        
        pet.receive(toy: .rubberDuck)
        #expect(pet.mood == 80)
        #expect(pet.energy == 14)
        
        // Insufficient energy
        pet.receive(toy: .rubberDuck)
        #expect(pet.mood == 80)
        #expect(pet.energy == 14)
        
        // Mood capped at 100
        pet.receive(toy: .frisbee)
        #expect(pet.mood == 100)
        #expect(pet.energy == 6)
        
        // Cannot receive toy when mood is full
        pet.receive(toy: .tennisBall)
        #expect(pet.mood == 100)
        #expect(pet.energy == 6)
    }
    
    @Test @MainActor func testUpdatePet() async throws {
        let pet = Pet(mood: 100, energy: 100)
        #expect(pet.ageInDays == 0)
        
        let afterOneDay = Calendar.current.date(byAdding: .day, value: 1, to: pet.createdOn)
        pet.update(currDate: afterOneDay!)
        #expect(pet.mood == 50)
        #expect(pet.energy == 80)
        #expect(pet.ageInDays == 1)
        
        let afterTwoDays = Calendar.current.date(byAdding: .day, value: 2, to: pet.createdOn)
        pet.update(currDate: afterTwoDays!)
        #expect(pet.mood == 25)
        #expect(pet.energy == 60)
        #expect(pet.ageInDays == 2)
        
        // Mood follows exponential decay
        let afterFiveDays = Calendar.current.date(byAdding: .day, value: 5, to: pet.createdOn)
        pet.update(currDate: afterFiveDays!)
        #expect(floor(pet.mood) == 3)
        #expect(pet.energy == 0)
        #expect(pet.ageInDays == 5)
        
        // Energy does not fall below 0
        let afterSixDays = Calendar.current.date(byAdding: .day, value: 6, to: pet.createdOn)
        pet.update(currDate: afterSixDays!)
        #expect(floor(pet.mood) == 1)
        #expect(pet.energy == 0)
        #expect(pet.ageInDays == 6)
    }
}
