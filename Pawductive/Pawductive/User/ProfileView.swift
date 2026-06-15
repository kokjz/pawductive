//
//  ProfileView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 15/6/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    //fetch stats from db
    @Query private var statsList: [UserStats]
    
    var body: some View {
        VStack(spacing: 24) {
            //header
            HStack {
                Text("User Profile")
                    .styleAsMainHeader()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            if let stats = statsList.first {
                //stats dashboard
                VStack(alignment: .leading, spacing: 12) {
                    Text("Statistics")
                        .styleAsSubHeader()
                        .padding(.horizontal)
                    HStack(spacing: 16) {
                        statCard(
                            title: "Total Tasks Completed",
                            value: "\(stats.totalTasksCompleted)",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        statCard(
                            title: "Total Minutes Focused",
                            value: "\(stats.totalMinutesFocused)",
                            icon: "clock.fill",
                            color: .blue
                        )
                    }
                    .padding(.horizontal)
                }
                
                //achievement list
                VStack(alignment: .leading, spacing: 12) {
                    Text("Achievements")
                        .styleAsSubHeader()
                        .padding(.horizontal)
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(Achievement.allCases) { achievement in achievementRow(achievement: achievement, stats: stats) }
                        }
                        .padding(.horizontal)
                    }
                }
            } else { //database empty
                ContentUnavailableView("No Stats Available", systemImage: "person.crop.circle.badge.exclamationmark")
            }
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
    
    //statcard component
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(.title2, design: .rounded))
                    .bold()
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    //achievement row component
    private func achievementRow(achievement: Achievement, stats: UserStats) -> some View {
        let unlocked = achievement.isunlocked(stats: stats)
        return HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(unlocked ? Color.orange.opacity(0.1) : Color.gray.opacity(0.1))
                    .frame(width: 48, height: 48)
                Text(unlocked ? "🏆" : "🔒")
                    .font(.title2)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.headline)
                    .foregroundColor(unlocked ? .primary : .secondary)
                Text(achievement.requirementDescription)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .opacity(unlocked ? 1.0 : 0.6) //gray out if locked
    }
}

#Preview {
    ProfileView()
        .modelContainer(DataContainer().modelContainer)
}
