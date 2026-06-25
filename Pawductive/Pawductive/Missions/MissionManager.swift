//
//  MissionManager.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 23/6/26.
//

import Foundation
import SwiftData

@Model
class MissionManager {
    var numActiveMissions: Int
    var lastActiveOn: Date
    
    @Relationship
    var activeMissions = [DailyMission]()
    
    init(numActiveMissions: Int = 3) {
        self.numActiveMissions = numActiveMissions
        self.lastActiveOn = Date()
    }
    
    func initializeActiveMissions(missions: [DailyMission]) {
        guard activeMissions.isEmpty else { return }
        activeMissions = drawRandom(missions: missions)
        self.lastActiveOn = Date()
    }
    
    func updateActiveMissions(missions: [DailyMission], details: MissionDetails, progress: Int) {
        refreshActiveMissions(missions: missions)
        for mission in activeMissions {
            mission.update(details: details, progress: progress)
        }
        self.lastActiveOn = Date()
    }
    
    func refreshActiveMissions(missions: [DailyMission]) {
        guard !Calendar.current.isDate(Date(), inSameDayAs: lastActiveOn) else { return }
        for mission in activeMissions { mission.reset() }
        activeMissions = drawRandom(missions: missions)
        self.lastActiveOn = Date()
    }
    
    private func drawRandom(missions: [DailyMission]) -> [DailyMission] {
        return Array(missions.shuffled().prefix(numActiveMissions))
    }
}
