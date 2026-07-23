//
//  TaskItemTests.swift
//  PawductiveTests
//
//  Created by Kok Jun Zhe on 28/5/26.
//

import Foundation
import Testing
import SwiftData
import SwiftUI
@testable import Pawductive

@Suite struct TaskItemTests {
    //temp database
    @MainActor
    private func makeInMemoryContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DataContainer.appSchema, configurations: [config])
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
    
    //test 5: init default category
    @Test func testTaskItemDefaultCategory() {
        let task = TaskItem(title: "Default Category Task", expectedDurationInMinutes: 25)
        #expect(task.categoryName == "General")
    }

    //test 6: custom category assignment
    @Test func testTaskItemCustomCategory() {
        let task = TaskItem(title: "Study Task", expectedDurationInMinutes: 60, categoryName: "Study")
        #expect(task.categoryName == "Study")
    }

    //test 7: default category database seeding
    @Test @MainActor func testDefaultCategorySeeding() throws {
        let context = try makeInMemoryContext()
        
        for category in TaskCategory.defaults {
            context.insert(category)
        }
        try context.save()
        
        let descriptor = FetchDescriptor<TaskCategory>()
        let categories = try context.fetch(descriptor)
        
        #expect(categories.count == 5)
        
        let studyCategory = categories.first(where: { $0.name == "Study" })
        #expect(studyCategory != nil)
        #expect(studyCategory?.iconName == "📚")
    }
    
    //test 8: create custom user category
        @Test @MainActor func testCreateAndSaveCustomUserCategory() throws {
            let context = try makeInMemoryContext()
            
            let customCategory = TaskCategory(name: "Gaming", iconName: "🎮")
            context.insert(customCategory)
            try context.save()
            
            let descriptor = FetchDescriptor<TaskCategory>()
            let categories = try context.fetch(descriptor)
            
            let savedCategory = categories.first(where: { $0.name == "Gaming" })
            #expect(savedCategory != nil)
            #expect(savedCategory?.iconName == "🎮")
        }

        //test 9: delete category
        @Test @MainActor func testDeleteCategoryFromDatabase() throws {
            let context = try makeInMemoryContext()
            
            let category = TaskCategory(name: "TempCategory", iconName: "🗑️")
            context.insert(category)
            try context.save()
            
            context.delete(category)
            try context.save()
            
            let descriptor = FetchDescriptor<TaskCategory>()
            let categories = try context.fetch(descriptor)
            
            let foundCategory = categories.first(where: { $0.name == "TempCategory" })
            #expect(foundCategory == nil)
        }
    
        //test 10: task reordering sort order persistence
        @Test @MainActor func testTaskReorderingSortOrder() throws {
            let context = try makeInMemoryContext()
            
            let taskA = TaskItem(title: "Task A", expectedDurationInMinutes: 10, sortOrder: 0)
            let taskB = TaskItem(title: "Task B", expectedDurationInMinutes: 10, sortOrder: 1)
            let taskC = TaskItem(title: "Task C", expectedDurationInMinutes: 10, sortOrder: 2)
            
            context.insert(taskA)
            context.insert(taskB)
            context.insert(taskC)
            try context.save()
            
            var taskList = [taskA, taskB, taskC]
            taskList.move(fromOffsets: IndexSet(integer: 2), toOffset: 0)
            
            for (index, task) in taskList.enumerated() {
                task.sortOrder = index
            }
            try context.save()
            
            let descriptor = FetchDescriptor<TaskItem>(sortBy: [SortDescriptor(\TaskItem.sortOrder)])
            let fetchedTasks = try context.fetch(descriptor)
            
            #expect(fetchedTasks.count == 3)
            #expect(fetchedTasks[0].title == "Task C")
            #expect(fetchedTasks[1].title == "Task A")
            #expect(fetchedTasks[2].title == "Task B")
        }
}
