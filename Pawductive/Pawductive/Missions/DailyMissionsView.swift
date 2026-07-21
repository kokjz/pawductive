//
//  DailyMissionsView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 23/6/26.
//

import WidgetKit
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
    
    @Environment(\.widgetRenderingMode) private var widgetMode

    var body: some View {
        ForEach(missionManager.activeMissions.sorted(by: { m1, m2 in
            m1.title < m2.title
        })) { mission in
            HStack {
                VStack(alignment: .leading) {
                    Text(mission.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .fontDesign(.rounded)
                    Text("Progress: \(min(mission.progress, mission.requirement)) / \(mission.requirement)")
                        .font(.caption)
                        .fontDesign(.rounded)
                    Text("Reward: \(mission.reward) coins")
                        .font(.caption)
                        .fontDesign(.rounded)
                }
                
                Spacer()
                
                Button(mission.claimed ? "Claimed" : "Claim") {
                    user.coins += mission.reward
                    mission.claimed = true
                }
                .fontWeight(.semibold)
                .buttonStyle(.bordered)
                .disabled(mission.claimed || mission.progress < mission.requirement)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color(.systemBackground).opacity(widgetMode == .fullColor ? 1 : 0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .onAppear {
            missionManager.refreshActiveMissions(missions: DataContainer.dailyMissions)
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
