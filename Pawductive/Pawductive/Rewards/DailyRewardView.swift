//
//  DailyRewardsView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 9/7/26.
//

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
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Free \(dailyReward.rewardType)!")
                    .font(.headline)
                    .fontDesign(.rounded)
                Text("1x \(dailyReward.reward)")
                    .font(.subheadline)
                    .fontDesign(.rounded)
                if let coins = dailyReward.bonusCoins {
                    Text("Bonus: \(coins) coins")
                        .font(.subheadline)
                        .fontDesign(.rounded)
                }
            }
            
            Spacer()
            
            Button {
                dailyReward.claimReward(user: user)
            } label: {
                Text(dailyReward.claimed ? "Claimed" : "Claim")
            }
            .buttonStyle(.borderedProminent)
            .disabled(dailyReward.claimed)
        }
        .onAppear {
            dailyReward.update()
//            dailyReward.bonusCoins = 90 // FOR TESTING ONLY
        }
        .padding()
        .background(Color(.systemBackground))
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
