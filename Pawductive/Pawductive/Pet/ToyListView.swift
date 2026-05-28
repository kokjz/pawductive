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
    
    var currDate: Date
    
    var body: some View {
        List(user.toyInventory.keys.sorted{ $0.cost < $1.cost }, id: \.self) { toy in
            HStack {
                Label {
                    Text(toy.rawValue)
                        .font(.caption)
                        .fontDesign(.rounded)
                    Text("Available: \(user.toyInventory[toy, default: 0])")
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
        .frame(maxHeight: 300)
    }
}

#Preview {
    ToyListView(currDate: Date.now)
        .modelContainer(DataContainer(loadInventory: false).modelContainer)
    ToyListView(currDate: Date.now)
        .modelContainer(DataContainer(pet: Pet(name: "Doggy", mood: 50, energy: 50)).modelContainer)
}
