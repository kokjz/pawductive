# Pawductive 🐾
> Gamifying productivity, one pet at a time.
> []
> []

A native iOS productivity application developed in Swift.
Built for **Orbital 26** by **No Animals Were Harmed (Team 6658)**.



## 🚀 Milestone 1: Technical Proof of Concept


Successfully implemented:
* Core task queue and timer logic
* Local database persistence layer
* Anti-cheat backgrounding detection


---


## 🛠️ Core Features (Implemented)


### 1. Task Queue (Feature 1)
The task queue allows users to plan and manage their work blocks before beginning focus sessions.
*   **Persistent Storage:** Built using **SwiftData**. Queued tasks are saved to the device's local database and survive app restarts.
*   **Intuitive UI:** Built using **SwiftUI**, with smooth animation, keyboard-type protection for duration inputs, and swipe-to-delete functionality.
*   **Visual Completion Feedback:** Completed tasks are persistently marked with a green checkmark upon claiming rewards.


### 2. Productivity Timer (Feature 2)
The timer forces users to put their phones down and focus on the task at hand without exiting or being distracted.
*   **MVVM State Engine:** Controlled by a responsive `TimerViewModel` using Swift's modern `@Observable` macro.
*   **Interactive Progress Ring:** A clean circular progress ring that animates smoothly on a second-by-second basis.
*   **Anti-Cheat "Stick" Logic:** Utilizing SwiftUI’s `@Environment(\.scenePhase)`, the app instantly detects if the user exits the app or locks their screen. If they leave, the timer is invalidated, the session is failed, and they are immediately booted back to the task queue with no rewards.


---


## 🏗️ Software Engineering Practices & Architecture


### 1. Model-View-ViewModel (MVVM)
The UI is decoupled from the business logic to ensure a testable and maintainable codebase:
*   **Views:** `ContentView.swift`, `TaskQueueView.swift`, and `TimerView.swift` handle pure UI layouts and transitions.
*   **ViewModels:** `TimerViewModel.swift` manages the state-driven properties (`timeRemaining`, `isRunning`), completely independent of SwiftUI.


### 2. SwiftData Schema & Local Persistence
Clean database schema to manage user data locally:
*   `TaskItem`: Tracks task titles, expected durations, completion states, and creation dates.
*   `UserProfile` (Currently stub): Tracks the user's persistent coin balance.
*   **Explicit Saving:** To prevent data loss when developers force-kill the app during Xcode simulation, explicit context saving (`try? modelContext.save()`) on database transactions is implemented.


### 3. Continuous Integration & Unit Testing
Implements the modern **Swift Testing** framework to write test suites verifying the core logic:
*   Tests the initial VM state, successful countdown transitions, and failed backgrounding state resets.
*   Tests can be run locally using **Cmd + U** within Xcode.


---


## 💻 Tech Stack
*   **IDE:** Xcode
*   **Language:** Swift
*   **UI Framework:** SwiftUI
*   **Database:** SwiftData
*   **Testing:** Swift Testing (Unit) / XCTest (UI)