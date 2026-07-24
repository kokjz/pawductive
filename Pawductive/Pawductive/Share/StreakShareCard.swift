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
    let pet: Pet
    
    var body: some View {
        VStack(spacing: 16) {
            //card title
            Text("Pawductive 🐾")
                .font(.system(.headline, design: .rounded))
                .bold()
                .foregroundColor(.white)
            
            //streak
            HStack(spacing: 12) {
                Text("🐐")
                    .font(.system(size: 36))
                Text("\(stats.currentStreak) Day Streak!")
                    .font(.system(.title, design: .rounded))
                    .bold()
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                Text("🔥")
                    .font(.system(size: 36))
            }
            
            //pet + bg render
            ZStack(alignment: .bottom) {
                CanvasView(width: 290, height: 180)
                    .allowsHitTesting(false)
                Image(pet.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75, alignment: .bottom)
                    .padding(.bottom, 8)
            }
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            
            //stats
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
    let container = DataContainer(inMemory: true)
    let context = container.context
    
    let background = Background(name: "Room", imageName: "room")
    context.insert(background)
    
    let pet = Pet(name: "DOG", mood: 100, energy: 100, experiencePoints: 500, background: background)
    context.insert(pet)
    
    let stats = UserStats(totalTasksCompleted: 12, totalMinutesFocused: 180, currentStreak: 5)
    context.insert(stats)
    
    return StreakShareCard(stats: stats, pet: pet)
        .modelContainer(container.modelContainer)
}
