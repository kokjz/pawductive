//
//  ShopView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

import SwiftUI
import SwiftData

struct ShopView: View {
    @Query private var users: [UserProfile]
    
    private var user: UserProfile {
        users.first!
    }
    
    @State private var category: ShopCategory = .food
    
    var body: some View {
        VStack {
            HStack {
                Text("Shop")
                    .styleAsMainHeader()
                Spacer()
                UserCoinsView(profile: user)
            }
            
            Picker("Category", selection: $category) {
                ForEach(ShopCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.segmented)
            
            category.shopView
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ShopView()
        .modelContainer(DataContainer().modelContainer)
}
