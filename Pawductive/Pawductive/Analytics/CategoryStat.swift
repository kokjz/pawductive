//
//  CategoryStat.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 24/7/26.
//

import Foundation

struct CategoryStat: Identifiable {
    let id = UUID()
    let categoryName: String
    let minutesFocused: Int
    let iconName: String
}
