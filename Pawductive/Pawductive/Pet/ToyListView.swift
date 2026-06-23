//
//  ToyListView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 23/5/26.
//

import SwiftData
import SwiftUI

struct ToyListView: View {
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
    
    @State private var playTask: Task<Void, Never>?
    
    var currDate: Date
    
    var body: some View {
        List(Toy.allToys.filter({ toy in user.toyInventory.keys.contains(toy.name) })) { toy in
            HStack {
                Label {
                    Text(toy.name)
                        .font(.caption)
                        .fontDesign(.rounded)
                    Text("Available: \(user.toyInventory[toy.name, default: 0])")
                        .font(.caption2)
                        .fontDesign(.rounded)
                } icon: {
                    Image(toy.image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 40, minHeight: 40)
                }
                
                Spacer()
                
                Button("Give") {
                    withAnimation {
                        pet.update(currDate: currDate)
                        if pet.canReceive(toy: toy) {
                            pet.receive(toy: toy)
                            user.give(toy: toy)
                            
                            playTask?.cancel()
                            playTask = Task {
                                pet.state = .playing
                                try? await Task.sleep(for: .seconds(3))
                                if Task.isCancelled { return }
                                guard pet.state == .playing else { return }
                                pet.state = .resting
                            }
                            
                            missionManager.updateActiveMissions(
                                missions: DataContainer.dailyMissions,
                                details: MissionDetails(
                                    action: "GIVE",
                                    targetType: "TOY",
                                    targetName: toy.name),
                                progress: 1)
                        }
                    }
                }
                .fontWeight(.bold)
                .buttonStyle(.borderedProminent)
                .disabled(!pet.canReceive(toy: toy))
            }
        }
        .overlay {
            if user.toyInventory.isEmpty {
                ContentUnavailableView {
                    Label("No More Toys...", systemImage: "basket")
                } description: {
                    Text("Visit the shop to buy more toys!")
                }
            }
        }
        .listStyle(.plain)
        .frame(maxHeight: 200)
    }
}

#Preview {
    ToyListView(currDate: Date.now)
        .modelContainer(DataContainer(loadInventory: false).modelContainer)
    ToyListView(currDate: Date.now)
        .modelContainer(DataContainer(mood: 50, energy: 50).modelContainer)
}
