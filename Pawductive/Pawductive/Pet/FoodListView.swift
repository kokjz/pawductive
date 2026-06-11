//
//  FoodListView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 23/5/26.
//

import SwiftData
import SwiftUI

struct FoodListView: View {
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
                        pet.update(currDate: currDate)
                        if pet.canReceive(food: food) {
                            pet.receive(food: food)
                            user.give(food: food)
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
                } description: {
                    Text("Visit the shop to buy more food!")
                }
            }
        }
        .listStyle(.plain)
        .frame(maxHeight: 200)
    }
}

#Preview {
    FoodListView(currDate: Date.now)
        .modelContainer(DataContainer(loadInventory: false).modelContainer)
    
    FoodListView(currDate: Date.now)
        .modelContainer(DataContainer(pet: Pet(name: "Doggy", mood: 50, energy: 50)).modelContainer)
}
