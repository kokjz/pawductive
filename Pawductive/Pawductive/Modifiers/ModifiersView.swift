//
//  ModifiersView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 10/6/26.
//

import SwiftUI
import SwiftData

struct ModifiersView: View {
    @Query(sort: \Modifier.label) private var modifiers: [Modifier]
    
    @Query private var pets: [Pet]
    private var pet: Pet {
        pets.first!
    }
    
    private func canLevelUp(_ m: Modifier) -> Bool {
        return m.level < m.maxLevel && modifierPointsLeft > 0
    }
    
    private var modifierPointsLeft : Int {
        var modifierPointsLeft = pet.modifierPoints
        for modifier in modifiers {
            modifierPointsLeft -= modifier.level
        }
        return modifierPointsLeft
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Modifiers")
                    .styleAsMainHeader()
                
                Spacer()
                
                Text("MP: \(modifierPointsLeft)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 20).fill(.tint))
            }
            .padding(.horizontal)

            List {
                Section("Pets") {
                    ForEach(modifiers.filter({ m in m.label.contains("Pet") })) { modifier in
                        ModifierView(modifier: modifier, canLevelUp: canLevelUp(modifier))
                    }
                }
                
                Section("Food") {
                    ForEach(modifiers.filter({ m in m.label.contains("Food") })) { modifier in
                        ModifierView(modifier: modifier, canLevelUp: canLevelUp(modifier))
                    }
                }
                
                Section("Toys") {
                    ForEach(modifiers.filter({ m in m.label.contains("Toy") })) { modifier in
                        ModifierView(modifier: modifier, canLevelUp: canLevelUp(modifier))
                    }
                }
            }
            .listStyle(.plain)
        }
        .padding(.top)
    }
}

#Preview {
    ModifiersView().modelContainer(DataContainer().modelContainer)
}
