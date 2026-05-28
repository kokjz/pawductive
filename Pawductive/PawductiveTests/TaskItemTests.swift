//
//  TaskItemTests.swift
//  PawductiveTests
//
//  Created by Kok Jun Zhe on 28/5/26.
//

import Foundation
import Testing
import SwiftData
@testable import Pawductive

@Suite struct TaskItemTests {
    //temp database
    @MainActor
    private func makeInMemoryContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TaskItem.self, configurations: config)
        return ModelContext(container)
    }
    
    //test 1: save task to db
    @Test @MainActor func testCreateAndSaveTask() throws {
        let context = try makeInMemoryContext()
        
        let task = TaskItem(title: "foo", expectedDurationInMinutes: 25)
        context.insert(task)
        try context.save()
        
        let descriptor = FetchDescriptor<TaskItem>()
        let tasks = try context.fetch(descriptor)
        
        #expect(tasks.count == 1)
        #expect(tasks.first?.title == "foo")
        #expect(tasks.first?.expectedDurationInMinutes == 25)
        #expect(tasks.first?.isCompleted == false)
    }
    
    //test 2: delete task from db
    @Test @MainActor func testDeleteTask() throws {
        let context = try makeInMemoryContext()
        
        let task = TaskItem(title: "bar", expectedDurationInMinutes: 10)
        context.insert(task)
        try context.save()
        
        context.delete(task)
        try context.save()
        
        let descriptor = FetchDescriptor<TaskItem>()
        let tasks = try context.fetch(descriptor)
        
        #expect(tasks.isEmpty)
    }
    
    //test 3: toggle completion state
    @Test @MainActor func testToggleTaskCompletion() throws {
        let context = try makeInMemoryContext()
        
        let task = TaskItem(title: "bar", expectedDurationInMinutes: 15)
        context.insert(task)
        try context.save()
        
        task.isCompleted = true
        try context.save()
        
        let descriptor = FetchDescriptor<TaskItem>()
        let tasks = try context.fetch(descriptor)
        
        #expect(tasks.first?.isCompleted == true)
    }
    
    //test 4: task creation date tolerance
    @Test @MainActor func testTaskItemInitializationDateTolerance() throws {
            let context = try makeInMemoryContext()
            
            let task = TaskItem(title: "foo", expectedDurationInMinutes: 30)
            context.insert(task)
            try context.save()
            
            let timeDifference = abs(task.creationDate.timeIntervalSinceNow)
            #expect(timeDifference < 2.0) // 2s threshold
        }
}
