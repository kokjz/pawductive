//
//  UserCoinsView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 22/5/26.
//

import SwiftUI

struct UserCoinsView: View {
    var profile: UserProfile
    
    var body: some View {
        HStack(spacing: 8) {
            Image(.coin)
                .resizable()
                .scaledToFit()
                .frame(width: 22, height: 22)
            
            Text("\(profile.coins)")
                .font(.system(.headline, design: .rounded))
                .bold()
                .foregroundColor(.orange)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(Color.orange.opacity(0.1))
        )
        .overlay(
            Capsule()
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    UserCoinsView(profile: UserProfile())
}
