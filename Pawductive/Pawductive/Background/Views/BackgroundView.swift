//
//  BackgroundView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 19/6/26.
//

import SwiftData
import SwiftUI

struct BackgroundView: View {
    @Query private var backgrounds: [Background]
    
    @Query private var pets: [Pet]
    private var pet: Pet {
        pets.first!
    }
    
    var body: some View {
        @Bindable var pet = pet
        GeometryReader { geometry in
            VStack {
                CanvasView(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                
                Picker("Background", selection: $pet.background) {
                    ForEach(backgrounds.sorted(by: { $0.name < $1.name })) { bg in
                        Text(bg.name).tag(bg)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: geometry.size.width * 0.9, alignment: .center)
                
                Spacer()
                
                DecorStoreView(width: geometry.size.width * 0.9)
            }
            .navigationTitle("Edit Background")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }
}

#Preview {
    let data = DataContainer(coins: 10000)
    NavigationStack {
        BackgroundView()
    }
    .modelContainer(data.modelContainer)
}
