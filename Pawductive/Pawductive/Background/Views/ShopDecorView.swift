//
//  ShopDecorView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftData
import SwiftUI

struct ShopDecorView: View {
    var storedDecor: StoredDecor
    var cardWidth: CGFloat
    
    var body: some View {
        VStack {
            Text(storedDecor.decor.name)
                .styleAsSubHeader()
            
            Text("Display \(storedDecor.shownDecors.count) : Store \(storedDecor.numStored)")
                .font(.caption)
                .fontDesign(.rounded)

            
            Image(storedDecor.decor.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: cardWidth * 0.8, height: cardWidth * 0.8)
            
            HStack {
                Button {
                    // TODO
                } label: {
                    Text("BUY").frame(maxWidth: .infinity)
                        .font(.caption)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button {
                    // TODO
                } label: {
                    Text("SELL").frame(maxWidth: .infinity)
                        .font(.caption)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            
            Text("Cost \(storedDecor.decor.cost) coins")
                .font(.caption)
                .fontDesign(.rounded)
        }
        .padding(10)
        .frame(width: cardWidth)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    let data = DataContainer()
    let storedDecor = try! data.context.fetch(FetchDescriptor<StoredDecor>()).first!
    ShopDecorView(storedDecor: storedDecor, cardWidth: 170).modelContainer(data.modelContainer)
}
