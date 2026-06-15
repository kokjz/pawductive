//
//  UserContainer.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

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
            if loadInventory {
                loadFoodInventory(user: user)
                loadToyInventory(user: user)
            }
            context.insert(user)
            context.insert(pet)
            insertModifiers(for: pet)
            insertFoodModifiers()
            insertToyModifiers()
            try context.save()
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
}
