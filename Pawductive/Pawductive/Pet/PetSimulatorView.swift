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
    
    @State private var showModifiers = false
    @State private var animatePet = false
    
    var body: some View {
        VStack {
            @Bindable var pet = pet
            TextField("\(pet.name)", text: $pet.name)
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .multilineTextAlignment(.center)
                
            Text("Age: \(pet.ageInDays) days")
                .styleAsSubHeader()
            
            Image(pet.image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 300, maxHeight: 300)
                .animation(.default, value: pet.state)
                .onTapGesture { animatePet.toggle() }
                .phaseAnimator([0, 1, -1, 0], trigger: animatePet)
                { content, phase in
                    content.rotationEffect(.degrees(phase * 5))
                } animation: { phase in
                    Animation.easeInOut(duration: 0.3)
                }

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
            
            ZStack {
                ValueBarView(fillRatio: pet.currentProgress)
                    .foregroundStyle(.blue)
                Text("\(pet.level == pet.maxLevel ? "MAX LEVEL" : "Level \(pet.level) (\(pet.currentExperiencePoints) / \(pet.experiencePointsPerLevel) XP)")")
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
            
            Button("Open Modifiers") {
                showModifiers = true
            }
            .buttonStyle(.borderedProminent)
            .navigationDestination(isPresented: $showModifiers) {
                ModifiersView()
            }
            
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
    NavigationStack {
        PetSimulatorView()
    }
    .modelContainer(DataContainer(
        pet: Pet(mood: 0, energy: 0)
    ).modelContainer)
}
