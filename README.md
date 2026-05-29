## Pawductive 🐾
> Gamifying productivity, one pet at a time.

A native iOS productivity application developed in Swift.

Built for Orbital 26 by No Animals Were Harmed **(Team 6658).**

**Targeted Level of Achievement: Gemini**


---


## Motivation

In a digital era where productivity is highly valued, we wanted to make something convenient where users can reliably achieve their productivity goals while being able to enjoy the process - so we turned to the idea of using virtual pets as free dopamine hits. 

Pets are widely loved yet expensive in real life, so we thought of creating a gamified mobile application where users can have fun raising and training virtual pets by responsibly setting their own fixed tasks, adhering to doing them without other distractions, and completing them for in-game rewards. 


---


## 🚀 Milestone 1 Summary: Technical Proof of Concept


Successfully implemented:
* Core task queue and timer logic
* Local database persistence layer
* Anti-cheat backgrounding detection
* Pet simulator with variable mood and energy levels
* Item shop with persistent currency and purchase tracking
* Basic unit testing for core component logic


---


## 🛠️ Core Features (Implemented in Milestone 1)


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


### 3. Pet Simulator (Feature 3)
Users can rename and manage their pets here. 

**Mood and energy levels**: 
* Levels range from 0 to 100 and decrease over time
* Mood reduces to its current value every 24 hours
* Energy decreases by 20 units every 24 hours

**Pet sprite changes according to mood:**
|   Mood    | Pet Sprite |
|:---------:|:----------:|
|  [0, 25]  |  Unhappy   |
| [25, 75]  |    Calm    |
| [75, 100] |   Happy    |

**Food and toys change mood and energy levels:**
|          |          Mood           |         Energy          |
|:--------:|:-----------------------:|:-----------------------:|
| **Food** |   Increases Slightly    | Increases Significantly |
| **Toys** | Increases Significantly |   Decreases Slightly    |

Users cannot give food when energy is full. Users cannot give toys when mood is full or when the pet does not have enough energy. More expensive toys require a larger amount of energy. 


### 4. Food and Toy Shop (Feature 4)
User can buy food and toys for their pets here. Food and toys can be bought using the coins earned from the timer. One minute of focus equals to one coin. More expensive items generally restore mood and energy by a larger amount. 

**List of Food:** Corn, Pumpkin, Chicken Egg, Chicken Wing, Chicken Breast, Pork Belly

**List of Toys:** Tree branch, Tennis Ball, Kitchen Towel, Frisbee, Rubber duck


---


## 🚧 Potential Features (For Future Milestones)

* User-interactive animations for pet sprite
* Variable pet sprite appearance based on energy / mood
* Variable pet traits
* Customisable pet room
* Pet state pause toggle
* Pet level progression system
* Detailed information on pet status
* Detailed information on shop items
* Dynamic currency gain
* User statistics and achievements
* User task completion streak
* User daily missions system
* App notifications system
* Customisable app switch-out grace period
* Customisable app switch-out allowlist
* Custom iOS Focus on timer start to block notifications
* Timer pause feature toggle


---


## 🏗️ Software Engineering Practices & Architecture


### 1. Model-View-ViewModel (MVVM)
The UI is decoupled from the business logic to ensure a testable and maintainable codebase:
*   **Views:** `ContentView.swift`, `TaskQueueView.swift`, and `TimerView.swift` handle pure UI layouts and transitions.
*   **ViewModels:** `TimerViewModel.swift` manages the state-driven properties (`timeRemaining`, `isRunning`), completely independent of SwiftUI.


### 2. SwiftData Schema & Local Persistence
Clean database schema to manage user data locally:
*   `TaskItem`: Tracks task titles, expected durations, completion states, and creation dates.
*   `UserProfile`: Tracks the user's persistent coin balance and stores the food and toys bought from the shop.
*   `Pet`: Tracks the mood and energy levels over time.
*   **Explicit Saving:** To prevent data loss when developers force-kill the app during Xcode simulation, explicit context saving (`try? modelContext.save()`) on database transactions is implemented.


### 3. Continuous Integration & Unit Testing
Implements the modern **Swift Testing** framework to write test suites verifying the core logic:
*   Tests the initial VM state, successful countdown transitions, and failed backgrounding state resets.
*   Tests can be run locally using **Cmd + U** within Xcode.

**User Model:**
*   Tests ensure that the coins held by the user determine the food and toys the user can buy from the shop.
*   Tests ensure that coins are deducted when the user spend coins in the shop.
*   Tests ensure that the inventory is updated when the user buys food and toys from the shop or when the user gives food and toys to the pet.

**Pet Model:**
*   Tests ensure that the mood and energy levels decay over time according to predefined constants.
*   Tests ensure that the mood and energy levels update when the pet receives food and toys


---


## 💻 Tech Stack
*   **IDE:** Xcode
*   **Language:** Swift
*   **UI Framework:** SwiftUI
*   **Database:** SwiftData
*   **Testing:** Swift Testing (Unit) / XCTest (UI)


---


## Access Instructions
Requirements: Apple Device with XCode and Simulator

1. Clone this repository / download project files from GitHub and unzip pawductive-main.zip
2. Open pawductive-main/Pawductive/Pawductive.xcodeproj in XCode
3. Select run destination in XCode as any iOS Simulator
4. Run the app by pressing the play icon or by pressing ⌘ + R
5. Try Pawductive with the Simulator!


---


## App Screenshots

### Task Queue and Timer
<img src="https://hackmd.io/_uploads/ryZZvH1efl.png" style="width: 30%;">&nbsp; &nbsp; &nbsp;
<img src="https://hackmd.io/_uploads/rkWZwBygMg.png" style="width: 30%;">&nbsp; &nbsp; &nbsp;
<img src="https://hackmd.io/_uploads/SkWZwrkefx.png" style="width: 30%;">

### Pet Simulator
<img src="https://hackmd.io/_uploads/HyZbvrJeGg.png" style="width: 30%;">&nbsp; &nbsp; &nbsp;
<img src="https://hackmd.io/_uploads/SJZWPrkxfe.png" style="width: 30%;">&nbsp; &nbsp; &nbsp;


### Food and Toy Shop
<img src="https://hackmd.io/_uploads/rkbZPrkgze.png" style="width: 30%;">&nbsp; &nbsp; &nbsp;
<img src="https://hackmd.io/_uploads/r1WbvBJeMl.png" style="width: 30%;">&nbsp; &nbsp; &nbsp;


---


## Image Credits
* **Dog Sprites:** Designed by pikisuperstar from [Magnific](https://magnific.com/)
* **Food Sprites:** Designed by YEET from [itch.io](https://2yeet.itch.io/)
* **Toy Sprites:** Desgined by Freepik and bsd from [Flaticon](https://flaticon.com/)