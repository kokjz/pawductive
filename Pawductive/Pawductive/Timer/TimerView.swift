//
//  TimerView.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 21/5/26.
//

import SwiftUI
import SwiftData

struct TimerView: View {
    let task: TaskItem
    
    @State private var viewModel = TimerViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        VStack(spacing: 40) {
            VStack(spacing: 8) {
                Text(task.title)
                    .styleAsSubHeader()
                Text("Focus Period")
                    .foregroundColor(.secondary)
            }
            
            //circular progress timer visual
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.15), lineWidth: 20)
                    .frame(width: 250, height: 250)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(viewModel.timeRemaining) / CGFloat(max(1, viewModel.totalDuration)))
                    .stroke(
                        Color.orange,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round)
                    )
                    .rotationEffect(Angle(degrees: -90))
                    .frame(width: 250, height: 250)
                    .animation(viewModel.timeRemaining == viewModel.totalDuration ? nil : .linear(duration: 1.0), value: viewModel.timeRemaining)
                
                Text(formatTime(viewModel.timeRemaining))
                    .font(.system(size: 52, weight: .bold, design: .rounded))
            }
            
            //control buttons
            if viewModel.isRunning {
                Button(action: {
                    viewModel.failSession()
                    dismiss()
                }) {
                    Text("Give Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 40)
            } else if viewModel.isCompleted {
                VStack(spacing: 20) {
                    Text("Task Completed!")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.green)
                    
                    Button("Claim Rewards & Return") {
                        task.isCompleted = true
                        //run coin reward calc and save to database
                        viewModel.claimRewards(context: modelContext)
                        try? modelContext.save()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                }
            }
        }
        .padding()
        .onAppear {
            viewModel.startTimer(minutes: task.expectedDurationInMinutes)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        
        //detect if user exits app
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .background && viewModel.isRunning {
                viewModel.failSession()
                dismiss() //back to task queue
            }
        }
    }
    
    //time formatting helper
    private func formatTime(_ seconds: Int) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    TimerView(task: TaskItem(title: "Preview Task", expectedDurationInMinutes: 25))
}
