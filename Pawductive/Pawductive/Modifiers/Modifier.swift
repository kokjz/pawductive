//
//  Modifier.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 5/6/26.
//

import Foundation
import SwiftData

@Model
class Modifier {
    var label: String
    var name: String
    var details: String
    var level: Int
    var maxLevel: Int
    
    init(label: String, name: String, details: String, level: Int, maxLevel: Int) {
        self.label = label
        self.name = name
        self.details = details
        self.level = level
        self.maxLevel = maxLevel
    }
    
    func levelUp() {
        guard self.level < self.maxLevel else { return }
        self.level += 1
    }
}
