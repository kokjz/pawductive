//
//  ContentView.swift
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
    
    @State private var newTaskTitle: String = ""
    @State private var newTaskDuration: String = "25"
    
    var body: some View {
        VStack(spacing: 0) {
            //wallet balance
            if let profile = profiles.first {
                HStack {
                    Spacer()
                    HStack(spacing: 8) {
                        Image(.coin)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 22, height: 22)
                        
                        Text("\(profile.coins)")
                            .font(.system(.headline, design: .rounded))
                            .bold()
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(Color.orange.opacity(0.1))
                    )
                    .overlay(
                        Capsule()
                            .stroke(Color.orange.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGroupedBackground))
            }
            
            //task input
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    TextField("What's next?", text: $newTaskTitle)
                        .textFieldStyle(.plain)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(Color(.secondarySystemGroupedBackground))
                        .cornerRadius(10)
                    
                    HStack(spacing: 4) {
                        TextField("Mins", text: $newTaskDuration)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .frame(width: 45)
                            .padding(.vertical, 10)
                            .background(Color(.secondarySystemGroupedBackground))
                            .cornerRadius(10)
                        
                        Text("min")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.trailing, 4)
                    }
                }
                
                Button(action: addTask) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Task")
                            .bold()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(newTaskTitle.isEmpty ? Color.gray.opacity(0.5) : Color.orange)
                    .cornerRadius(12)
                }
                .disabled(newTaskTitle.isEmpty)
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            
            Divider()
            
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
                                    
                                    Text("\(task.expectedDurationInMinutes) minutes")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
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
        .navigationTitle("Task Queue")
        .navigationDestination(for: TaskItem.self) { task in
            TimerView(task: task)
        }
    }
    
    private func addTask() {
        guard let duration = Int(newTaskDuration), !newTaskTitle.isEmpty else { return }
        let newTask = TaskItem(title: newTaskTitle, expectedDurationInMinutes: duration)
        modelContext.insert(newTask)
        try? modelContext.save()
        
        newTaskTitle = ""
        newTaskDuration = "25"
    }
    
    private func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tasks[index])
        }
        try? modelContext.save()
    }
}

#Preview {
    NavigationStack {
        TaskQueueView()
    }
    .modelContainer(for: TaskItem.self, inMemory: true)
}
