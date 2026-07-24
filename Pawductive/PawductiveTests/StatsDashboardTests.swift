//
//  StatsDashboardTests.swift
//  PawductiveTests
//
//  Created by Kok Jun Zhe on 24/7/26.
//

import Testing
import SwiftData
import Foundation
@testable import Pawductive

@Suite struct StatsDashboardTests {
    @MainActor
    private func makeInMemoryContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DataContainer.appSchema, configurations: [config])
        return ModelContext(container)
    }
    
    //test 1: category focus time aggregation correct math
    @Test @MainActor func testCategoryFocusTimeAggregation() throws {
        let context = try makeInMemoryContext()
        
        let task1 = TaskItem(title: "cs2030s", expectedDurationInMinutes: 30, categoryName: "Study")
        task1.isCompleted = true
        let task2 = TaskItem(title: "cs2040s", expectedDurationInMinutes: 45, categoryName: "Study")
        task2.isCompleted = true
        let task3 = TaskItem(title: "calisthenics", expectedDurationInMinutes: 15, categoryName: "Fitness")
        task3.isCompleted = true
        let task4 = TaskItem(title: "reading", expectedDurationInMinutes: 60, categoryName: "Study")
        task4.isCompleted = false
        
        context.insert(task1)
        context.insert(task2)
        context.insert(task3)
        context.insert(task4)
        try context.save()
        
        let descriptor = FetchDescriptor<TaskItem>(predicate: #Predicate<TaskItem> { $0.isCompleted })
        let completedTasks = try context.fetch(descriptor)
        
        var durationMap: [String: Int] = [:]
        for task in completedTasks {
            durationMap[task.categoryName, default: 0] += task.expectedDurationInMinutes
        }
        
        #expect(completedTasks.count == 3)
        #expect(durationMap["Study"] == 75)
        #expect(durationMap["Fitness"] == 15)
    }
    
    //test 2: chart sorting order
    @Test @MainActor func testCategoryStatSortingByHighestFocusTime() throws {
        let context = try makeInMemoryContext()
        
        let studyCategory = TaskCategory(name: "Study", iconName: "📚")
        let fitnessCategory = TaskCategory(name: "Fitness", iconName: "🏃")
        context.insert(studyCategory)
        context.insert(fitnessCategory)
        
        let task1 = TaskItem(title: "Workout", expectedDurationInMinutes: 20, categoryName: "Fitness")
        task1.isCompleted = true
        let task2 = TaskItem(title: "Coding", expectedDurationInMinutes: 100, categoryName: "Study")
        task2.isCompleted = true
        
        context.insert(task1)
        context.insert(task2)
        try context.save()
        
        let descriptor = FetchDescriptor<TaskItem>(predicate: #Predicate<TaskItem> { $0.isCompleted })
        let completedTasks = try context.fetch(descriptor)
        let categories = try context.fetch(FetchDescriptor<TaskCategory>())
        
        var durationMap: [String: Int] = [:]
        for task in completedTasks {
            durationMap[task.categoryName, default: 0] += task.expectedDurationInMinutes
        }
        
        let categoryStats = durationMap.map { (name, mins) in
            let icon = categories.first(where: { $0.name == name })?.iconName ?? "📁"
            return CategoryStat(categoryName: name, minutesFocused: mins, iconName: icon)
        }.sorted(by: { $0.minutesFocused > $1.minutesFocused })
        
        #expect(categoryStats.count == 2)
        #expect(categoryStats[0].categoryName == "Study")
        #expect(categoryStats[0].minutesFocused == 100)
        #expect(categoryStats[1].categoryName == "Fitness")
        #expect(categoryStats[1].minutesFocused == 20)
    }
}
