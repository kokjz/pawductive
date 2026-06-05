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
    var name: String
    var details: String
    var level: Int
    var maxLevel: Int
    
    init(name: String, details: String, level: Int, maxLevel: Int) {
        self.name = name
        self.details = details
        self.level = level
        self.maxLevel = maxLevel
    }
}
