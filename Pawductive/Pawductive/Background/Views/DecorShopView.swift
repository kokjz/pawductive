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
    
    var cardWidth: CGFloat = 170
    var background: Background
    
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
                        d1, d2 in d1.decor.cost < d2.decor.cost
                    })) { storedDecor in
                        ShopDecorView(storedDecor: storedDecor, cardWidth: cardWidth)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    let data = DataContainer()
    let background = try! data.context.fetch(FetchDescriptor<Background>()).first!
    DecorShopView(background: background).modelContainer(data.modelContainer)
}
