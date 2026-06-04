//
//  PetSimulatorView.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 22/5/26.
//

import SwiftData
import SwiftUI

struct PetSimulatorView: View {    
    @Query private var pets: [Pet]
    private var pet: Pet {
        pets.first!
    }
    
    @State private var category: ShopCategory = .food
    
    var currDate: Date {
        Date.now
    }
    
//    // NOTE: FOR TESTING ONLY
//    @State private var numberOfTaps = 0
//    var currDate: Date {
//        Calendar.current.date(byAdding: .day, value: numberOfTaps, to: Date.now)!
//    }
    
    var body: some View {
        VStack {
            @Bindable var pet = pet
            TextField("\(pet.name)", text: $pet.name)
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                
            Text("Age: \(pet.ageInDays) Days")
                .styleAsSubHeader()
            
            Image(pet.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 300)

//                // NOTE: FOR TESTING ONLY
//                .onTapGesture {
//                    numberOfTaps += 1
//                }
            
            ZStack {
                ValueBarView(fillRatio: pet.mood / pet.maxMood)
                    .foregroundStyle(.yellow)
                Text("Mood: " + pet.moodDescription)
                    .font(.headline)
                    .foregroundStyle(.white)
            }

            ZStack {
                ValueBarView(fillRatio: pet.energy / pet.maxEnergy)
                    .foregroundStyle(.green)
                Text("Energy: " + String(format: "%.0f", pet.energy))
                    .font(.headline)
                    .foregroundStyle(.white)
            }
        
            Picker("Category", selection: $category) {
                ForEach(ShopCategory.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: category) {
                withAnimation {
                    pet.update(currDate: currDate)
                }
            }
            category.listView(currDate: currDate)
            
            Spacer()
        }
        .onAppear{
            withAnimation {
                pet.update(currDate: currDate)
            }
        }
        .padding()
    }
}

#Preview {
    PetSimulatorView()
        .modelContainer(DataContainer().modelContainer)
}
