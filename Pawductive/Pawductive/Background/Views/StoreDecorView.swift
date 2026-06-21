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
    
    let storedDecor: StoredDecor
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
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
                .frame(width: cardHeight * 0.4, height: cardHeight * 0.4)
            
            Button {
                withAnimation(.bouncy){
                    storedDecor.numStored -= 1
                    context.insert(ShownDecor(order: storedDecor.background.shownDecors.count,
                                              storedDecor: storedDecor,
                                              background: storedDecor.background))
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
    let data = DataContainer()
    let storedDecor = try! data.context.fetch(FetchDescriptor<StoredDecor>()).first!
    StoreDecorView(storedDecor: storedDecor, cardWidth: 170, cardHeight: 230)
        .modelContainer(data.modelContainer)
}
