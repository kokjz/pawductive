//
//  FoodCatalog.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 20/5/26.
//

import Foundation
import SwiftUI

enum FoodCatalog: String, Codable, CaseIterable {
    case corn = "Corn"
    case pumpkin = "Pumpkin"
    case chickenEgg = "Chicken Egg"
    case chickenWing = "Chicken Wing"
    case chickenDrumstick = "Chicken Drumstick"
    case porkBelly = "Pork Belly"
    
    var cost: Int {
        switch self {
        case .corn:
            return 5
        case .pumpkin:
            return 10
        case .chickenEgg:
            return 15
        case .chickenWing:
            return 20
        case .chickenDrumstick:
            return 30
        case .porkBelly:
            return 50
        }
    }
    
    // Retrieved from: https://2yeet.itch.io/foodassets
    var image: ImageResource {
        switch self {
        case .corn:
            return .corn
        case .pumpkin:
            return .pumpkin
        case .chickenEgg:
            return .chickenEgg
        case .chickenWing:
            return .chickenWing
        case .chickenDrumstick:
            return .chickenDrumstick
        case .porkBelly:
            return .porkBelly
        }
    }
}
