//
//  DataContainer.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

import Foundation
import SwiftData

class DataContainer {
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    // Initializes a model container with a user and a pet
    init(user: UserProfile = UserProfile(), pet: Pet = Pet(), loadInventory: Bool = true, inMemory: Bool = true) {
        let schema = Schema([TaskItem.self, UserProfile.self, Pet.self, Modifier.self, UserStats.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let descriptor = FetchDescriptor<UserProfile>()
            let existingUsers = try? context.fetch(descriptor)
            if existingUsers?.isEmpty ?? true {
                if loadInventory {
                    loadFoodInventory(user: user)
                    loadToyInventory(user: user)
                }
                context.insert(user)
                context.insert(pet)
                insertModifiers(for: pet)
                insertFoodModifiers()
                insertToyModifiers()
                let stats = UserStats()
                context.insert(stats)
                try context.save()
                print("Database empty, seed default user and pet success")
            } else {
                checkAndResetBrokenStreak()
                print("User profile found, skipping seeding")
            }
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }
    
    func loadFoodInventory(user: UserProfile) {
        user.foodInventory[Food.corn.name] = 3
        user.foodInventory[Food.chickenWing.name] = 3
        user.foodInventory[Food.porkBelly.name] = 3
    }
    
    func loadToyInventory(user: UserProfile) {
        user.toyInventory[Toy.frisbee.name] = 3
        user.toyInventory[Toy.treeBranch.name] = 3
        user.toyInventory[Toy.rubberDuck.name] = 3
    }

    func insertModifiers(for pet: Pet) {
        let moodModifier =
            Modifier(label: "Pet1", name: "Conserve Mood", details: "Mood decreases at a slower rate", level: 0, maxLevel: 5)
        let energyModifier =
            Modifier(label: "Pet2", name: "Conserve Energy", details: "Energy decreases at a slower rate", level: 0, maxLevel: 5)
        
        pet.moodDecayModifier = moodModifier
        pet.energyDecayModifier = energyModifier
        
        context.insert(moodModifier)
        context.insert(energyModifier)
    }
    
    func insertFoodModifiers() {
        let costModifier =
            Modifier(label: "Food1", name: "Lower Price", details: "Decrease cost of food", level: 0, maxLevel: 2)
        let moodModifier =
            Modifier(label: "Food2", name: "Improve Taste", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
        let energyModifier =
            Modifier(label: "Food3", name: "Increase Calories", details: "Energy increases by a larger amount", level: 0, maxLevel: 5)
        
        for food in Food.allFoods {
            food.costModifier = costModifier
            food.moodModifier = moodModifier
            food.energyModifier = energyModifier
        }
        
        context.insert(costModifier)
        context.insert(moodModifier)
        context.insert(energyModifier)
    }
    
    func insertToyModifiers() {
        let costModifier =
            Modifier(label: "Toy1", name: "Lower Price", details: "Decrease cost of toys", level: 0, maxLevel: 2)
        let moodModifier =
            Modifier(label: "Toy2", name: "Improve Design", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
        let energyModifier =
            Modifier(label: "Toy3", name: "Reduce Weight", details: "Energy decreases by a smaller amount", level: 0, maxLevel: 5)
        
        for toy in Toy.allToys {
            toy.costModifier = costModifier
            toy.moodModifier = moodModifier
            toy.energyModifier = energyModifier
        }
        
        context.insert(costModifier)
        context.insert(moodModifier)
        context.insert(energyModifier)
    }
    
    //check user streak validity on launch
    private func checkAndResetBrokenStreak() {
        let statsDescriptor = FetchDescriptor<UserStats>()
        if let statsList = try? context.fetch(statsDescriptor), let stats = statsList.first {
            if let lastActive = stats.lastActiveDate {
                let calendar = Calendar.current
                let lastActiveMidnight = calendar.startOfDay(for: lastActive)
                let todayMidnight = calendar.startOfDay(for: Date())
                let components = calendar.dateComponents([.day], from: lastActiveMidnight, to: todayMidnight)
                if let daysBetween = components.day, daysBetween > 1 { //streak broken
                    stats.currentStreak = 0
                    try? context.save()
                    print("Broken streak detected on launch, reset to 0")
                } else { //streak still active
                    print("Streak still active on launch, current streak: \(stats.currentStreak)")
                }
            }
        }
    }
}
