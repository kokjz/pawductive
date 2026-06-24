//
//  DecorStoreView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftData
import SwiftUI

struct DecorStoreView: View {
    @Query private var pets: [Pet]
    private var pet: Pet {
        pets.first!
    }
    var background: Background {
        pet.background
    }
    
    let width: CGFloat
    let cardWidth: CGFloat = 150
    let cardHeight: CGFloat = 180
    
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
                    DecorShopView()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
            
            ScrollView(.horizontal) {
                LazyHGrid(rows: [
                    GridItem(.adaptive(minimum: cardHeight, maximum: cardHeight), spacing: 20)
                ], spacing: 10) {
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
                        Label("No Stored Decors", systemImage: "bin.xmark")
                    } description: {
                        Text("Buy some decors from the shop!")
                    }
                }
            }
        }
        .padding()
        .frame(width: width)
        .background(Color(.systemFill))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    NavigationStack {
        DecorStoreView(width: 400 * 0.9)
    }
    .modelContainer(DataContainer().modelContainer)
}
