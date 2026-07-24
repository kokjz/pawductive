//
//  FoodListView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 23/5/26.
//

import SwiftData
import SwiftUI

struct FoodStoreView: View {
    @Query private var users: [UserProfile]
    private var user: UserProfile {
        users.first!
    }
    
    @Query private var pets: [Pet]
    private var pet: Pet {
        pets.first!
    }
    
    @Query private var missionManagers: [MissionManager]
    private var missionManager: MissionManager {
        missionManagers.first!
    }
    
    @Query private var modifiers: [Modifier]
    private var moodDecayModifier: Modifier? {
        modifiers.first(where: { $0.label == "pet.mood" })
    }
    private var energyDecayModifier: Modifier? {
        modifiers.first(where: { $0.label == "pet.energy" })
    }
    private var moodModifier: Modifier? {
        modifiers.first(where: { $0.label == "food.mood" })
    }
    private var energyModifier: Modifier? {
        modifiers.first(where: { $0.label == "food.energy" })
    }
    
    @State private var eatTask: Task<Void, Never>?
    
    var currDate: Date
    
    var body: some View {
        List(Food.allFoods.filter({ food in user.foodInventory.keys.contains(food.name) })) { food in
            HStack {
                Label {
                    Text(food.name)
                        .font(.caption)
                        .fontDesign(.rounded)
                    Text("Available: \(user.foodInventory[food.name, default: 0])")
                        .font(.caption2)
                        .fontDesign(.rounded)
                } icon: {
                    Image(food.image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 40, minHeight: 40)
                }
                
                Spacer()
                
                Button("Give") {
                    withAnimation {
                        pet.update(currDate: currDate, moodDecayModifier: moodDecayModifier, energyDecayModifier: energyDecayModifier)
                        if pet.canReceive(food: food) {
                            pet.receive(food: food, moodModifier: moodModifier, energyModifier: energyModifier)
                            user.give(food: food)
                            
                            eatTask?.cancel()
                            eatTask = Task {
                                pet.state = .eating
                                try? await Task.sleep(for: .seconds(3))
                                if Task.isCancelled { return }
                                guard pet.state == .eating else { return }
                                pet.state = .resting
                            }
                            
                            missionManager.updateActiveMissions(
                                missions: DataContainer.dailyMissions,
                                details: MissionDetails(
                                    action: "GIVE",
                                    targetType: "FOOD",
                                    targetName: food.name),
                                progress: 1)
                        }
                    }
                }
                .fontWeight(.bold)
                .buttonStyle(.borderedProminent)
                .disabled(!pet.canReceive(food: food))
            }
        }
        .overlay {
            if user.foodInventory.isEmpty {
                ContentUnavailableView {
                    Label("No More Food...", systemImage: "basket")
                        .font(.headline)
                        .imageScale(.small)
                } description: {
                    Text("Visit the shop to buy more food!")
                        .font(.subheadline)
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    FoodStoreView(currDate: Date.now)
        .modelContainer(DataContainer().modelContainer)
}
