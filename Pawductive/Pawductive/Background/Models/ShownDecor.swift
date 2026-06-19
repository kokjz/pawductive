//
//  ShownDecor.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftData
import SwiftUI

@Model
class ShownDecor {
    var order: Int
    var relativeX: CGFloat
    var relativeY: CGFloat
    
    @Relationship(inverse: \StoredDecor.shownDecors)
    var storedDecor: StoredDecor
    @Relationship(inverse: \Background.shownDecors)
    var background: Background
    
    init(order: Int, relativeX: CGFloat = 0.5, relativeY: CGFloat = 0.5, storedDecor: StoredDecor, background: Background) {
        self.order = order
        self.relativeX = relativeX
        self.relativeY = relativeY
        self.storedDecor = storedDecor
        self.background = background
    }
}
