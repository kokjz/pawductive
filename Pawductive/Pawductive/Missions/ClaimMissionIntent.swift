//
//  ClaimMissionIntent.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 22/7/26.
//

import AppIntents
import WidgetKit
import SwiftData

struct ClaimMissionIntent: AppIntent {
    static var title: LocalizedStringResource = "Claim Mission Reward"
    
    @Parameter var missionTitle: String
    
    var modelContainer: ModelContainer?
    
    init() {}
    
    init(missionTitle: String, modelContainer: ModelContainer) {
        self.missionTitle = missionTitle
        self.modelContainer = modelContainer
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        let container: ModelContainer? = modelContainer ?? DataContainer.createModelContainer(inMemory: false)
        
        guard let container else {
            print("Missing model container")
            return .result()
        }
        
        guard let userProfile = try? container.mainContext.fetch(FetchDescriptor<UserProfile>()).first else {
            print("Unable to fetch UserProfile")
            return .result()
        }
        
        guard let userStats = try? container.mainContext.fetch(FetchDescriptor<UserStats>()).first else {
            print("Unable to fetch UserStats")
            return .result()
        }
        
        let descriptor = FetchDescriptor<DailyMission>(predicate: #Predicate { $0.title == missionTitle })
        guard let dailyMission = try? container.mainContext.fetch(descriptor).first else {
            print("Unable to fetch DailyMission")
            return .result()
        }
        
        userProfile.coins += dailyMission.reward
        userStats.totalCoinsEarned += dailyMission.reward
        dailyMission.claimed = true
        try? container.mainContext.save()
        WidgetCenter.shared.reloadTimelines(ofKind: "RewardMissionWidget")
        print("Mission reward claimed successfully")
        return .result()
    }
}
