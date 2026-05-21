//
//  ContentView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 17/5/26.
//

import SwiftUI
import SwiftData

struct TaskQueueView: View {
    @Query private var profiles: [UserProfile]
    @Query(sort: \TaskItem.creationDate, order: .reverse) private var tasks: [TaskItem]
    @Environment(\.modelContext) private var modelContext
    
    @State private var newTaskTitle: String = ""
    @State private var newTaskDuration: String = "30"
    
    var body: some View {
        VStack {
            //coin display
            if let profile = profiles.first {
                HStack {
                    Text("🪙 \(profile.coins) Coins")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.orange)
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            //input section
            HStack {
                TextField("What's next?", text: $newTaskTitle)
                    .textFieldStyle(.roundedBorder)
                
                TextField("Mins", text: $newTaskDuration)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 65)
                    .keyboardType(.numberPad)
                
                Button(action: addTask) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.orange)
                }
                .disabled(newTaskTitle.isEmpty)
            }
            .padding()
            
            //taskqueue
            if tasks.isEmpty {
                ContentUnavailableView(
                    "No Tasks",
                    systemImage: "checklist",
                    description: Text("Add a task")
                )
            } else {
                List {
                    ForEach(tasks) { task in
                        NavigationLink(value: task) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(task.title)
                                        .font(.headline)
                                    Text("\(task.expectedDurationInMinutes) mins")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if task.isCompleted {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteTasks)
                }
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
        newTaskDuration = "30"
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
