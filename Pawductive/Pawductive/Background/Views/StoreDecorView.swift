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
    
    @Query private var missionManagers: [MissionManager]
    private var missionManager: MissionManager {
        missionManagers.first!
    }
    
    let storedDecor: StoredDecor
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var body: some View {
        VStack {
            Text(storedDecor.decor.name)
                .font(.headline)
                .fontDesign(.rounded)
            
            Text("Display \(storedDecor.shownDecors.count) / Store \(storedDecor.numStored)")
                .font(.caption)
                .fontDesign(.rounded)
            
            Image(storedDecor.decor.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: cardWidth * 0.5, height: cardWidth * 0.5)
            
            Button {
                withAnimation(.bouncy){
                    storedDecor.display(context: context)
                }
                
                missionManager.updateActiveMissions(
                    missions: DataContainer.dailyMissions,
                    details: MissionDetails(
                        action: "DISPLAY",
                        targetType: "DECOR",
                        targetName: storedDecor.decor.name),
                    progress: 1)
            } label: {
                Text("Display Decor")
                    .font(.caption)
                    .fontWeight(.medium)
                    .fontDesign(.rounded)
            }
            .disabled(!storedDecor.hasStored())
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
    StoreDecorView(storedDecor: storedDecor, cardWidth: 150, cardHeight: 180)
        .modelContainer(data.modelContainer)
}
