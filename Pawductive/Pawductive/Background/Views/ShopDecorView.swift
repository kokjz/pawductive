//
//  ShopDecorView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftData
import SwiftUI

struct ShopDecorView: View {
    @Query private var users: [UserProfile]
    private var user: UserProfile {
        users.first!
    }
    
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
                .styleAsSubHeader()
            
            Text("Display \(storedDecor.shownDecors.count) / Store \(storedDecor.numStored)")
                .font(.caption)
                .fontDesign(.rounded)
            
            Image(storedDecor.decor.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: cardWidth * 0.8, height: cardWidth * 0.8)
            
            HStack {
                Button {
                    withAnimation(.bouncy){
                        user.coins -= storedDecor.decor.cost
                        storedDecor.numStored += 1
                    }
                    
                    missionManager.updateActiveMissions(
                        missions: DataContainer.dailyMissions,
                        details: MissionDetails(
                            action: "BUY",
                            targetType: "DECOR",
                            targetName: storedDecor.decor.name),
                        progress: 1)
                } label: {
                    Text("BUY").frame(maxWidth: .infinity)
                        .font(.caption)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                }
                .disabled(user.coins < storedDecor.decor.cost)
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button {
                    withAnimation(.bouncy) {
                        user.coins += storedDecor.decor.cost
                        storedDecor.numStored -= 1
                    }
                } label: {
                    Text("SELL").frame(maxWidth: .infinity)
                        .font(.caption)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                }
                .disabled(storedDecor.numStored <= 0)
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            
            Text("Cost: \(storedDecor.decor.cost) Coins")
                .font(.caption)
                .fontWeight(.medium)
                .fontDesign(.rounded)
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
    ShopDecorView(storedDecor: storedDecor, cardWidth: 170, cardHeight: 300)
        .modelContainer(data.modelContainer)
}
