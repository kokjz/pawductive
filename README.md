## Pawductive 🐾
> Gamifying productivity, one pet at a time.

A native iOS gamified productivity application developed in Swift.

Built for Orbital 26 by Team Pawductive **(Team 6658).**

**Targeted Level of Achievement: Gemini**


---


## 💡 Motivation

In a digital era where productivity is highly valued, we wanted to make something convenient where users can reliably achieve their productivity goals while being able to enjoy the process - so we turned to the idea of using virtual pets as free dopamine hits. 

Pets are widely loved yet expensive in real life, so we thought of creating a gamified mobile application where users can have fun raising and training virtual pets by responsibly setting their own fixed tasks, adhering to doing them without other distractions, and completing them for in-game rewards. 


---


## 🚀 What's New (Milestone 2 Summary)

Building upon Milestone 1's proof-of-concept, the application has been expanded into a more cohesive and extensive prototype. Our development for this milestone focused on deep state integration, greater timer flexibility, and a more personalized and engaging user and pet progression loop.

* **Interactive Pet & Habitat Customization:** Interactive tap-gesture pet animations, modifier-based leveling progression system, fully decoratable pet room
* **Progressive Focus Economy:** New ramping quadratic reward curve formula to proportionally incentivise completion of longer tasks
* **Daily Task Completion Streaks:** Consecutive tracking of daily user task completion, automatically resetting broken streaks to zero
* **Timer & Backgrounding Flexibility:** Global settings panel with toggleable timer pause function and customizable app switch-out grace period
* **User Progression Profile:** Dedicated 4th tab displaying user daily missions, user lifetime statistics, and dynamically sorted user achievements
* **App Notifications:** Local push notification center for users to configure application push notifications that alert users on pending streak expiry or pet status

More detailed information on new feature implementation for Milestone 2 can be found in a dedicated section below.

---


## 🛠️ Core Features (Milestone 1)


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

## 🔨 Expanded Feature Implementation (Milestone 2)

### 1. Pet
More new features were added for the pet, most of which were targeted at making the pet and pet room more lively and animated, as well as some new objectives and quality of life features.

* **User-interactive animations for pet sprite:** The pet now has multiple different sprites that change depending on the pet's energy and mood. A small animation is also played when the user taps on the sprite.
* hi please fill in the rest thank u zirong u the goat

### 2. Shop
Shop items are now presented in greater detail, with users now able to see each item's precise effect on their pet's mood and energy before they purchase it.

### 3. Tasks
A couple of changes and new features were updated with regards to tasks, mainly targeted around a better user experience with regards to completing tasks.

* **Dynamic currency gain:** The old formula for calculating how many coins a user gained for time spent on a task was a flat $c = t$ (where $c$ is coins earned and $t$ is time spent in minutes), which is simplistic and does not accurately reflect the difficulty of staying focused for longer periods of time. The new formula has been updated to a ramping quadratic reward curve following the equation $c = t + \frac{t^2}{100}$, so that every extra minute spent on the same task incrementally rewards more coins to the user.
* **User task daily completion streak:** On top of the other main motivation for the user to complete tasks regularly (to maintain the well-being of their virtual pet), it was decided that an additional motivation would be helpful to make sure users had a reason to stay consistent with their productivity. As such, a task completion streak was implemented, with users maintaining their streak as long as they complete at least one task a day. The user's current streak can be viewed from the profile tab.

### 4. Timer
Some changes were made to the functionality of the task timer, all of which were centred around user quality of life and making the timer less strict and adjustable to the user's needs.

* **Timer Pause Toggle:** Previously, the user could not pause the timer, and leaving the application would cause the task to fail immediately. While this strict logic is part of the key features of the app, we recognised that this could prove a usage impediment to users who require usage of their phone as an important part of their workflow. As such, we have implemented an ability to pause the timer: a functionality that the user can enable at their own discretion from the app settings. When the pause toggle is on, the timer screen now has a pause button, which the user can press to stop the timer, and subsequently leave the application without failing the task. After returning to the app, the user can click resume to continue where they left off.
* **Customisable app switch-out grace period:** Previously, the timer would fail instantly the moment the app detected that it had been backgrounded. Once again, while this is in line with the strict focusing that is part of the app's key selling point, we also recognised that this is not always possible, with possible situations arising such as users absent-mindedly clicking banner notifications by accident, which again would be a deterrent for would-be users of the app. To deal with this, we now allow users to set a custom application switch-out grace period of anywhere between 0 seconds (instant fail) to 10 minutes. As long as users return to the application within their set time, they can leave the app for that duration of time without the task failing on return. This setting can also be customised in the app settings.

### 5. Profile
The biggest change in Milestone 2, we added a brand new Profile tab alongside the already existing tabs of Tasks, Pet, and Shop, making it the 4th tab accessible from the bottom tab bar. The Profile tab contains several pieces of useful information about the user of the application, as well as navigation links to additional view where the user can change their user settings and user notifications.

* **Daily missions:** hi zirong all urs ty
* **User statistics:** Users can now view their user statistics. This consists of their current daily task streak, as well as their total tasks completed and total minutes focused.
* **User achievements:** Users now also have achievements that they can view and unlock as they continue to use the application. Users can unlock these achievements and have them display at the top of their achievement list as they continue to complete tasks and accumulate focus minutes.
* **User settings:** The top right of the Profile tab has a clickable gear icon that functions as a navigation link to the user settings view. Inside the user settings view, there is a toggle option for enabling or disabling the previously-mentioned timer pausing feature. Additionally, there is a click-through navigation link that takes the user to the grace period picker view, where they can use slider wheels for minutes and seconds to granularly adjust their preferred app switch-out grace period.
* **User notifications:** thanks zirong

---
## 🚧 Future Features (For Milestone 3)

>#### Feedback on this section will be highly appreciated! ❤️

THIS ALL (MOSTLY) NEEDS TO BE WIPED AND REPLACED WITH NEW STUFF, THE POINTS BELOW ARE ALL OLD POINTS WHICH WERE MOSTLY IMPLEMENTED IN MS2. PLS CHECK POINT BY POINT TO SEE WHAT STILL NEEDS TO BE ADDED TO THE SECTION ABOVE

### 1. Pet
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


## 🏗️ Software Engineering Best-Practices & Application Architecture


### 1. Model-View-ViewModel (MVVM)
The UI is decoupled from the business logic to ensure a testable and maintainable codebase. This provides several key advantages, such as decoupling between frontend and backend, greater ease of testing, and reusability.

* **Models:** These `.swift` files represent the raw data structures, persistent database schemas, and static catalogs of the application. Models are pure structures or reference types that hold state, remaining independent of how the UI is rendered. The current list of models include `Background`, `Decor`, `ShownDecor`, `StoredDecor`, `DailyMission`, `MissionDetails`, `Modifier`, `Food`, `Toy`, `Pet`, `TaskItem`, `Achievement`, `UserProfile`, and `UserStats`.
* **Views:** These `.swift` files represent the declarative UI of the application. Built in **SwiftUI**, views are solely responsible for rendering layouts, responding to user interaction, and observing realtime changes in viewmodels, containing no business logic or manual database transaction code. The current list of views include `BackgroundView`, `CanvasView`, `DecorShopView`, `DecorStoreView`, `ShopDecorView`, `StoreDecorView`, `DailyMissionsView`, `ModifiersView`, `ModifierView`, `NotificationManagerView`, `GracePeriodPickerView`, `SettingsManagerView`, `ShopCategory`, `FoodShopView`, `ShopView`, `ToyShopView`, `FoodStoreView`, `PetSimulatorView`, `ToyStoreView`, `ValueBarView`, `TaskQueueView`, `TimerView`, `ProfileView`, `UserCoinsView`, `ContentView`, and `Text+Extensions`.
* **ViewModels:** These `.swift` files represent the "brain" and the bridge of the application. Viewmodels are state-driven, observe user interactions, perform calculations, run asynchronous timers, and coordinate context transactions with the database. The current list of viewmodels include `MissionManager`, `NotificationManager`, `SettingsManager`, `TimerViewModel`, and `DataContainer`.

Additionally, to round up the list of `.swift` files that are part of the main application, `PawductiveApp` serves as the entry point for the application.


### 2. SwiftData Schema & Local Persistence
A clean, relational database schema is used to manage all user, task, pet, and game-economy data locally using **SwiftData**.
* `TaskItem`: Tracks individual task titles, expected focus durations, completion states, and creation timestamps.
* `UserProfile`: Tracks the user's active, spendable coin wallet, along with dictionaries storing their food and toy inventories.
* `Pet`: Tracks the pet's name, age, level progression, cumulative XP, and real-time mood and energy decay.
* `UserStats`: Tracks global lifetime user progression , including total completed tasks, total focus minutes, lifetime coins earned, and consecutive daily focus streaks.
* `DailyMission`: Tracks the title, target requirements, active progress, claimed states, and reward amounts of individual daily missions.
* `MissionManager`: Manages the current active daily missions list, checking calendar dates to trigger daily resets, and randomly drawing new missions from the global catalog.
* `Modifier`: Tracks unlockable, level-up upgrades for pet decay rates and item efficiencies (e.g., lower store prices, reduced energy/mood decay, increased food calories).
* `NotificationManager`: Tracks user configurations for local iOS push notifications (such as toggling alerts for low pet stats or expiring daily streaks).
* `Background`: Represents distinct visual backdrops (e.g., the indoor "Room" or outdoor "Yard") where the pet resides.
* `StoredDecor`: Represents individual decoration assets owned by the user, linked to a specific background room.
* `ShownDecor`: Represents active decorations currently placed in the pet's environment, saving their relative coordinate ratios and layout order.

**Explicit Saving:** To prevent data loss when developers force-kill the app during Xcode simulation, explicit context saving (`try? modelContext.save()`) on database transactions is implemented.


### 3. Continuous Integration & Unit Testing
Implements the modern **Swift Testing** framework to write test suites verifying the core logic. By utilizing isolated, in-memory databases (`isStoredInMemoryOnly: true`) during testing, database saves, deletes, and updates are verified without polluting the physical application files on disk. The current list of `.swift` test suites implement the following unit tests and ensure the following:

**`PetTests`**
* _`testCanReceiveFood`_: Pet can receive food if and only if energy is not full.
* _`testReceiveFood`_: Pet attributes are updated accurately on receiving food.
* _`testCanReceiveToy`_: Pet can receive toy if and only if mood is not full and pet has sufficient energy.
* _`testReceiveToy`_: Pet attributes are updated accurately on receiving toy.
* _`testUpdatePet`_: Pet attributes update accurately on passage of time.

**`SettingsManagerTests`**
* _`testSettingsManagerMemoryAddress`_: Settings manager memory address is shared.
* _`testSettingsManagerPersistence`_: User global settings are maintained and persist.

**`TaskItemTests`**
* _`testCreateAndSaveTask`_: Tasks can be saved successfully to the local database.
* _`testDeleteTask`_: Tasks can be deleted successfully from the local database.
* _`testToggleTaskCompletion`_: Task state can be toggled succesfully from incomplete to complete.
* _`testTaskItemInitializationDateTolerance`_: Tasks are created in expected time with date tolerance.

**`TimerViewModelTests`**
* _`testInitialState`_: Timer starts with clean, empty values.
* _`testStartTimer`_: Minutes and seconds are calculated correctly on timer start.
* _`testFailSession`_: Session failure resets the timer state.
* _`testClaimRewardsCreatesProfileAndAddsCoins`_: Rewards are written accurately to the local database on timer completion.
* _`testStartingNewTimerWhileAlreadyRunningOverwritesSuccessfully`_: Timers running simultaneously are not allowed.
* _`testDynamicCurrGainFormula`_: The correct amount of coins is awarded on completing tasks of various durations based on the ramping quadratic reward formula.
* _`testPauseAndResume`_: Timer paused and running state is accurately reflected on timer pause, resume, and session failure.

**`UserStatsTests`**
* _`testUserStatsInit`_: User stats initialise with the correct values.
* _`testSaveAndUpdate`_: User stats save correctly and persist in the database.
* _`testAchievementUnlocks`_: Achievements are unlocked correctly and in order with changes in user stats.
* _`testUserStreak`_: User streak maintains correctly, breaks correctly, and does not double-increment.
* _`testLaunchStreakReset`_: User streak is updated and maintained accurately on app launch.

**`UserTests`**
* _`testCanAfford`_: User can afford only items that have a price lower or equal to their current coin total.
* _`testBuyFood`_: Food inventory is updated accurately with purchase of food.
* _`testBuyToys`_: Toy inventory is updated accurately with purchase of toy.
* _`testGiveFood`_: Food inventory is updated accurately with usage of food.
* _`testGiveToy`_: Toy inventory is updated accurately with usage of toy.

All above unit tests can be run locally using **⌘ + U** within Xcode.

### 4. Version Control & Branching
To support parallel development and maintain a clean repository history, a professional, industry-standard **Git Feature-Branch Workflow** is adopted.

* **Protected `main` Branch:** The `main` branch serves as the stable, production-ready environment. Direct pushes to `main` are strictly prohibited, and all merges into `main` must always contain a fully functional, compilation-safe version of the application.
*   **Feature Isolation:** Every new feature (such as the core timer, user streaks, or pet customizations) is developed in its own isolated branch (e.g., `feat/timer-pause-toggle`, `feature/user-stats-achievements`, `simulator-updates`). This prevents work-in-progress code from disrupting other stable components.
*   **Selective Staging:** When introducing core database models at the start (such as `UserProfile`), the `.swift` model files are selectively staged and merged first before further development elsewhere. This enables asynchronous development by immediately synchronizing and adopting the same database schema on separate branches, eliminating numerous potential SwiftData migration crashes and merge conflicts.
*   **Pull Requests & Code Reviews:** Merging into `main` requires a formal pull request following standard Git terminology and structure conventions. Assigned reviewers are expected to inspect the diff, verify the implementation locally, approve the pull request, and execute the merge.
*   **Local Conflict Resolution:** If merge conflicts arise on common files (such as `ContentView.swift` or `DataContainer.swift`), they are resolved on the local branch before pushing. This guarantees that `main` never experiences "broken-build" states and remains functional.
*   **Structured Commits:** Structured commits with messaging convention (e.g., `Feat:`, `Style:`, `Chore:`, `Test:`) is encouraged. This makes the repository's history easily readable, organized, and searchable.


---


## 💻 Tech Stack
*   **IDE:** Xcode
*   **Language:** Swift
*   **UI Framework:** SwiftUI
*   **Database:** SwiftData
*   **Testing:** Swift Testing (Unit) / XCTest (UI)


---


## 🎮 Access Instructions
Requirements: Apple Device with XCode and Simulator

1. Clone this repository / download project files from GitHub and unzip pawductive-main.zip
2. Open pawductive-main/Pawductive/Pawductive.xcodeproj in XCode
3. Select run destination in XCode as any iOS Simulator
4. Run the app by pressing the play icon or by pressing **⌘ + R**
5. Try Pawductive by running it with the Simulator under any iOS device

Alternatively, a pre-built binary in the form of an `.iPA` file can be downloaded from the latest pre-release or release. As this file is unsigned, you will need to sideload it onto any compatible iOS device and complete the signing process yourself. Please check the pre-release or release information for more details.

---


## 📸 App Screenshots

NEEDS UPDATING

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


## 🖼️ Image Credits
* **Dog Sprites:** Designed by pikisuperstar from [Magnific](https://magnific.com/)
* **Food Sprites:** Designed by YEET from [itch.io](https://2yeet.itch.io/)
* **Toy Sprites:** Desgined by Freepik and bsd from [Flaticon](https://flaticon.com/)
* **Coin Sprite:** Desgined by vectorsmarket15 from [Flaticon](https://flaticon.com/)
* **Room Sprites:** Room and furniture vectors by [Vecteezy](https://www.vecteezy.com/)
* **Yard Sprites:** Designed by upklyak from [Magnific](/GzZykolnSNmNIH1x4YF4Xg)