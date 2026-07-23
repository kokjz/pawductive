//
//  TaskQueueView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 17/5/26.
//

import SwiftUI
import SwiftData

struct TaskQueueView: View {
    @Query(sort: \TaskItem.sortOrder) private var tasks: [TaskItem]
    @Query private var profiles: [UserProfile]
    @Query private var categories: [TaskCategory]
    @Environment(\.modelContext) private var modelContext
    @State private var editMode: EditMode = .inactive
    @State private var showTaskCreationSheet: Bool = false
    private var isEditing: Bool { editMode.isEditing }
    
    var body: some View {
        VStack(spacing: 0) {
            //unified header (title + wallet balance)
            HStack(alignment: .center, spacing: 12) {
                Text("Task Queue")
                    .styleAsMainHeader()
                    .foregroundColor(.primary)
                Spacer()
                if let profile = profiles.first {
                    UserCoinsView(profile: profile)
                }
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 12)
            .background(Color(.systemBackground))
            
            //new task button + edit button
            HStack() {
                Button(action: { showTaskCreationSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add New Task")
                            .bold()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.orange)
                    .cornerRadius(12)
                }
                EditButton()
                    .font(.headline)
                    .foregroundColor(tasks.isEmpty ? .gray : .orange)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.secondarySystemGroupedBackground))
                    .cornerRadius(12)
                    .disabled(tasks.isEmpty)
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(Color(.systemBackground))
            
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
                        if isEditing {
                            taskRowView(task: task)
                        } else {
                            NavigationLink(value: task) {
                                taskRowView(task: task)
                            }
                        }
                    }
                    .onDelete(perform: deleteTasks)
                    .onMove(perform: moveTask)
                }
                .listStyle(.insetGrouped)
            }
        }
        .environment(\.editMode, $editMode)
        .navigationDestination(for: TaskItem.self) { task in
            TimerView(task: task)
        }
        .fullScreenCover(isPresented: $showTaskCreationSheet) {
            TaskCreationView()
        }
    }
    
    private func taskRowView(task: TaskItem) -> some View {
        HStack(spacing: 12) {
            //status indicator circle
            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title2)
                .foregroundColor(task.isCompleted ? .green : .orange)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .secondary : .primary)
                Text("\(formatMinutes(task.expectedDurationInMinutes))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            
            //category name + icon
            if (task.categoryName != "") {
                Text(task.categoryName)
                    .font(.caption)
                    .bold()
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.12))
                    .cornerRadius(6)
                    .foregroundColor(.orange)
                Text(getCategoryIcon(for: task.categoryName))
                    .font(.title3)
                    .frame(width: 28, height: 28, alignment: .center)
            }
        }
        .padding(.vertical, 4)
    }

    
    private func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tasks[index])
        }
        try? modelContext.save()
    }
    
    private func moveTask(from offsets: IndexSet, to destination: Int) {
        var updatedTasks = tasks
        updatedTasks.move(fromOffsets: offsets, toOffset: destination)
        for (index, task) in updatedTasks.enumerated() {
            task.sortOrder = index
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
    
    private func getCategoryIcon(for categoryName: String) -> String {
        categories.first(where: { $0.name == categoryName })?.iconName ?? "📁"
    }
}

#Preview {
    NavigationStack {
        TaskQueueView()
    }
    .modelContainer(DataContainer().modelContainer)
}
