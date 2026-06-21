//
//  DecorShopView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftUI
import SwiftData

struct DecorShopView: View {
    @Query private var users: [UserProfile]
    private var user: UserProfile {
        users.first!
    }
    
    @Query private var pets: [Pet]
    private var pet: Pet {
        pets.first!
    }
    var background: Background {
        pet.background
    }
    
    let cardWidth: CGFloat = 170
    let cardHeight: CGFloat = 300
    
    var body: some View {
        VStack {
            HStack {
                Text("Decor Shop")
                    .styleAsMainHeader()
                Spacer()
                UserCoinsView(profile: user)
            }
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: cardWidth, maximum: cardWidth), spacing: 20)
                ], spacing: 20) {
                    ForEach(background.storedDecors.sorted(by: {
                        $0.decor.cost < $1.decor.cost
                    })) { storedDecor in
                        ShopDecorView(storedDecor: storedDecor, cardWidth: cardWidth, cardHeight: cardHeight)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    DecorShopView().modelContainer(DataContainer().modelContainer)
}
