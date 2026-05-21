//
//  UserProfile.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

//THIS VERSION OF USERPROFILE IS A STUB. PLEASE ENHANCE DIRECTLY FROM HERE

import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var coins: Int
    
    init(coins: Int = 100) {
        self.id = UUID()
        self.coins = coins
    }
}
