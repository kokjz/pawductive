//
//  SettingsManagerView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 23/6/26.
//

import SwiftUI

struct SettingsManagerView: View {
    @Bindable private var settings = SettingsManager.shared
    
    var body: some View {
        VStack(spacing: 24) {
            //header
            HStack {
                Text("Settings").styleAsMainHeader()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            //settings list
            List {
                
            }
        }
    }
}

#Preview {
    SettingsManagerView()
}
