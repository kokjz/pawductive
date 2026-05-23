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
    
    var body: some View {
        List(ToyCatalog.allCases, id: \.self) { toy in
            HStack {
                Label {
                    Text(toy.rawValue)
                        .font(.caption)
                        .fontDesign(.rounded)
                    Text("Bought: \(user.toyInventory[toy, default: 0])")
                        .font(.caption2)
                        .fontDesign(.rounded)
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
                            .foregroundStyle(.black)
                        Image(.coin)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 30, maxHeight: 30)
                    }
                    .frame(minWidth: 65, alignment: .trailing)
                }
                .buttonStyle(.bordered)
                .disabled(!user.canAfford(toy.cost))
                .opacity(!user.canAfford(toy.cost) ? 0.5 : 1)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ToyShopView()
        .modelContainer(DataContainer().modelContainer)
}
