//
//  ToyCatalog.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 20/5/26.
//

import Foundation
import SwiftUI

enum ToyCatalog: String, Codable, CaseIterable {
    case treeBranch = "Tree Branch"
    case tennisBall = "Tennis Ball"
    case kitchenTowel = "Kitchen Towel"
    case frisbee = "Frisbee"
    case rubberDuck = "Rubber Duck"

    var cost: Int {
        switch self {
        case .treeBranch:
            return 5
        case .tennisBall:
            return 10
        case .kitchenTowel:
            return 20
        case .frisbee:
            return 40
        case .rubberDuck:
            return 80
        }
    }
    
    // Designed by "Freepik" and "bsd" from "www.flaticon.com"
    var image: ImageResource {
        switch self {
        case .treeBranch:
            return .treeBranch
        case .tennisBall:
            return .tennisBall
        case .kitchenTowel:
            return .kitchenTowel
        case .frisbee:
            return .frisbee
        case .rubberDuck:
            return .rubberDuck
        }
    }
}
