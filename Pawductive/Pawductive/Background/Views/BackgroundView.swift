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
    
    @Bindable var pet: Pet
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CanvasView(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                
                Picker("Background", selection: $pet.background) {
                    ForEach(backgrounds.sorted(by: { $0.name < $1.name })) { bg in
                        Text(bg.name).tag(bg)
                    }
                }
                .pickerStyle(.segmented)
                
                Spacer()
                
                DecorStoreView(width: geometry.size.width * 0.9, height: geometry.size.width * 0.8)
            }
            .navigationTitle("Edit Background")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.horizontal)
        }
    }
}

#Preview {
    let data = DataContainer(coins: 10000)
    let pet = try! data.context.fetch(FetchDescriptor<Pet>()).first!
    NavigationStack {
        BackgroundView(pet: pet)
    }
    .modelContainer(data.modelContainer)
}
