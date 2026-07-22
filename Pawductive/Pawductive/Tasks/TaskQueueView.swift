//
//  TaskQueueView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 17/5/26.
//

import SwiftUI
import SwiftData

struct TaskQueueView: View {
    @Query(sort: \TaskItem.creationDate, order: .reverse) private var tasks: [TaskItem]
    @Query private var profiles: [UserProfile]
    @Environment(\.modelContext) private var modelContext
    
    @State private var showTaskCreationSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            //unified header (title + wallet balance + task creation button)
            HStack(alignment: .center, spacing: 12) {
                Text("Task Queue")
                    .styleAsMainHeader()
                    .foregroundColor(.primary)
                Spacer()
                Button(action: { showTaskCreationSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                }
                if let profile = profiles.first {
                    UserCoinsView(profile: profile)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 12)
            .background(Color(.systemGroupedBackground))
            
            //task list
            if tasks.isEmpty {
                ContentUnavailableView(
                    "Your Queue is Empty",
                    systemImage: "checklist",
                    description: Text("Add a new task above to start being Pawductive!")
                )
                .background(Color(.systemBackground))
            } else {
                List {
                    ForEach(tasks) { task in
                        NavigationLink(value: task) {
                            HStack(spacing: 15) {
                                //status indicator circle
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .font(.title2)
                                    .foregroundColor(task.isCompleted ? .green : .orange)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(task.title)
                                        .font(.headline)
                                        .strikethrough(task.isCompleted)
                                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                                    //task category + duration
                                    HStack(spacing: 6) {
                                        Text(task.categoryName)
                                            .font(.caption)
                                            .bold()
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 2)
                                            .background(Color.orange.opacity(0.12))
                                            .cornerRadius(6)
                                            .foregroundColor(.orange)
                                        Text("• \(formatMinutes(task.expectedDurationInMinutes))")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
                .listStyle(.insetGrouped)
            }
        }
        .navigationDestination(for: TaskItem.self) { task in
            TimerView(task: task)
        }
        .sheet(isPresented: $showTaskCreationSheet) { TaskCreationView() }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tasks[index])
        }
        try? modelContext.save()
    }
    
    private func formatMinutes(_ totalMinutes: Int) -> String {
        let hours = totalMinutes / 60
        let mins = totalMinutes % 60
        
        if hours > 0 {
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        } else {
            return "\(mins)m"
        }
    }
}

#Preview {
    NavigationStack {
        TaskQueueView()
    }
    .modelContainer(DataContainer().modelContainer)
}
