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
    var relativePosition: CGPoint
    
    @Relationship var storedDecor: StoredDecor
    
    init(relativePosition: CGPoint, storedDecor: StoredDecor) {
        self.relativePosition = relativePosition
        self.storedDecor = storedDecor
    }
}
