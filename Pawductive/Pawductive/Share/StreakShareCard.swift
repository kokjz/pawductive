//
//  StreakShareCard.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 24/7/26.
//

import SwiftUI
import SwiftData

struct StreakShareCard: View {
    let stats: UserStats
    let petName: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Pawductive 🐾")
                .font(.system(.headline, design: .rounded))
                .bold()
                .foregroundColor(.white)
            HStack(spacing: 16) {
                Text("🐐🔥")
                    .font(.system(size: 48))
                Text("\(stats.currentStreak) Day Streak!")
                    .font(.system(.title2, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")
                    Text("\(stats.totalMinutesFocused) Mins Focused")
                }
                .font(.caption)
                .bold()
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.white)
                
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("\(stats.totalTasksCompleted) Tasks")
                }
                .font(.caption)
                .bold()
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.2))
                .cornerRadius(8)
                .foregroundColor(.white)
            }
        }
        .padding(20)
        .frame(width: 340)
        .background(
            LinearGradient(
                colors: [Color.orange, Color.red.opacity(0.85)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    StreakShareCard(
        stats: UserStats(totalTasksCompleted: 12, totalMinutesFocused: 180, currentStreak: 5),
        petName: "DOG"
    )
}
