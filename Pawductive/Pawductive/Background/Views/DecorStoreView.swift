//
//  DecorStoreView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftData
import SwiftUI

struct DecorStoreView: View {
    var background: Background
    let cardWidth: CGFloat = 170
    let cardHeight: CGFloat = 270
    
    @State private var showDecorShop = false
    
    var body: some View {
        VStack {
            HStack {
                Text("STORAGE")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                
                Spacer()
                
                Button {
                    showDecorShop = true
                } label : {
                    Text("SHOP")
                        .font(.headline)
                        .fontDesign(.rounded)
                }
                .navigationDestination(isPresented: $showDecorShop) {
                    DecorShopView(background: background)
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [
                    GridItem(.adaptive(minimum: cardHeight, maximum: cardHeight), spacing: 20)
                ], spacing: 20) {
                    ForEach(background.storedDecors.filter({
                        $0.numStored > 0
                    }).sorted(by: {
                        $0.decor.cost < $1.decor.cost
                    })) { storedDecor in
                        StoreDecorView(storedDecor: storedDecor, cardWidth: cardWidth, cardHeight: cardHeight)
                    }
                }
            }
            .overlay {
                if background.storedDecors.filter({ $0.numStored > 0 }).isEmpty {
                    ContentUnavailableView {
                        Label("No Decors Stored Here", systemImage: "bin.xmark")
                    } description: {
                        Text("Buy some decors from the shop!")
                    }
                }
            }
        }
        .padding()
        .frame(height: 370)
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    let data = DataContainer(user: UserProfile(coins: 500))
    let background = try! data.context.fetch(FetchDescriptor<Background>()).first!
    NavigationStack {
        DecorStoreView(background: background)
    }
    .modelContainer(data.modelContainer)
}
