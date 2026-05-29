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
        let schema = Schema([TaskItem.self, UserProfile.self, Pet.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            if loadInventory {
                loadFoodInventory(user: user)
                loadToyInventory(user: user)
            }
            context.insert(user)
            context.insert(pet)
            try context.save()
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }
    
    func loadFoodInventory(user: UserProfile) {
        user.foodInventory[.corn] = 3
        user.foodInventory[.chickenWing] = 3
        user.foodInventory[.porkBelly] = 3
    }
    
    func loadToyInventory(user: UserProfile) {
        user.toyInventory[.frisbee] = 3
        user.toyInventory[.treeBranch] = 3
        user.toyInventory[.rubberDuck] = 3
    }
}
