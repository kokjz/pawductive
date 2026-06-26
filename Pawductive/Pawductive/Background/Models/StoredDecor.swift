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

    @Relationship(deleteRule: .cascade)
    var shownDecors = [ShownDecor]()
    @Relationship(inverse: \Background.storedDecors)
    var background: Background
    
    init(decor: Decor, numStored: Int = 0, background: Background) {
        self.decor = decor
        self.numStored = numStored
        self.background = background
    }
    
    func hasStored() -> Bool {
        return self.numStored > 0
    }
    
    func display(context: ModelContext) {
        guard self.hasStored() else { return }
        self.numStored -= 1
        context.insert(
            ShownDecor(
                order: self.background.shownDecors.count,
                storedDecor: self,
                background: self.background
            )
        )
        try? context.save()
    }
}
