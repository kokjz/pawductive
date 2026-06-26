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
    
    @Query private var modifiers: [Modifier]
    private var moodDecayModifier: Modifier? {
        modifiers.first(where: { $0.label == "pet.mood" })
    }
    private var energyDecayModifier: Modifier? {
        modifiers.first(where: { $0.label == "pet.energy" })
    }
    
    @State private var category: ShopCategory = .food
    @State private var animatePet = false
    @State private var showModifiers = false
    @State private var showBackgroundEditor = false
    
    var currDate: Date {
        Date.now
    }
    
//    // NOTE: FOR TESTING ONLY
//    @State private var numberOfTaps = 0
//    var currDate: Date {
//        Calendar.current.date(byAdding: .day, value: numberOfTaps, to: Date.now)!
//    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                @Bindable var pet = pet
                TextField("\(pet.name)", text: $pet.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .textInputAutocapitalization(.characters)
                
                HStack {
                    Button {
                        showModifiers = true
                    } label: {
                        Text("Open Modifiers")
                            .lineLimit(1)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .frame(width: geometry.size.width * 0.35)
                    }
                    .navigationDestination(isPresented: $showModifiers) {
                        ModifiersView()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        showBackgroundEditor = true
                    } label: {
                        Text("Edit Background")
                            .lineLimit(1)
                            .fontWeight(.semibold)
                            .fontDesign(.rounded)
                            .frame(width: geometry.size.width * 0.35)
                    }
                    .navigationDestination(isPresented: $showBackgroundEditor) {
                        BackgroundView()
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                ZStack(alignment: .bottom) {
                    CanvasView(width: geometry.size.width * 0.8, height: geometry.size.width * 0.8)
                        .allowsHitTesting(false)
                    Image(pet.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.25, height: geometry.size.width * 0.25, alignment: .bottom)
                        .padding(.bottom)
                        .animation(.default, value: pet.state)
                        .phaseAnimator([0, 1, -1, 0], trigger: animatePet)
                        { content, phase in
                            content.rotationEffect(.degrees(phase * 5))
                        } animation: { phase in
                            Animation.easeInOut(duration: 0.3)
                        }
                        .onTapGesture { animatePet.toggle() }
//                        // NOTE: FOR TESTING ONLY
//                        .onTapGesture {
//                            numberOfTaps += 1
//                        }
                }
                
                ZStack {
                    ValueBarView(fillRatio: pet.currentProgress, width: geometry.size.width * 0.80 + 10)
                        .foregroundStyle(.blue)
                    Text("\(pet.level == pet.maxLevel ? "MAX LEVEL" : "Level \(pet.level) (\(pet.currentExperiencePoints) / \(pet.experiencePointsPerLevel) XP)")")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                
                HStack(spacing: 10) {
                    ZStack {
                        ValueBarView(fillRatio: pet.mood / pet.maxMood, width: geometry.size.width * 0.4)
                            .foregroundStyle(.yellow)
                        Text("Mood: " + pet.moodDescription)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    
                    ZStack {
                        ValueBarView(fillRatio: pet.energy / pet.maxEnergy, width: geometry.size.width * 0.4)
                            .foregroundStyle(.green)
                        Text("Energy: " + String(format: "%.0f", pet.energy))
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }
            
                Picker("Category", selection: $category) {
                    ForEach(ShopCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: category) {
                    withAnimation {
                        pet.update(currDate: currDate, moodDecayModifier: moodDecayModifier, energyDecayModifier: energyDecayModifier)
                    }
                }
                .frame(width: geometry.size.width * 0.8 + 10)
                
                category.listView(currDate: currDate)
                    .frame(width: geometry.size.width * 0.8 + 10)
            }
            .onAppear{
                withAnimation {
                    pet.update(currDate: currDate, moodDecayModifier: moodDecayModifier, energyDecayModifier: energyDecayModifier)
                }
            }
            .padding()
            .frame(maxWidth: geometry.size.width, maxHeight: geometry.size.height, alignment: .center)
        }
        .tint(.orange)
    }
}

#Preview {
    NavigationStack {
        PetSimulatorView()
    }
    .modelContainer(DataContainer(mood: 150, energy: 150, experiencePoints: 15000).modelContainer)
}
