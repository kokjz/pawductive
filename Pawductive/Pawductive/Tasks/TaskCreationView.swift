//
//  TaskCreationView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 22/7/26.
//

import SwiftUI
import SwiftData

struct TaskCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @Query(sort: \TaskCategory.name) private var categories: [TaskCategory]
    
    @State private var title: String = ""
    @State private var durationInMinutes: Int = 25
    @State private var selectedCategoryName: String = "General"
    
    var body: some View {
        NavigationStack {
            Form {
                //task title input
                Section(header: Text("Task Details")) {
                    TextField("What do you need to focus on?", text: $title)
                        .font(.headline)
                        .padding(.vertical, 4)
                }
                
                //task duration stepper
                Section(header: Text("Duration")) {
                    Stepper(value: $durationInMinutes, in: 1...120, step: 5) {
                        HStack {
                            Image(systemName: "clock.fill")
                                .foregroundColor(.orange)
                            Text("\(durationInMinutes) minutes")
                                .font(.headline)
                        }
                    }
                }
                
                //category picker
                Section(header: Text("Category")) {
                    if categories.isEmpty {
                        Text("Loading categories...")
                            .foregroundColor(.secondary)
                    } else {
                        Picker("Select Category", selection: $selectedCategoryName) {
                            ForEach(categories) { category in
                                HStack {
                                    Image(systemName: category.iconName)
                                    Text(category.name)
                                }
                                .tag(category.name)
                            }
                        }
                        .pickerStyle(.navigationLink)
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        saveTask()
                    }
                    .bold()
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .onAppear {
                if selectedCategoryName == "General" && !categories.isEmpty {
                    selectedCategoryName = categories.first(where: { $0.name == "General" })?.name ?? categories.first!.name
                }
            }
        }
    }
    
    private func saveTask() {
        let newTask = TaskItem(
            title: title.trimmingCharacters(in: .whitespaces),
            expectedDurationInMinutes: durationInMinutes,
            categoryName: selectedCategoryName
        )
        modelContext.insert(newTask)
        try? modelContext.save()
        dismiss()
    }
}

#Preview {
    TaskCreationView()
        .modelContainer(DataContainer(inMemory: true).modelContainer)
}
