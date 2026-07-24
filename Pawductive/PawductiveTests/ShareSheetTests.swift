//
//  ShareSheetTests.swift
//  PawductiveTests
//
//  Created by Kok Jun Zhe on 24/7/26.
//

import Testing
import SwiftData
import SwiftUI
import Foundation
@testable import Pawductive

@Suite struct ShareSheetTests {
    @MainActor
    private func makeInMemoryContext() throws -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: DataContainer.appSchema, configurations: [config])
        return ModelContext(container)
    }
    
    //test 1: imagerenderer snapshot gen
    @Test @MainActor func testStreakShareCardImageRendering() throws {
        let context = try makeInMemoryContext()
        
        let background = Background(name: "Room", imageName: "room")
        context.insert(background)
        let pet = Pet(name: "DOG", mood: 100, energy: 100, experiencePoints: 500, background: background)
        context.insert(pet)
        let stats = UserStats(totalTasksCompleted: 10, totalMinutesFocused: 120, currentStreak: 5)
        context.insert(stats)
        try context.save()
        
        let shareCard = StreakShareCard(stats: stats, pet: pet)
            .modelContext(context)
        let renderer = ImageRenderer(content: shareCard)
        renderer.scale = 3.0
        let renderedUIImage = renderer.uiImage
        
        #expect(renderedUIImage != nil)
        #expect((renderedUIImage?.size.width ?? 0) > 0)
    }
    
    //test 2: zero day streak
    @Test func testStreakShareEligibility() {
        let zeroStreakStats = UserStats(totalTasksCompleted: 0, totalMinutesFocused: 0, currentStreak: 0)
        let activeStreakStats = UserStats(totalTasksCompleted: 1, totalMinutesFocused: 25, currentStreak: 1)
        
        func isShareEligible(for stats: UserStats) -> Bool {
            return stats.currentStreak > 0
        }
        
        #expect(isShareEligible(for: zeroStreakStats) == false)
        #expect(isShareEligible(for: activeStreakStats) == true)
    }
    
    //test 3: alternate bg rendering
    @Test @MainActor func testStreakShareCardAlternateBackgroundRendering() throws {
        let context = try makeInMemoryContext()
        
        let yardBackground = Background(name: "Yard", imageName: "yard")
        context.insert(yardBackground)
        let pet = Pet(name: "PUPPY", mood: 100, energy: 100, experiencePoints: 2500, background: yardBackground)
        context.insert(pet)
        let stats = UserStats(totalTasksCompleted: 50, totalMinutesFocused: 1500, currentStreak: 14)
        context.insert(stats)
        try context.save()
        
        let shareCard = StreakShareCard(stats: stats, pet: pet)
            .modelContext(context)
        let renderer = ImageRenderer(content: shareCard)
        renderer.scale = 3.0
        let renderedUIImage = renderer.uiImage
        
        #expect(renderedUIImage != nil)
        #expect((renderedUIImage?.size.width ?? 0) > 0)
    }
}
