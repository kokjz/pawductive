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
    var relativeX: CGFloat
    var relativeY: CGFloat
    
    @Relationship(inverse: \StoredDecor.shownDecors)
    var storedDecor: StoredDecor
    
    init(relativeX: CGFloat = 0.5, relativeY: CGFloat = 0.5, storedDecor: StoredDecor) {
        self.relativeX = relativeX
        self.relativeY = relativeY
        self.storedDecor = storedDecor
    }
}
