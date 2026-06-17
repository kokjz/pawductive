//
//  StoredDecor.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 17/6/26.
//

import SwiftData
import SwiftUI

@Model
class StoredDecor {
    var decor: Decor
    var numStored: Int
    
    @Relationship(inverse: \Background.storedDecors)
    var background: Background
    @Relationship var shownDecors = [ShownDecor]()
    
    init(decor: Decor, numStored: Int = 0, background: Background) {
        self.decor = decor
        self.numStored = numStored
        self.background = background
    }
}
