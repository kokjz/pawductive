//
//  ValueBarView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 23/5/26.
//

import SwiftUI

struct ValueBarView: View {
    var fillRatio: CGFloat
    var width: CGFloat = 200
    var height: CGFloat = 20
    
    var ratio: CGFloat {
        return min(max(fillRatio, 0), 1)
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: height)
                .fill(Color.gray.opacity(0.3))
            RoundedRectangle(cornerRadius: height)
                .offset(x: (ratio - 1) * width)
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: height))
    }
}

#Preview {
    ValueBarView(fillRatio: 0.20)
}
