//
//  StatsDashboardView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 24/7/26.
//

import SwiftUI
import SwiftData
import Charts

struct StatsDashboardView: View {
    @Query private var statsList: [UserStats]
    @Query private var pets: [Pet]
    @Query(filter: #Predicate<TaskItem> { $0.isCompleted }) private var completedTasks: [TaskItem]
    @Query private var categories: [TaskCategory]
    @Environment(\.dismiss) private var dismiss
    var now: Date { Date() }
    
    //compute category chart data
    private var categoryStats: [CategoryStat] {
        var durationMap: [String: Int] = [:]
        for task in completedTasks {
            durationMap[task.categoryName, default: 0] += task.expectedDurationInMinutes
        }
        return durationMap.map { (categoryName, totalMins) in
            let icon = categories.first(where: { $0.name == categoryName })?.iconName ?? "📁"
            return CategoryStat(categoryName: categoryName, minutesFocused: totalMins, iconName: icon)
        }.sorted(by: { $0.minutesFocused > $1.minutesFocused })
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                //user stats
                if let stats = statsList.first {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("User Statistics")
                            .styleAsSubHeader()
                        coinStatCard(
                            title: "Lifetime Coins Earned",
                            value: "\(stats.totalCoinsEarned)"
                        )
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
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                
                //task category breakdown chart
                VStack(alignment: .leading, spacing: 12) {
                    Text("Task Category Breakdown")
                        .styleAsSubHeader()
                    if categoryStats.isEmpty {
                        ContentUnavailableView(
                            "No Focus Data Yet",
                            systemImage: "chart.pie.fill",
                            description: Text("Complete new tasks to view your task category breakdown chart!")
                        )
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    } else {
                        VStack(spacing: 16) {
                            //donut chart
                            Chart(categoryStats) { stat in
                                SectorMark(
                                    angle: .value("Minutes", stat.minutesFocused),
                                    innerRadius: .ratio(0.6),
                                    angularInset: 1.5
                                )
                                .cornerRadius(4)
                                .foregroundStyle(by: .value("Category", stat.categoryName))
                            }
                            .frame(height: 220)
                            .padding(.vertical, 8)
                            
                            //categories legend
                            VStack(spacing: 8) {
                                ForEach(categoryStats) { stat in
                                    HStack {
                                        Text(stat.iconName)
                                            .font(.title3)
                                            .frame(width: 28, height: 28, alignment: .center)
                                        Text(stat.categoryName)
                                            .font(.headline)
                                        Spacer()
                                        Text("\(stat.minutesFocused) mins")
                                            .font(.subheadline)
                                            .bold()
                                            .foregroundColor(.secondary)
                                    }
                                    .padding(.vertical, 2)
                                    Divider()
                                }
                            }
                        }
                        .padding()
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(12)
                    }
                }
                
                //pet stats
                if let pet = pets.first {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Pet Statistics")
                            .styleAsSubHeader()
                        HStack(spacing: 16) {
                            statCard(
                                title: "Total Food Received",
                                value: "\(pet.totalFoodReceived)",
                                icon: "fork.knife.circle.fill",
                                color: .yellow
                            )
                            statCard(
                                title: "Total Toys Received",
                                value: "\(pet.totalToysReceived)",
                                icon: "baseball.fill",
                                color: .yellow
                            )
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        HStack(spacing: 16) {
                            statCard(
                                title: "High Mood Streak",
                                value: "\(pet.highMoodStreak(now: now)) Days",
                                icon: "face.smiling.inverse",
                                color: .orange
                            )
                            statCard(
                                title: "High Energy Streak",
                                value: "\(pet.highEnergyStreak(now: now)) Days",
                                icon: "bolt.circle.fill",
                                color: .orange
                            )
                        }
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Statistics Dashboard")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .toolbar(.hidden, for: .tabBar)
    }

    private func statCardBase<Icon: View>(title: String, value: String, @ViewBuilder icon: () -> Icon) -> some View {
        HStack(spacing: 12) {
            icon()
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
    
    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        statCardBase(title: title, value: value) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
        }
    }
    
    private func coinStatCard(title: String, value: String) -> some View {
        statCardBase(title: title, value: value) {
            Image(.coin)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
        }
    }
}

#Preview {
    NavigationStack {
        StatsDashboardView()
    }
    .modelContainer(DataContainer(inMemory: true).modelContainer)
}
