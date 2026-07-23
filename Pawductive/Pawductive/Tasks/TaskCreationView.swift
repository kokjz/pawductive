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
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 30
    @State private var selectedCategoryName: String = "General"
    
    private var totalDurationInMinutes: Int {
        (selectedHours * 60) + selectedMinutes
    }
    
    var body: some View {
        NavigationStack {
            Form {
                //task title input
                Section(header: Text("Task Name")) {
                    TextField("What's next?", text: $title)
                        .font(.headline)
                        .padding(.vertical, 4)
                }
                
                //task duration wheel picker
                Section(header: Text("Duration")) {
                    HStack {
                        Spacer()
                        
                        //hrs
                        HStack(spacing: 0) {
                            Picker("Hours", selection: $selectedHours) {
                                ForEach(0...23, id: \.self) { hour in
                                    Text("\(hour)").tag(hour)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 70)
                            
                            Text("hours")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        //mins
                        HStack(spacing: 0) {
                            Picker("Minutes", selection: $selectedMinutes) {
                                ForEach(0...59, id: \.self) { minute in
                                    Text("\(minute)").tag(minute)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 70)
                            
                            Text("min")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .frame(height: 200)
                }
                
                //category picker
                Section(
                    header: Text("Category"),
                    footer: Text("You may create new categories or edit existing categories from the app settings.")
                ) {
                    if categories.isEmpty {
                        Text("Loading categories...")
                            .foregroundColor(.secondary)
                    } else {
                        Picker("Select Category", selection: $selectedCategoryName) {
                            ForEach(categories) { category in
                                HStack(spacing: 12) {
                                    Text(category.iconName)
                                        .font(.title3)
                                        .frame(width: 28, height: 28, alignment: .center)
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
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || totalDurationInMinutes == 0)
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
            expectedDurationInMinutes: totalDurationInMinutes,
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
