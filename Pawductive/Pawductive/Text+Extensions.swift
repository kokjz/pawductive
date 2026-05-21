//
//  Text+Extensions.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 22/5/26.
//

import SwiftUI

extension Text {
    
    //main screen titles style
    func styleAsMainHeader() -> some View {
        self
            .font(.largeTitle)
            .fontWeight(.semibold)
            .fontDesign(.rounded)
    }
    
    //smaller headers or section titles style
    func styleAsSubHeader() -> some View {
        self
            .font(.title2)
            .fontWeight(.medium)
            .fontDesign(.rounded)
    }
}
