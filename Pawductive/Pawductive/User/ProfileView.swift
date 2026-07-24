//
//  ProfileView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 15/6/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var statsList: [UserStats]
    @Query private var pets: [Pet]
    @Query private var users: [UserProfile]
    private var user: UserProfile {
        users.first!
    }
    
    @Query private var modifiers: [Modifier]
    private var moodDecayModifier: Modifier? {
        modifiers.first(where: { $0.label == "pet.mood" })
    }
    private var energyDecayModifier: Modifier? {
        modifiers.first(where: { $0.label == "pet.energy" })
    }
    
    @State private var showNotificationManager: Bool = false
    @State private var showSettingsManager: Bool = false
    
    var now: Date {
        return Date()
//            .addingTimeInterval(24 * 3600 * 5) // FOR TESTING ONLY
    }
    
    var body: some View {
        VStack(spacing: 24) {
            //header
            HStack {
                Text("User Profile")
                    .styleAsMainHeader()
                Spacer()
                Image(systemName: "bell.badge.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.orange)
                    .onTapGesture {
                        showNotificationManager = true
                    }
                    .navigationDestination(isPresented: $showNotificationManager) {
                        NotificationManagerView()
                    }
                Image(systemName: "gearshape.circle.fill")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                    .onTapGesture {
                        showSettingsManager = true
                    }
                    .navigationDestination(isPresented: $showSettingsManager) {
                        SettingsManagerView()
                    }
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Daily Rewards")
                        .styleAsSubHeader()
                    DailyRewardView()
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Daily Missions")
                        .styleAsSubHeader()
                    DailyMissionsView()
                }
                .padding(.horizontal)
                .padding(.top)
                
                if let stats = statsList.first, let pet = pets.first {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Statistics")
                            .styleAsSubHeader()
                        
                        //daily streak card
                        streakCard(stats: stats, pet: pet)
                        
                        //navlink to stats dashboard
                        NavigationLink(destination: StatsDashboardView()) {
                            HStack(spacing: 12) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                Text("View More Statistics")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    .onAppear {
                        pet.update(
                            currDate: now,
                            moodDecayModifier: moodDecayModifier,
                            energyDecayModifier: energyDecayModifier
                        )
                    }
                    
                    //achievement list
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Achievements")
                            .styleAsSubHeader()
                        VStack(spacing: 12) {
                            ForEach(sortedAchievements(stats: stats, pet: pet)) { achievement in
                                achievementRow(achievement: achievement, stats: stats, pet: pet)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
//                    // CHEATS (FOR TESTING)
//                    HStack {
//                        Button() {
//                            user.coins += 999
//                        } label: {
//                            Text("FREE COINS").frame(width: 150)
//                        }
//                        .buttonStyle(.borderedProminent)
//                        Button {
//                            pet.totalExperiencePoints += 999
//                        } label: {
//                            Text("INCREASE XP").frame(width: 150)
//                        }
//                        .buttonStyle(.borderedProminent)
//                    }
//                    .padding()
                } else { //database empty
                    ContentUnavailableView("No Stats Available", systemImage: "person.crop.circle.badge.exclamationmark")
                }
                Spacer()
            }
        }
        .background(Color(.systemGroupedBackground))
    }
    
    //streakcard component with sharelink
    @ViewBuilder
    private func streakCard(stats: UserStats, pet: Pet) -> some View {
        let streak = stats.currentStreak
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(streak > 0 ? Color.orange.opacity(0.1) : Color.gray.opacity(0.1))
                    .frame(width: 75, height: 75)
                Text(streak > 0 ? "🐐🔥" : "💔🥀")
                    .font(.title2)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Streak: \(streak) Day\(streak == 1 ? "" : "s")")
                    .font(.system(.title3, design: .rounded))
                    .bold()
                    .foregroundColor(streak > 0 ? .orange : .secondary)
                Text(streak > 0 ? "On fire! Keep it up goat!" : "Come on, do something...")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            if let shareImage = renderStreakCard(stats: stats, pet: pet) {
                ShareLink(
                    item: shareImage,
                    subject: Text("My Pawductive Streak"),
                    message: Text("I'm on a \(streak)-day focus streak on Pawductive! 🐾🔥"),
                    preview: SharePreview("Pawductive Focus Streak", image: shareImage)
                ) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                        .foregroundColor(.orange)
                        .padding(10)
                        .background(Color.orange.opacity(0.12))
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(streak > 0 ? Color.orange.opacity(0.2) : Color.clear, lineWidth: 1))
    }
    
    //imagerenderer for share sheet
    @MainActor
    private func renderStreakCard(stats: UserStats, pet: Pet) -> Image? {
        let card = StreakShareCard(stats: stats, pet: pet)
            .modelContext(modelContext)
        let renderer = ImageRenderer(content: card)
        renderer.scale = 3.0
        if let uiImage = renderer.uiImage { return Image(uiImage: uiImage) }
        return nil
    }
    
    //achievement row component
    private func achievementRow(achievement: Achievement, stats: UserStats, pet: Pet) -> some View {
        let unlocked = achievement.isUnlocked(stats: stats, pet: pet)
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
        .opacity(unlocked ? 1.0 : 0.8) //gray out if locked
    }
    
    //achievement sort by completion
    private func sortedAchievements(stats: UserStats, pet: Pet) -> [Achievement] {
        Achievement.allCases.sorted { a, b in
            let aUnlocked = a.isUnlocked(stats: stats, pet: pet)
            let bUnlocked = b.isUnlocked(stats: stats, pet: pet)
            if aUnlocked == bUnlocked {
                let aIndex = Achievement.allCases.firstIndex(of: a) ?? 0
                let bIndex = Achievement.allCases.firstIndex(of: b) ?? 0
                return aIndex < bIndex
            }
            return aUnlocked && !bUnlocked
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .modelContainer(DataContainer().modelContainer)
}
