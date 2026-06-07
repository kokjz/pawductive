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
        let schema = Schema([TaskItem.self, UserProfile.self, Pet.self, Modifier.self])
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
        let moodModifier = Modifier(name: "Resilient Pet", details: "Mood decreases at a slower rate", level: 0, maxLevel: 5)
        let energyModifier = Modifier(name: "Energized Pet", details: "Energy decreases at a slower rate", level: 0, maxLevel: 5)
        
        pet.moodDecayModifier = moodModifier
        pet.energyDecayModifier = energyModifier
        
        context.insert(moodModifier)
        context.insert(energyModifier)
    }
    
    func insertFoodModifiers() {
        let costModifier = Modifier(name: "Cheaper Food", details: "Cost of food decreases", level: 0, maxLevel: 2)
        let moodModifier = Modifier(name: "Delicious Food", details: "Food increases mood by a larger amount", level: 0, maxLevel: 5)
        let energyModifier = Modifier(name: "Nutritious Food", details: "Food increases energy by a larger amount", level: 0, maxLevel: 5)
        
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
        let costModifier = Modifier(name: "Cheaper Toys", details: "Cost of toys decreases", level: 0, maxLevel: 2)
        let moodModifier = Modifier(name: "Tougher Toys", details: "Toys increase mood by a larger amount", level: 0, maxLevel: 5)
        let energyModifier = Modifier(name: "Lighter Toys", details: "Toys decrease energy by a smaller amount", level: 0, maxLevel: 5)
        
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
