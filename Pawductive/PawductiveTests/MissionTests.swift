//
//  MissionTests.swift
//  PawductiveTests
//
//  Created by Lee Zi Rong on 25/6/26.
//

import Foundation
import Testing
@testable import Pawductive

struct MissionTests {
    
    @Test @MainActor func testUpdateMission() async throws {
        // Specific Mission
        var details = MissionDetails(action: "DO", targetType: "TASK", targetName: "Number")
        var mission = DailyMission(title: "Finish 3 tasks", requirement: 3, reward: 5, isSpecific: true, details: details)
        #expect(mission.progress == 0)
        
        mission.update(details: details, progress: 1)
        #expect(mission.progress == 1)
        
        var otherDetails = MissionDetails(action: "DO", targetType: "TASK", targetName: "Duration")
        mission.update(details: otherDetails, progress: 1)
        #expect(mission.progress == 1)
        
        // General Mission
        details = MissionDetails(action: "BUY", targetType: "FOOD", targetName: "")
        mission = DailyMission(title: "Buy 3 food", requirement: 3, reward: 5, isSpecific: false, details: details)
        #expect(mission.progress == 0)
        
        mission.update(details: details, progress: 1)
        #expect(mission.progress == 1)
        
        otherDetails = MissionDetails(action: "BUY", targetType: "FOOD", targetName: "Egg")
        mission.update(details: otherDetails, progress: 1)
        #expect(mission.progress == 2)
    }
    
    @Test @MainActor func testResetMission() async throws {
        let details = MissionDetails(action: "DO", targetType: "TASK", targetName: "Number")
        let mission = DailyMission(title: "Finish 3 tasks", requirement: 3, reward: 5, isSpecific: true, details: details)
        #expect(mission.progress == 0)
        #expect(mission.claimed == false)
        
        mission.progress = 1
        mission.claimed = true
        
        mission.reset()
        #expect(mission.progress == 0)
        #expect(mission.claimed == false)
    }
    
    @Test @MainActor func testInitialMissions() async throws {
        let missionManager = MissionManager(numActiveMissions: 3)
        missionManager.initializeActiveMissions(missions: DataContainer.dailyMissions)
        
        #expect(missionManager.activeMissions.count == 3)
        for mission in missionManager.activeMissions {
            #expect(mission.progress == 0)
            #expect(mission.claimed == false)
        }
    }
    
    @Test @MainActor func testRefreshMissions() async throws {
        let missionManager = MissionManager(numActiveMissions: 3)
        missionManager.initializeActiveMissions(missions: DataContainer.dailyMissions)
        
        for mission in missionManager.activeMissions {
            mission.progress = mission.requirement
            mission.claimed = true
        }
        
        missionManager.lastActiveOn = Date().addingTimeInterval(-1 * 24 * 60 * 60)
        missionManager.refreshActiveMissions(missions: DataContainer.dailyMissions)
        
        #expect(missionManager.activeMissions.count == 3)
        for mission in missionManager.activeMissions {
            #expect(mission.progress == 0)
            #expect(mission.claimed == false)
        }
    }
    
}
