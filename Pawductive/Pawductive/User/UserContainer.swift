//
//  UserContainer.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

import SwiftData

class UserContainer {
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    init(user: User = User(), inMemory: Bool = true) {
        let schema = Schema([User.self])
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
