//
//  Item.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 17/5/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
