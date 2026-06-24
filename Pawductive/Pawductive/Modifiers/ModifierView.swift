//
//  ModifierView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 9/6/26.
//

import SwiftUI
import SwiftData

struct ModifierView: View {
    var modifier: Modifier
    var canLevelUp: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(modifier.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(modifier.details)
                    .font(.subheadline)
                Text("Level: \(modifier.level) / \(modifier.maxLevel)")
                    .font(.subheadline)
            }
            
            Spacer()
            
            Button("1 MP") { modifier.levelUp() }
                .fontWeight(.bold)
                .buttonStyle(.borderedProminent)
                .disabled(!canLevelUp)
        }
    }
}

#Preview {
    let modifier = Modifier(label: "test", name: "Modifier", details: "Description", level: 0, maxLevel: 5)
    ModifierView(modifier: modifier, canLevelUp: true)
}
