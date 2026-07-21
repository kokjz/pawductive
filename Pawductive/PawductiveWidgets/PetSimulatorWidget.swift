//
//  PetSimulatorWidget.swift
//  PetSimulatorWidget
//
//  Created by Lee Zi Rong on 18/7/26.
//

import WidgetKit
import SwiftUI
import SwiftData

struct PetSimulatorProvider: @MainActor TimelineProvider {
    @MainActor func placeholder(in context: Context) -> PetSimulatorEntry {
        PetSimulatorEntry(date: Date(), modelContainer: DataContainer().modelContainer)
    }

    @MainActor func getSnapshot(in context: Context, completion: @escaping (PetSimulatorEntry) -> ()) {
        guard let modelContainer = DataContainer.createModelContainer(inMemory: false) else { return }
        let entry = PetSimulatorEntry(date: Date(), modelContainer: modelContainer)
        completion(entry)
    }
    
    // Updates widget every hour
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        guard let modelContainer = DataContainer.createModelContainer(inMemory: false) else { return }
        var entries: [PetSimulatorEntry] = []
        
        let moodDecayModifier = try? modelContainer.mainContext.fetch(
            FetchDescriptor<Modifier>(predicate: #Predicate { $0.label == "pet.mood" })
        ).first
        
        let energyDecayModifier = try? modelContainer.mainContext.fetch(
            FetchDescriptor<Modifier>(predicate: #Predicate { $0.label == "pet.energy" })
        ).first
        
        if let pet = try? modelContainer.mainContext.fetch(FetchDescriptor<Pet>()).first {
            pet.update(
                currDate: Date(),
                moodDecayModifier: moodDecayModifier,
                energyDecayModifier: energyDecayModifier
            )
            try? modelContainer.mainContext.save()
        }
        
        entries.append(PetSimulatorEntry(date: Date(), modelContainer: modelContainer))
        let timeline = Timeline(entries: entries, policy: .after(Date().advanced(by: 3600)))
        completion(timeline)
    }
}

struct PetSimulatorEntry: TimelineEntry {
    let date: Date
    let modelContainer: ModelContainer
}

struct PetSimulatorEntryView: View {
    var entry: PetSimulatorEntry
    
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
    
    @Environment(\.widgetRenderingMode) private var widgetMode

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
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .blendMode(widgetMode == .fullColor ? .normal : .destinationOut)
            }
            .padding(.top, height * 0.05)
            
            // Energy Value Bar
            ZStack {
                ValueBarView(fillRatio: pet.energy / pet.maxEnergy, width: width * 0.8, height: height * 0.1)
                    .foregroundStyle(.green)
                    .opacity(0.9)
                Text("Energy: " + String(format: "%.0f", pet.energy))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .blendMode(widgetMode == .fullColor ? .normal : .destinationOut)
            }
            
            Spacer()

            Image(pet.image)
                .resizable()
                .widgetAccentedRenderingMode(.fullColor)
                .scaledToFit()
                .frame(width: width * 0.25, height: width * 0.25, alignment: .bottom)
                .padding(.bottom)
        }
    }
}

struct PetSimulatorWidget: Widget {
    let kind: String = "PetSimulatorWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: PetSimulatorProvider()) { entry in
            PetSimulatorEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .widgetURL(URL(string: "pawductive://pet"))
                .modelContainer(entry.modelContainer)
        }
        .configurationDisplayName("Pet Simulator")
        .description("Monitor your pet in your home screen")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

#Preview(as: .systemSmall) {
    PetSimulatorWidget()
} timeline: {
    PetSimulatorEntry(date: Date(), modelContainer: DataContainer().modelContainer)
}

