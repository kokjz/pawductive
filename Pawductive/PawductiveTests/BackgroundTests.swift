//
//  BackgroundTests.swift
//  PawductiveTests
//
//  Created by Lee Zi Rong on 26/6/26.
//

import Foundation
import SwiftData
import Testing
@testable import Pawductive

@MainActor
struct BackgroundTests {
    
    @Test @MainActor func testBuyDecor() async throws {
        let dataContainer = DataContainer()
        
        let user = try #require(dataContainer.context.fetch(
            FetchDescriptor<UserProfile>()).first
        )
        
        let cabinet = try #require(dataContainer.context.fetch(
            FetchDescriptor<StoredDecor>()).first(where: {
                $0.decor.name == "Cabinet"
            })
        )
        
        // Cannot afford cabinet
        user.coins = 199
        user.buy(storedDecor: cabinet)
        #expect(user.coins == 199)
        #expect(cabinet.numStored == 0)
        
        // Can afford cabinet
        user.coins = 200
        user.buy(storedDecor: cabinet)
        #expect(user.coins == 0)
        #expect(cabinet.numStored == 1)
    }
    
    @Test @MainActor func testSellDecor() async throws {
        let dataContainer = DataContainer()

        let user = try #require(dataContainer.context.fetch(
            FetchDescriptor<UserProfile>()).first
        )
        
        let cabinet = try #require(dataContainer.context.fetch(
            FetchDescriptor<StoredDecor>()).first(where: {
                $0.decor.name == "Cabinet"
            })
        )
                
        // No cabinets in storage
        user.coins = 0
        user.sell(storedDecor: cabinet)
        #expect(user.coins == 0)
        #expect(cabinet.numStored == 0)
        
        // One cabinet in storage
        cabinet.numStored = 1
        user.sell(storedDecor: cabinet)
        #expect(user.coins == 200)
        #expect(cabinet.numStored == 0)
    }
    
    @Test @MainActor func testDisplayDecor() async throws {
        let dataContainer = DataContainer(loadDecorations: false)
        
        let cabinet = try #require(dataContainer.context.fetch(
            FetchDescriptor<StoredDecor>()).first(where: {
                $0.decor.name == "Cabinet"
            })
        )
        
        // No cabinets in storage
        cabinet.display(context: dataContainer.context)
        #expect(cabinet.numStored == 0)
        #expect(cabinet.shownDecors.count == 0)
        
        // One cabinet in storage
        cabinet.numStored = 1
        cabinet.display(context: dataContainer.context)
        #expect(cabinet.numStored == 0)
        #expect(cabinet.shownDecors.count == 1)
    }
    
    @Test @MainActor func testStoreDecor() async throws {
        let dataContainer = DataContainer(loadDecorations: false)
        
        let cabinet = try #require(dataContainer.context.fetch(
            FetchDescriptor<StoredDecor>()).first(where: {
                $0.decor.name == "Cabinet"
            })
        )
        
        // Add cabinet to display
        cabinet.numStored = 1
        cabinet.display(context: dataContainer.context)
        #expect(cabinet.numStored == 0)
        #expect(cabinet.shownDecors.count == 1)
        
        // Store cabinet on display
        let shownDecor = try #require(cabinet.shownDecors.first)
        shownDecor.store(context: dataContainer.context)
        #expect(cabinet.numStored == 1)
        #expect(cabinet.shownDecors.count == 0)
    }
    
    @Test @MainActor func testReorderDecor() async throws {
        let dataContainer = DataContainer(loadDecorations: true)
        
        let room = try #require(dataContainer.context.fetch(
            FetchDescriptor<Background>()).first(where: {
                $0.name == "Room"
            })
        )
        
        // Decor sent to front has highest order
        let shownDecor = try #require(room.shownDecors.first)
        room.sendToFront(shownDecor: shownDecor)
        for decor in room.shownDecors {
            if decor != shownDecor {
                #expect(decor.order < shownDecor.order)
            }
        }
        #expect(shownDecor.order == room.shownDecors.count - 1)
    }
}
