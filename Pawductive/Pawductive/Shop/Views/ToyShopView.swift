//
//  ToyShopView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

import SwiftUI
import SwiftData

struct ToyShopView: View {
    @Query private var users: [UserProfile]
    
    private var user: UserProfile {
        users.first!
    }
    
    func description(_ toy: Toy) -> String {
        let mood = "Mood +" + String(format: "%.1f", toy.moodEffects)
        let energy = "Energy " + String(format: "%.1f", toy.energyEffects)
        return "\(mood), \(energy)"
    }
    
    var body: some View {
        List(Toy.allToys) { toy in
            HStack {
                Label {
                    Text(toy.name)
                        .font(.headline)
                    Text(description(toy))
                        .lineLimit(1)
                        .font(.subheadline)
                        .minimumScaleFactor(0.5)
                    Text("Owned: \(user.toyInventory[toy.name, default: 0])")
                        .font(.subheadline)
                } icon: {
                    Image(toy.image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 40, minHeight: 40)
                }
                
                Spacer()
                
                Button {
                    user.buy(toy: toy)
                } label: {
                    // Designed by vectorsmarket15 from www.flaticon.com
                    HStack {
                        Text("\(toy.cost)")
                            .fontWeight(.semibold)
                        Image(.coin)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 30)
                    }
                    .frame(minWidth: 65, alignment: .trailing)
                }
                .buttonStyle(.bordered)
                .disabled(!user.canAfford(cost: toy.cost))
                .opacity(!user.canAfford(cost: toy.cost) ? 0.5 : 1)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ToyShopView()
        .modelContainer(DataContainer().modelContainer)
}
