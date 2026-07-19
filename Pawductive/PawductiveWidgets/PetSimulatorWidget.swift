//
//  PetSimulatorWidget.swift
//  PetSimulatorWidget
//
//  Created by Lee Zi Rong on 18/7/26.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: @MainActor TimelineProvider {
    func placeholder(in context: Context) -> PetSimulatorEntry {
        PetSimulatorEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (PetSimulatorEntry) -> ()) {
        let entry = PetSimulatorEntry(date: Date())
        completion(entry)
    }
    
    // Updates widget every hour
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [PetSimulatorEntry] = []
        
        let moodDecayModifier = try? DataContainer.sharedContext.fetch(
            FetchDescriptor<Modifier>(predicate: #Predicate { $0.label == "pet.mood" })
        ).first
        
        let energyDecayModifier = try? DataContainer.sharedContext.fetch(
            FetchDescriptor<Modifier>(predicate: #Predicate { $0.label == "pet.energy" })
        ).first
        
        if let pet = try? DataContainer.sharedContext.fetch(FetchDescriptor<Pet>()).first {
            pet.update(
                currDate: Date(),
                moodDecayModifier: moodDecayModifier,
                energyDecayModifier: energyDecayModifier
            )
            try? DataContainer.sharedContext.save()
        }
        
        entries.append(PetSimulatorEntry(date: Date()))
        let timeline = Timeline(entries: entries, policy: .after(Date().advanced(by: 3600)))
        completion(timeline)
    }
}

struct PetSimulatorEntry: TimelineEntry {
    let date: Date
}

struct PetSimulatorEntryView: View {
    var entry: Provider.Entry
    
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

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    CanvasView(width: geometry.size.width, height: geometry.size.height)
                        .allowsHitTesting(false)
                    foreground(width: geometry.size.width, height: geometry.size.height)
                }
            }
        }
    }
    
    func foreground(width: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: height * 0.03) {
            // Mood Value Bar
            ZStack {
                ValueBarView(fillRatio: pet.mood / pet.maxMood, width: width * 0.8, height: height * 0.1)
                    .foregroundStyle(.yellow)
                    .opacity(0.9)
                Text("Mood: " + pet.moodDescription)
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            .padding(.top, height * 0.05)
            
            // Energy Value Bar
            ZStack {
                ValueBarView(fillRatio: pet.energy / pet.maxEnergy, width: width * 0.8, height: height * 0.1)
                    .foregroundStyle(.green)
                    .opacity(0.9)
                Text("Energy: " + String(format: "%.0f", pet.energy))
                    .font(.caption)
                    .foregroundStyle(.white)
            }
            
            Spacer()

            Image(pet.image)
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.25, height: width * 0.25, alignment: .bottom)
                .padding(.bottom)
        }
    }
}

struct PetSimulatorWidget: Widget {
    let kind: String = "PetSimulatorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PetSimulatorEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(DataContainer.sharedContainer)
//                // FOR TESTING ONLY
//                .modelContainer(
//                    DataContainer(loadDecorations: true, inMemory: true).modelContainer
//                )
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    PetSimulatorWidget()
} timeline: {
    PetSimulatorEntry(date: Date())
}

