//
//  CategoryManagerView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 22/7/26.
//

import SwiftUI
import SwiftData

struct CategoryManagerView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskCategory.name) private var categories: [TaskCategory]
    
    @State private var showEmojiPicker: Bool = false
    @State private var newCategoryName: String = ""
    @State private var newCategoryIcon: String = "📁"
    
    //preset emojis
    private let presetEmojis: [String] = [
        "📁", "💻", "📚", "🎨", "🎮", "🏋️‍♂️", "💼",
        "🍔", "🎵", "✈️", "⭐", "🔥", "🐶", "🌱", "☕️",
        "🛠️", "💡", "📝", "🎯", "🏆"
    ]
    
    var body: some View {
        Form {
            Section(header: Text("Add New Category")) {
                HStack(spacing: 12) {
                    //icon picker clickable box
                    Button(action: { showEmojiPicker = true }) {
                        Text(newCategoryIcon)
                            .font(.title2)
                            .frame(width: 44, height: 44)
                            .background(Color(.tertiarySystemGroupedBackground))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    
                    //category name input box
                    TextField("Category Name", text: $newCategoryName)
                        .textFieldStyle(.roundedBorder)
                }
                
                Button(action: addCategory) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle.fill")
                        Text("Add Category")
                            .bold()
                        Spacer()
                    }
                }
                .disabled(newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            
            //existing categories list
            Section(header: Text("Existing Categories"), footer: Text("Swipe left on a category to delete it.")) {
                if categories.isEmpty {
                    Text("No categories found.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(categories) { category in
                        HStack(spacing: 12) {
                            Group {
                                if UIImage(systemName: category.iconName) != nil {
                                    Image(systemName: category.iconName)
                                        .foregroundColor(.orange)
                                } else {
                                    Text(category.iconName)
                                }
                            }
                            .font(.title3)
                            .frame(width: 28, height: 28, alignment: .center)
                            
                            Text(category.name)
                                .font(.headline)
                            
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                    .onDelete(perform: deleteCategory)
                }
            }
        }
        .navigationTitle("Manage Categories")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .sheet(isPresented: $showEmojiPicker) {
            EmojiPickerSheet(
                selectedEmoji: $newCategoryIcon,
                emojis: presetEmojis
            )
            .presentationDetents([.height(420)])
        }
    }
    
    private func addCategory() {
        let trimmedName = newCategoryName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        let category = TaskCategory(name: trimmedName, iconName: newCategoryIcon)
        modelContext.insert(category)
        try? modelContext.save()
        
        newCategoryName = ""
        newCategoryIcon = "📁"
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    private func deleteCategory(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(categories[index])
        }
        try? modelContext.save()
    }
}

//emoji picker
struct EmojiPickerSheet: View {
    @Binding var selectedEmoji: String
    let emojis: [String]
    @Environment(\.dismiss) private var dismiss
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 5)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(emojis, id: \.self) { emoji in
                        Text(emoji)
                            .font(.largeTitle)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(selectedEmoji == emoji ? Color.orange.opacity(0.2) : Color.clear)
                            )
                            .onTapGesture {
                                selectedEmoji = emoji
                                dismiss()
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Choose Icon")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryManagerView()
    }
    .modelContainer(DataContainer(inMemory: true).modelContainer)
}
