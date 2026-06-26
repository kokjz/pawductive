//
//  Background.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftData

@Model
class Background {
    var name: String
    var imageName: String
    
    @Relationship(deleteRule: .cascade)
    var shownDecors = [ShownDecor]()
    @Relationship(deleteRule: .cascade)
    var storedDecors = [StoredDecor]()
    
    init(name: String, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
    
    func sendToFront(shownDecor: ShownDecor) {
        for decor in self.shownDecors {
            if decor.order > shownDecor.order {
                decor.order -= 1
            }
        }
        shownDecor.order = self.shownDecors.count - 1
    }
}
