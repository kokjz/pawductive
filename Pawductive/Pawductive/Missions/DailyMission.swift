//
//  DailyMission.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 23/6/26.
//

import SwiftData

@Model
class DailyMission {
    var title: String
    
    var requirement: Int
    var progress: Int = 0
    
    var reward: Int
    var claimed: Bool = false
    
    var isSpecific: Bool
    var details: MissionDetails
    
    init(title: String, requirement: Int, reward: Int, isSpecific: Bool, details: MissionDetails) {
        self.title = title
        self.requirement = requirement
        self.reward = reward
        self.isSpecific = isSpecific
        self.details = details
    }
    
    func update(details: MissionDetails, progress: Int) {
        guard self.details.matches(details: details, isSpecific: self.isSpecific) else { return }
        self.progress += progress
    }
    
    func reset() {
        self.progress = 0
        self.claimed = false
    }
}
