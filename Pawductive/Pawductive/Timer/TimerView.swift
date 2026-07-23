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
    @State private var settingsManager = SettingsManager.shared
    @State private var backgroundTime: Date? = nil
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
                HStack(spacing: 16) {
                    if settingsManager.isTimerPauseEnabled {
                        //if pause toggle enabled have both pause and giveup buttons
                        Button(action: {
                            viewModel.failSession()
                            dismiss()
                        }) {
                            Text("Give Up")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.9))
                                .cornerRadius(12)
                        }
                        Button(action: {
                            if viewModel.isPaused {
                                viewModel.resumeTimer()
                            } else {
                                viewModel.pauseTimer()
                            }
                        }) {
                            Text(viewModel.isPaused ? "Resume" : "Pause")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(viewModel.isPaused ? Color.green : Color.yellow)
                                .cornerRadius(12)
                        }
                    } else {
                        //if pause toggle disabled only give up button
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
                    }
                }
                .padding(.horizontal, 50)
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
        
        .onChange(of: scenePhase) { oldValue, newValue in
            if newValue == .background {
                //user exit app
                if viewModel.isRunning && !viewModel.isPaused {
                    //no explicit pause
                    viewModel.pauseTimer()
                    backgroundTime = Date()
                }
            } else if newValue == .active {
                //user return to app
                if let leaveTime = backgroundTime {
                    let elapsed = Date().timeIntervalSince(leaveTime)
                    backgroundTime = nil
                    if elapsed > Double(settingsManager.gracePeriodSeconds) {
                        //grace period exceeded
                        viewModel.failSession()
                        dismiss()
                    } else {
                        //within grace period
                        viewModel.resumeTimer()
                    }
                }
            }
        }
    }
    
    //time formatting helper
    private func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let mins = (seconds % 3600) / 60
        let secs = seconds % 60
        if (hours == 0) {
            return String(format: "%02d:%02d", mins, secs)
        } else {
            return String(format: "%02d:%02d:%02d", hours, mins, secs)
        }
    }
}

#Preview {
    TimerView(task: TaskItem(title: "Preview Task", expectedDurationInMinutes: 25))
}
