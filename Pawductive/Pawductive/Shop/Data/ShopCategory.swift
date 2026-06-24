//
//  ShopCategory.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

import SwiftUI

enum ShopCategory: String, CaseIterable {
    case food = "Food"
    case toy = "Toy"
    
    @ViewBuilder
    var shopView: some View {
        switch self {
        case .food:
            FoodShopView()
        case .toy:
            ToyShopView()
        }
    }
    
    @ViewBuilder
    func listView(currDate: Date) -> some View {
        switch self {
        case .food:
            FoodStoreView(currDate: currDate)
        case .toy:
            ToyStoreView(currDate: currDate)
        }
    }
}
