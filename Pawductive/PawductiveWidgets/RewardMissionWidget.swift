//
//  RewardMissionWidget.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/7/26.
//

import WidgetKit
import SwiftUI
import SwiftData

struct RewardMissionProvider: @MainActor TimelineProvider {
    @MainActor func placeholder(in context: Context) -> RewardMissionEntry {
        RewardMissionEntry(date: Date(), modelContainer: DataContainer().modelContainer)
    }

    @MainActor func getSnapshot(in context: Context, completion: @escaping (RewardMissionEntry) -> ()) {
        guard let modelContainer = DataContainer.createModelContainer(inMemory: false) else { return }
        let entry = RewardMissionEntry(date: Date(), modelContainer: modelContainer)
        completion(entry)
    }
    
    // Updates widget at the start of each day
    @MainActor func getTimeline(in context: Context, completion: @escaping (Timeline<RewardMissionEntry>) -> ()) {
        guard let modelContainer = DataContainer.createModelContainer(inMemory: false) else { return }
        var entries: [RewardMissionEntry] = []
        entries.append(RewardMissionEntry(date: Date(), modelContainer: modelContainer))
        
        if let dailyReward = try? modelContainer.mainContext.fetch(FetchDescriptor<DailyReward>()).first {
            dailyReward.update()
        }
        if let missionManager = try? modelContainer.mainContext.fetch(FetchDescriptor<MissionManager>()).first {
            missionManager.refreshActiveMissions(missions: DataContainer.dailyMissions)
        }
        
        guard let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date())) else { return }
        let timeline = Timeline(entries: entries, policy: .after(tomorrow))
        completion(timeline)
    }
}

struct RewardMissionEntry: TimelineEntry {
    let date: Date
    let modelContainer: ModelContainer
}

struct RewardMissionEntryView: View {
    var entry: RewardMissionEntry
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("Rewards & Missions")
                .font(.headline)
            DailyRewardView()
            Divider()
            DailyMissionsView()
        }
    }
}

struct RewardMissionWidget: Widget {
    let kind: String = "RewardMissionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: RewardMissionProvider()) { entry in
            RewardMissionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .widgetURL(URL(string: "pawductive://profile"))
                .modelContainer(entry.modelContainer)
        }
        .configurationDisplayName("Rewards & Missions")
        .description("Track daily rewards and missions")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    RewardMissionWidget()
} timeline: {
    RewardMissionEntry(date: Date(), modelContainer: DataContainer().modelContainer)
}

