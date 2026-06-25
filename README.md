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


**Successfully implemented:**
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

## 🚀 Milestone 2 Summary: More Feature Implementation

### 1. Pet
More new features were added for the pet, most of which were targeted at making the pet and pet room more lively and animated, as well as some new objectives and quality of life features.

* **User-interactive animations for pet sprite:** The pet now has multiple different sprites that change depending on the pet's energy and mood. A small animation is also played when the user taps on the sprite.
* hi please fill in the rest thank u zirong u the goat

### 2. Shop
Shop items are now presented in greater detail, with users now able to see each item's precise effect on their pet's mood and energy before they purchase it.

### 3. Tasks
A couple of changes and new features were updated with regards to tasks, mainly targeted around a better user experience with regards to completing tasks.

* **Dynamic currency gain:** The old formula for calculating how many coins a user gained for time spent on a task was a flat $c = t$ (where $c$ is coins earned and $t$ is time spent in minutes), which is simplistic and does not accurately reflect the difficulty of staying focused for longer periods of time. The new formula has been updated to a ramping quadratic reward curve following the equation $c = t + \frac{t^2}{100}$, so that every extra minute spent on the same task incrementally rewards more coins to the user.
* **User task daily completion streak:** On top of the other main motivation for the user to complete tasks regularly (to maintain the well-being of their virtual pet), it was decided that an additional motivation would be helpful to make sure users had a reason to stay consistent with their productivity. As such, a task completion streak was implemented, with users maintaining their streak as long as they complete at least one task a day. The user's current streak can be viewed from the profile tab (more on that later).

### 4. Timer
Some changes were made to the functionality of the task timer, all of which were centred around user quality of life and making the timer less strict and adjustable to the user's needs.

* **Timer Pause Toggle:** Previously, the user could not pause the timer, and leaving the application would cause the task to fail immediately. While this strict logic is part of the key features of the app, we recognised that this could prove a usage impediment to users who require usage of their phone as an important part of their workflow. As such, we have implemented an ability to pause the timer: a functionality that the user can enable at their own discretion from the app settings (more on app settings later). When the pause toggle is on, the timer screen now has a pause button, which the user can press to stop the timer, and subsequently leave the application without failing the task. After returning to the app, the user can click resume to continue where they left off.
* **Customisable app switch-out grace period:** Previously, the timer would fail instantly the moment the app detected that it had been backgrounded. Once again, while this is in line with the strict focusing that is part of the app's key selling point, we also recognised that this is not always possible, with possible situations arising such as users absent-mindedly clicking banner notifications by accident, which again would be a deterrent for would-be users of the app. To deal with this, we now allow users to set a custom application switch-out grace period of anywhere between 0 seconds (instant fail) to 10 minutes. As long as users return to the application within their set time, they can leave the app for that duration of time without the task failing on return. This setting can also be customised in the app settings.

### 5. Profile
The biggest change in Milestone 2, we added a brand new Profile tab alongside the already existing tabs of Tasks, Pet, and Shop, making it the 4th tab accessible from the bottom tab bar. The Profile tab contains several pieces of useful information about the user of the application, as well as navigation links to additional view where the user can change their user settings and user notifications.

* **Daily missions:** hi zirong all urs ty
* **User statistics:** Users can now view their user statistics. This consists of their current daily task streak, as well as their total tasks completed and total minutes focused.
* **User achievements:** Users now also have achievements that they can view and unlock as they continue to use the application. Users can unlock these achievements and have them display at the top of their achievement list as they continue to complete tasks and accumulate focus minutes.
* **User settings:** The top right of the Profile tab has a clickable gear icon that functions as a navigation link to the user settings view. Inside the user settings view, there is a toggle option for enabling or disabling the previously-mentioned timer pausing feature. Additionally, there is a click-through navigation link that takes the user to the grace period picker view, where they can use slider wheels for minutes and seconds to granularly adjust their preferred app switch-out grace period.
* **User notifications:** thanks zirong

---
## 🚧 Potential Features (For Future Milestones)

>#### Feedback on this section will be highly appreciated! ❤️

### 1. Pet (PLEASE ADD WHATEVER RELEVANT FROM HERE TO PREVIOUS SECTION WHEN U CAN)
* **[DONE] User-interactive animations for pet sprite:** Animated pet appearance to replace the current static sprite. Pet can react to user interaction. (ADDED TO PREVIOUS SECTION, CAN UPDATE/REWRITE IF U WANT)
* **[DONE] Customisable pet room:** Customize the background in the pet simulator. Allow users to purchase decorations to customise their pet room. 
* **[DONE] Variable pet traits:** Pet can develop different traits or personality that impact how their energy / mood is affected by various items.
* **[DONE] Pet level progression system:** Pet can level up and unlock different traits / abilities that affect their energy / mood and more.
* **[DONE] Detailed information on pet status:** More detailed information on the pet status beyond two indicator bars for energy / mood (e.g. numerical energy, mood banding).
* **Pet state pause toggle:** Allow users to pause / freeze the state of the pet to prevent loss of progress if they are unable to access the app for a period of time.
* **Pet Statistics & Achievements:** Add statistics and achievements for the pet simulator

### 2. Shop
* **[DONE] Detailed information on shop items:** More detailed information on items in the shop and how they affect energy / mood. (ADDED TO PREVIOUS SECTION CAN DELETE WHEN OK)

### 3. Tasks
* **Dynamic currency gain:** Instead of the current formula which has a flat reward rate of 1 coin per minute, a different formula can be used to dynamically adjust the amount earned per minute based on the total length of the task. (ADDED TO PREVIOUS SECTION CAN DELETE WHEN OK)
* **[DONE] User task completion streak:** Rewards users for completing tasks daily. (ADDED TO PREVIOUS SECTION CAN DELETE WHEN OK)

### 4. Timer
* **Customisable app switch-out grace period:** Allows users to adjust the amount of time they can leave the app during a focus timer session without the task failing. (ADDED TO PREVIOUS SECTION CAN DELETE WHEN OK)
* **Customisable app switch-out allowlist:** Allows users to switch out to specific apps without the task failing. (NOT IMPLEMENTING NOW, MIGHT NOT IMPLEMENT EVER, TALK TO ME IF NEED REASON)
* **Timer pause feature toggle:** Allows users to give themselves the ability to pause the timer as needed and switch out of the app without the task failing. (ADDED TO PREVIOUS SECTION CAN DELETE WHEN OK)

### 5. Others

* **[DONE] User statistics:** Allows users to keep track of various information such as total tasks completed, time spent focusing, coins earned, etc. (ADDED TO PREVIOUS SECTION CAN DELETE WHEN OK)
* **User daily missions system:** Gives users a set of tasks to complete daily (e.g. complete 1 task, feed the pet, etc.) to incentivise daily usage. (PLEASE ADD TO PREVIOUS SECTION WHEN U CAN)
* **[DONE] App notifications system:** Allows user to receive notifications to alert them to various situations (e.g. pet energy/mood low, streak ending) while the app is not open.(PLEASE ADD TO PREVIOUS SECTION WHEN U CAN)
* **App widgets:** Allows user to add different app widgets to their home screen to support easy access of multiple features (e.g. viewing of live pet status, quickstart task, view task list). (IS THIS IMPLEMENTED? IDK)


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
Implements the modern **Swift Testing** framework to write test suites verifying the core logic. The implemented unit tests ensure the following:

**Tasks:**
* Tasks can be saved successfully to the local database.
* Tasks can be deleted successfully from the local database.
* Task state can be toggled succesfully from incomplete to complete.
* Tasks are created in expected time with date tolerance.

**Timer:**
* Timer starts with clean, empty values.
* Minutes and seconds are calculated correctly on timer start.
* Session failure resets the timer state.
* Rewards are written accurate to the local databse on timer completion.
* Timers running simultaneously are not allowed.

**User Model:**
*   The coins held by the user determine the food and toys the user can buy from the shop.
*   Coins are deducted when the user spend coins in the shop.
*   The inventory is updated when the user buys food and toys from the shop or when the user gives food and toys to the pet.

**Pet Model:**
*   The mood and energy levels decay over time according to predefined constants.
*   The mood and energy levels update when the pet receives food and toys.

All above unit tests can be run locally using **⌘ + U** within Xcode.


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
4. Run the app by pressing the play icon or by pressing **⌘ + R**
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
* **Coin Sprite:** Desgined by vectorsmarket15 from [Flaticon](https://flaticon.com/)
* **Room Sprites:** Room and furniture vectors by [Vecteezy](https://www.vecteezy.com/)
* **Yard Sprites:** Designed by upklyak from [Magnific](/GzZykolnSNmNIH1x4YF4Xg)