//
//  FoodShopView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

import SwiftUI
import SwiftData

struct FoodShopView: View {
    @Query private var users: [UserProfile]
    
    private var user: UserProfile {
        users.first!
    }
    
    func description(_ food: Food) -> String {
        let mood = "Mood +" + String(format: "%.1f", food.moodEffects)
        let energy = "Energy +" + String(format: "%.1f", food.energyEffects)
        return "\(mood), \(energy)"
    }
    
    var body: some View {
        List(Food.allFoods) { food in
            HStack {
                Label {
                    Text(food.name)
                        .font(.headline)
                    Text(description(food))
                        .lineLimit(1)
                        .font(.subheadline)
                        .minimumScaleFactor(0.5)
                    Text("Owned: \(user.foodInventory[food.name, default: 0])")
                        .font(.subheadline)
                } icon: {
                    Image(food.image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 40, minHeight: 40)
                }
                
                Spacer()
                
                Button {
                    user.buy(food: food)
                } label: {
                    // Designed by vectorsmarket15 from www.flaticon.com
                    HStack {
                        Text("\(food.cost)")
                            .fontWeight(.semibold)
                        Image(.coin)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 30)
                    }
                    .frame(minWidth: 65, alignment: .trailing)
                }
                .buttonStyle(.bordered)
                .disabled(!user.canAfford(cost: food.cost))
                .opacity(!user.canAfford(cost: food.cost) ? 0.5 : 1)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    FoodShopView()
        .modelContainer(DataContainer().modelContainer)
}
