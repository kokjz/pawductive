//
//  DailyRewardsView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 9/7/26.
//

import AppIntents
import WidgetKit
import SwiftData
import SwiftUI

struct DailyRewardView: View {
    @Query private var dailyRewards: [DailyReward]
    private var dailyReward: DailyReward {
        dailyRewards.first!
    }
    
    @Query private var users: [UserProfile]
    private var user: UserProfile {
        users.first!
    }
    
    @Environment(\.widgetRenderingMode) private var widgetMode
    @Environment(\.modelContext) private var context
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Free \(dailyReward.rewardType)!")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                Text("1x \(dailyReward.reward)")
                    .font(.caption)
                    .fontDesign(.rounded)
                if let coins = dailyReward.bonusCoins {
                    Text("Bonus: \(coins) coins")
                        .font(.caption)
                        .fontDesign(.rounded)
                }
            }
            
            Spacer()

            Button(intent: ClaimRewardIntent(modelContainer: context.container)) {
                Text(dailyReward.claimed ? "Claimed" : "Claim")
            }
            .fontWeight(.semibold)
            .buttonStyle(.bordered)
            .disabled(dailyReward.claimed)
            .animation(.default, value: dailyReward.claimed)
        }
        .onAppear {
            dailyReward.update()
//            // FOR TESTING ONLY
//            dailyReward.bonusCoins = 90
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground).opacity(widgetMode == .fullColor ? 1 : 0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ScrollView {
        DailyRewardView()
    }
    .padding(.horizontal)
    .frame(width: .infinity, height: .infinity)
    .background(Color(.secondarySystemBackground))
    .modelContainer(DataContainer().modelContainer)
}
