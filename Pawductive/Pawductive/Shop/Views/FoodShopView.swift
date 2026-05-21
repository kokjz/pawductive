//
//  FoodShopView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

import SwiftUI
import SwiftData

struct FoodShopView: View {
    @Query private var users: [User]
    
    private var user: User {
        users.first!
    }
    
    var body: some View {
        List(FoodCatalog.allCases, id: \.self) { food in
            HStack {
                Label {
                    Text(food.rawValue)
                        .font(.caption)
                        .fontDesign(.rounded)
                    Text("Bought: \(user.foodInventory[food, default: 0])")
                        .font(.caption2)
                        .fontDesign(.rounded)
                } icon: {
                    Image(food.image)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 40, minHeight: 40)
                }
                
                Spacer()
                
                Button {
                    user.buyFood(food)
                } label: {
                    // Designed by vectorsmarket15 from www.flaticon.com
                    HStack {
                        Text("\(food.cost)")
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
                .disabled(!user.canAfford(food.cost))
                .opacity(!user.canAfford(food.cost) ? 0.5 : 1)
            }
        }
    }
}

#Preview {
    FoodShopView()
        .modelContainer(UserContainer().modelContainer)
}
