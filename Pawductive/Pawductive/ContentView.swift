//
//  ContentView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        NavigationStack {
            TaskQueueView()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: TaskItem.self, inMemory: true)
}
