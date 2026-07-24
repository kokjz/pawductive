//
//  ClaimRewardIntent.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 22/7/26.
//

import AppIntents
import WidgetKit
import SwiftData

struct ClaimRewardIntent: AppIntent {
    static var title: LocalizedStringResource = "Claim Daily Reward"
    
    var modelContainer: ModelContainer?
    
    init() {}
    
    init(modelContainer: ModelContainer) {
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
        
        guard let dailyReward = try? container.mainContext.fetch(FetchDescriptor<DailyReward>()).first else {
            print("Unable to fetch DailyReward")
            return .result()
        }
        
        guard !dailyReward.claimed else {
            print("Daily reward already claimed")
            return .result()
        }
        
        dailyReward.claimReward(user: userProfile)
        userStats.totalCoinsEarned += dailyReward.bonusCoins ?? 0
        try? container.mainContext.save()
        WidgetCenter.shared.reloadTimelines(ofKind: "RewardMissionWidget")
        print("Daily reward claimed successfully")
        return .result()
    }
}
