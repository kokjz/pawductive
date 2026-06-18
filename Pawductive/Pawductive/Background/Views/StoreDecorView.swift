//
//  StoreDecorView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftUI
import SwiftData

struct StoreDecorView: View {
    @Environment(\.modelContext) private var context
    
    var storedDecor: StoredDecor
    var cardWidth: CGFloat
    var cardHeight: CGFloat
    
    var body: some View {
        VStack {
            Text(storedDecor.decor.name)
                .styleAsSubHeader()
            
            Text("Display \(storedDecor.shownDecors.count) / Store \(storedDecor.numStored)")
                .font(.caption)
                .fontDesign(.rounded)
            
            Image(storedDecor.decor.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: cardWidth * 0.8, height: cardWidth * 0.8)
            
            Button {
                withAnimation(.bouncy){
                    storedDecor.numStored -= 1
                    context.insert(ShownDecor(storedDecor: storedDecor))
                }
            } label: {
                Text("Display Decor")
                    .font(.caption)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
            }
            .disabled(storedDecor.numStored <= 0)
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
        .padding()
        .frame(width: cardWidth, height: cardHeight)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    let data = DataContainer(user: UserProfile(coins: 500))
    let storedDecor = try! data.context.fetch(FetchDescriptor<StoredDecor>()).first!
    StoreDecorView(storedDecor: storedDecor, cardWidth: 170, cardHeight: 270)
        .modelContainer(data.modelContainer)
}
