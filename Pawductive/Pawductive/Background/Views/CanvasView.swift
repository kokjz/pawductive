//
//  CanvasView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftData
import SwiftUI

struct CanvasView: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \ShownDecor.order)
    private var shownDecors: [ShownDecor]
    
    @Query private var pets: [Pet]
    private var pet: Pet {
        pets.first!
    }
    var background: Background {
        pet.background
    }
    
    let width: CGFloat
    let height: CGFloat
    
    @State private var dragStartX: Double?
    @State private var dragStartY: Double?
    
    var body: some View {
        ZStack {
            Image(background.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipped()
            
            ForEach(shownDecors.filter{ $0.background == background }) { shownDecor in
                let aspectRatio = UIImage(named: shownDecor.storedDecor.decor.imageName)!.size.width
                                / UIImage(named: shownDecor.storedDecor.decor.imageName)!.size.height
                
                let imageHeight = shownDecor.storedDecor.decor.relativeHeight * height
                let imageWidth = aspectRatio * imageHeight
                
                let minRelativeX = (imageWidth / 2) / width
                let minRelativeY = (imageHeight / 2) / height
                
                let maxRelativeX = (width - imageWidth / 2) / width
                let maxRelativeY = (height - imageHeight / 2) / height

                Image(shownDecor.storedDecor.decor.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: shownDecor.storedDecor.decor.relativeHeight * height)
                    .position(x: shownDecor.relativeX * width, y: shownDecor.relativeY * height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if dragStartX == nil || dragStartY == nil {
                                    dragStartX = shownDecor.relativeX
                                    dragStartY = shownDecor.relativeY
                                    
                                    for decor in background.shownDecors {
                                        if decor.order > shownDecor.order {
                                            decor.order -= 1
                                        }
                                    }
                                    
                                    shownDecor.order = background.shownDecors.count - 1
                                }
                                
                                shownDecor.relativeX = dragStartX! + value.translation.width / width
                                shownDecor.relativeY = dragStartY! + value.translation.height / height
                                shownDecor.relativeX = max(minRelativeX, min(maxRelativeX, shownDecor.relativeX))
                                shownDecor.relativeY = max(minRelativeY, min(maxRelativeY, shownDecor.relativeY))
                            }
                            .onEnded { value in
                                dragStartX = nil
                                dragStartY = nil
                            }
                    )
                    .onTapGesture {
                        withAnimation {
                            shownDecor.storedDecor.numStored += 1
                            context.delete(shownDecor)
                        }
                    }
            }
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    let data = DataContainer()
    let background: Background = {
        let background = try! data.context.fetch(FetchDescriptor<Pet>()).first!.background

        let storedDecors = try! data.context
            .fetch(FetchDescriptor<StoredDecor>())
            .filter({ $0.background == background })
            .sorted(by: { $0.decor.name < $1.decor.name })

        storedDecors.forEach {
            data.context.insert(ShownDecor(order: $0.background.shownDecors.count,
                                           storedDecor: $0,
                                           background: $0.background))
        }
        
        return background
    }()
    CanvasView(width: 400 * 0.9, height: 400 * 0.9).modelContainer(data.modelContainer)
}
