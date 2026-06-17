//
//  DataContainer.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

import SwiftData
import Foundation

class DataContainer {
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    // Initializes a model container with a user and a pet
    init(user: UserProfile = UserProfile(), pet: Pet = Pet(), loadInventory: Bool = true, inMemory: Bool = true) {
        let schema = Schema([
            Background.self,
            Modifier.self,
            Pet.self,
            ShownDecor.self,
            StoredDecor.self,
            TaskItem.self,
            UserProfile.self,
            UserStats.self
        ])
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
                
                let stats = UserStats()
                context.insert(stats)
                
                insertFoodModifiers()
                insertToyModifiers()
                
                insertPetModifiers(pet)
                context.insert(pet)
            
                insertBackgrounds()
                insertStoredDecors()
                try context.save()
                print("Database empty, seed default user and pet success")
            } else {
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

    func insertPetModifiers(_ pet: Pet) {
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
    
    func insertBackgrounds() {
        let backgrounds = [
            Background(name: "Room", imageName: "room")
        ]
        
        for background in backgrounds {
            context.insert(background)
        }
    }
    
    func insertStoredDecors() {
        guard let backgrounds = try? context.fetch(FetchDescriptor<Background>()) else { return }
        guard let room = backgrounds.filter({ $0.name == "Room" }).first else { return }
        
        let storedDecors = [
            StoredDecor(decor: Decor(name: "Cabinet", imageName: "cabinet", relativeHeight: 0.5, cost: 200), background: room),
            StoredDecor(decor: Decor(name: "Clock", imageName: "clock", relativeHeight: 0.2, cost: 100), background: room),
            StoredDecor(decor: Decor(name: "Mirror", imageName: "mirror", relativeHeight: 0.4, cost: 150), background: room),
            StoredDecor(decor: Decor(name: "Plant", imageName: "plant", relativeHeight: 0.2, cost: 50), background: room),
            StoredDecor(decor: Decor(name: "Sofa", imageName: "sofa", relativeHeight: 0.4, cost: 300), background: room),
            StoredDecor(decor: Decor(name: "Vase", imageName: "vase", relativeHeight: 0.4, cost: 75), background: room),
            StoredDecor(decor: Decor(name: "Window", imageName: "window", relativeHeight: 0.6, cost: 250), background: room),
        ]
        
        for storedDecor in storedDecors {
            context.insert(storedDecor)
        }
    }
}
