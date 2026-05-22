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
    
    // Initializes a model container with a default user
    init(user: UserProfile = UserProfile(), inMemory: Bool = true) {
        let schema = Schema([TaskItem.self, UserProfile.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            context.insert(user)
            try context.save()
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }
}
