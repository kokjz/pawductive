//
//  ProfileView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 15/6/26.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
    //fetch stats from db
    @Query private var statsList: [UserStats]
    
    var body: some View {
        VStack(spacing: 24) {
            //header
            HStack {
                Text("User Profile")
                    .styleAsMainHeader()
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            if let stats = statsList.first {
                //stats dashboard
                VStack(alignment: .leading, spacing: 12) {
                    Text("Statistics")
                        .styleAsSubHeader()
                        .padding(.horizontal)
                    HStack(spacing: 16) {
                        //statcards
                    }
                    .padding(.horizontal)
                }
                
                //achievement list
                VStack(alignment: .leading, spacing: 12) {
                    //achievements
                }
            } else { //database empty
                ContentUnavailableView("No Stats Available", systemImage: "person.crop.circle.badge.exclamationmark")
            }
            Spacer()
        }
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    ProfileView()
        .modelContainer(DataContainer().modelContainer)
}
