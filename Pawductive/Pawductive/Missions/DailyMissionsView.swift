//
//  DailyMissionsView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 23/6/26.
//

import SwiftData
import SwiftUI

struct DailyMissionsView: View {
    @Query private var missionManagers: [MissionManager]
    private var missionManager: MissionManager {
        missionManagers.first!
    }
    
    @Query private var users: [UserProfile]
    private var user: UserProfile {
        users.first!
    }
    
    var body: some View {
        ForEach(missionManager.activeMissions.sorted(by: { m1, m2 in
            m1.title < m2.title
        })) { mission in
            HStack {
                VStack(alignment: .leading) {
                    Text(mission.title)
                        .font(.headline)
                        .fontDesign(.rounded)
                    Text("Progress: \(min(mission.progress, mission.requirement)) / \(mission.requirement)")
                        .font(.subheadline)
                        .fontDesign(.rounded)
                    Text("Reward: \(mission.reward) coins")
                        .font(.subheadline)
                        .fontDesign(.rounded)
                        .fontWeight(.medium)
                }
                
                Spacer()
                
                Button {
                    user.coins += mission.reward
                    mission.claimed = true
                } label: {
                    Text(mission.claimed ? "Claimed" : "Claim")
                }
                .buttonStyle(.borderedProminent)
                .disabled(mission.claimed || mission.progress < mission.requirement)
            }
            .padding()
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    ScrollView {
        DailyMissionsView()
    }
    .padding(.horizontal)
    .frame(width: .infinity, height: .infinity)
    .background(Color(.secondarySystemBackground))
    .modelContainer(DataContainer().modelContainer)
}
