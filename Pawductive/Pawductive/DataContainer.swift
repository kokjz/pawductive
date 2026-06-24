//
//  DataContainer.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 21/5/26.
//

import Foundation
import SwiftData

class DataContainer {
    let modelContainer: ModelContainer
    
    var context: ModelContext {
        modelContainer.mainContext
    }
    
    static let dailyMissions = [
        DailyMission(title: "Finish 3 tasks", requirement: 3, reward: 5, isSpecific: true,
                     details: MissionDetails(action: "DO", targetType: "TASK", targetName: "Number")),
        DailyMission(title: "Focus for 15 minutes", requirement: 15, reward: 5, isSpecific: true,
                     details: MissionDetails(action: "DO", targetType: "TASK", targetName: "Duration")),
        DailyMission(title: "Buy 3 food", requirement: 3, reward: 5, isSpecific: false,
                     details: MissionDetails(action: "BUY", targetType: "FOOD", targetName: "")),
        DailyMission(title: "Give 3 food", requirement: 3, reward: 5, isSpecific: false,
                     details: MissionDetails(action: "GIVE", targetType: "FOOD", targetName: "")),
        DailyMission(title: "Buy 3 toys", requirement: 3, reward: 5, isSpecific: false,
                     details: MissionDetails(action: "BUY", targetType: "TOY", targetName: "")),
        DailyMission(title: "Give 3 toys", requirement: 3, reward: 5, isSpecific: false,
                     details: MissionDetails(action: "GIVE", targetType: "TOY", targetName: "")),
        DailyMission(title: "Buy 3 decors", requirement: 3, reward: 5, isSpecific: false,
                     details: MissionDetails(action: "BUY", targetType: "DECOR", targetName: "")),
        DailyMission(title: "Display 3 decors", requirement: 3, reward: 5, isSpecific: false,
                     details: MissionDetails(action: "DISPLAY", targetType: "DECOR", targetName: "")),
    ]
    
    init(coins: Int = 800,
         mood: Double = 100,
         energy: Double = 100,
         experiencePoints: Int = 0,
         loadInventory: Bool = true,
         loadDecorations: Bool = true,
         inMemory: Bool = true)
    {
        let schema = Schema([
            Background.self,
            DailyMission.self,
            MissionManager.self,
            Modifier.self,
            NotificationManager.self,
            Pet.self,
            ShownDecor.self,
            StoredDecor.self,
            TaskItem.self,
            UserProfile.self,
            UserStats.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            let descriptor = FetchDescriptor<UserProfile>()
            let existingUsers = try? context.fetch(descriptor)
            if existingUsers?.isEmpty ?? true {
                let user = UserProfile(coins: coins)
                if loadInventory {
                    loadFoodInventory(user: user)
                    loadToyInventory(user: user)
                }
                context.insert(user)
                context.insert(UserStats())
                context.insert(NotificationManager())
                
                let missionManager = MissionManager(numActiveMissions: 3)
                missionManager.initializeActiveMissions(missions: DataContainer.dailyMissions)
                context.insert(missionManager)
                
                insertBackgrounds()
                insertStoredDecors()
                if loadDecorations {
                    loadRoomDecorations()
                }
                
                let pet = createPet(mood: mood, energy: energy, experiencePoints: experiencePoints)!
                insertPetModifiers(pet)
                context.insert(pet)
                
                insertFoodModifiers()
                insertToyModifiers()
                try context.save()
                print("Database empty, seed default user and pet success")
            } else {
                checkAndResetBrokenStreak()
                print("User profile found, skipping seeding")
                
                let missionManager = try context.fetch(FetchDescriptor<MissionManager>()).first!
                missionManager.refreshActiveMissions(missions: DataContainer.dailyMissions)
            }
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }
    
    private func loadFoodInventory(user: UserProfile) {
        user.foodInventory[Food.corn.name] = 3
        user.foodInventory[Food.chickenWing.name] = 3
        user.foodInventory[Food.porkBelly.name] = 3
    }
    
    private func loadToyInventory(user: UserProfile) {
        user.toyInventory[Toy.frisbee.name] = 3
        user.toyInventory[Toy.treeBranch.name] = 3
        user.toyInventory[Toy.rubberDuck.name] = 3
    }

    private func insertPetModifiers(_ pet: Pet) {
        let moodModifier =
            Modifier(label: "Pet1", name: "Conserve Mood", details: "Mood decreases at a slower rate", level: 0, maxLevel: 5)
        let energyModifier =
            Modifier(label: "Pet2", name: "Conserve Energy", details: "Energy decreases at a slower rate", level: 0, maxLevel: 5)
        
        pet.moodDecayModifier = moodModifier
        pet.energyDecayModifier = energyModifier
        
        context.insert(moodModifier)
        context.insert(energyModifier)
    }
    
    private func insertFoodModifiers() {
        let costModifier =
            Modifier(label: "Food1", name: "Lower Price", details: "Decrease cost of food", level: 0, maxLevel: 2)
        let moodModifier =
            Modifier(label: "Food2", name: "Improve Taste", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
        let energyModifier =
            Modifier(label: "Food3", name: "Increase Calories", details: "Energy increases by a larger amount", level: 0, maxLevel: 5)
        
        for food in Food.allFoods {
            food.costModifier = costModifier
            food.moodModifier = moodModifier
            food.energyModifier = energyModifier
        }
        
        context.insert(costModifier)
        context.insert(moodModifier)
        context.insert(energyModifier)
    }
    
    private func insertToyModifiers() {
        let costModifier =
            Modifier(label: "Toy1", name: "Lower Price", details: "Decrease cost of toys", level: 0, maxLevel: 2)
        let moodModifier =
            Modifier(label: "Toy2", name: "Improve Design", details: "Mood increases by a larger amount", level: 0, maxLevel: 5)
        let energyModifier =
            Modifier(label: "Toy3", name: "Reduce Weight", details: "Energy decreases by a smaller amount", level: 0, maxLevel: 5)
        
        for toy in Toy.allToys {
            toy.costModifier = costModifier
            toy.moodModifier = moodModifier
            toy.energyModifier = energyModifier
        }
        
        context.insert(costModifier)
        context.insert(moodModifier)
        context.insert(energyModifier)
    }
    
    private func insertBackgrounds() {
        let backgrounds = [
            Background(name: "Room", imageName: "room"),
            Background(name: "Yard", imageName: "yard"),
        ]
        
        for background in backgrounds {
            context.insert(background)
        }
    }
    
    private func insertStoredDecors() {
        guard let backgrounds = try? context.fetch(FetchDescriptor<Background>()) else { return }
        
        guard let room = backgrounds.filter({ $0.name == "Room" }).first else { return }
        let storedRoomDecors = [
            StoredDecor(decor: Decor(name: "Vase", imageName: "vase", relativeHeight: 0.3, cost: 75), background: room),
            StoredDecor(decor: Decor(name: "Cabinet", imageName: "cabinet", relativeHeight: 0.5, cost: 200), background: room),
            StoredDecor(decor: Decor(name: "Clock", imageName: "clock", relativeHeight: 0.2, cost: 100), background: room),
            StoredDecor(decor: Decor(name: "Mirror", imageName: "mirror", relativeHeight: 0.2, cost: 150), background: room),
            StoredDecor(decor: Decor(name: "Plant", imageName: "plant", relativeHeight: 0.2, cost: 50), background: room),
            StoredDecor(decor: Decor(name: "Sofa", imageName: "sofa", relativeHeight: 0.35, cost: 300), background: room),
            StoredDecor(decor: Decor(name: "Window", imageName: "window", relativeHeight: 0.5, cost: 250), background: room),
        ]
        for storedDecor in storedRoomDecors {
            context.insert(storedDecor)
        }
        
        guard let yard = backgrounds.filter({ $0.name == "Yard" }).first else { return }
        let storedYardDecors = [
            StoredDecor(decor: Decor(name: "Armchair", imageName: "armchair", relativeHeight: 0.20, cost: 80), background: yard),
            StoredDecor(decor: Decor(name: "Basket Swing", imageName: "basketSwing", relativeHeight: 0.40, cost: 180), background: yard),
            StoredDecor(decor: Decor(name: "BBQ Grill", imageName: "bbqGrill", relativeHeight: 0.30, cost: 120), background: yard),
            StoredDecor(decor: Decor(name: "Dog House", imageName: "dogHouse", relativeHeight: 0.20, cost: 250), background: yard),
            StoredDecor(decor: Decor(name: "Lawnmower", imageName: "lawnmower", relativeHeight: 0.15, cost: 100), background: yard),
            StoredDecor(decor: Decor(name: "Orange Juice", imageName: "orangeJuice", relativeHeight: 0.10, cost: 30), background: yard),
            StoredDecor(decor: Decor(name: "Parasol", imageName: "parasol", relativeHeight: 0.40, cost: 200), background: yard),
            StoredDecor(decor: Decor(name: "Tennis Ball", imageName: "tennisBallYard", relativeHeight: 0.05, cost: 20), background: yard),
            StoredDecor(decor: Decor(name: "Tomato Plant", imageName: "tomatoPlant", relativeHeight: 0.20, cost: 40), background: yard),
            StoredDecor(decor: Decor(name: "Tree House", imageName: "treeHouse", relativeHeight: 0.60, cost: 500), background: yard),
            StoredDecor(decor: Decor(name: "Wooden Table", imageName: "woodenTable", relativeHeight: 0.10, cost: 60), background: yard),
        ]
        for storedDecor in storedYardDecors {
            context.insert(storedDecor)
        }
    }
    
    private func loadRoomDecorations() {
        guard let backgrounds = try? context.fetch(FetchDescriptor<Background>()) else { return }
        guard let room = backgrounds.filter({ $0.name == "Room" }).first else { return }
        
        guard let vase = room.storedDecors.filter({ $0.decor.name == "Vase" }).first else { return }
        guard let plant = room.storedDecors.filter({ $0.decor.name == "Plant" }).first else { return }
        guard let mirror = room.storedDecors.filter({ $0.decor.name == "Mirror" }).first else { return }
        
        let shownDecors = [
            ShownDecor(order: 0, relativeX: 0.073, relativeY: 0.673, storedDecor: vase, background: room),
            ShownDecor(order: 1, relativeX: 0.927, relativeY: 0.673, storedDecor: vase, background: room),
            ShownDecor(order: 2, relativeX: 0.144, relativeY: 0.726, storedDecor: plant, background: room),
            ShownDecor(order: 3, relativeX: 0.848, relativeY: 0.726, storedDecor: plant, background: room),
            ShownDecor(order: 4, relativeX: 0.500, relativeY: 0.350, storedDecor: mirror, background: room),
        ]
        
        for shownDecor in shownDecors {
            context.insert(shownDecor)
        }
    }
    
    private func createPet(mood: Double, energy: Double, experiencePoints: Int) -> Pet? {
        guard let backgrounds = try? context.fetch(FetchDescriptor<Background>()) else { return nil }
        guard let room = backgrounds.filter({ $0.name == "Room" }).first else { return nil }
        return Pet(mood: mood, energy: energy, experiencePoints: experiencePoints, background: room)
    }
    
    //check user streak validity on launch
    private func checkAndResetBrokenStreak() {
        let statsDescriptor = FetchDescriptor<UserStats>()
        if let statsList = try? context.fetch(statsDescriptor), let stats = statsList.first {
            if let lastActive = stats.lastActiveDate {
                let calendar = Calendar.current
                let lastActiveMidnight = calendar.startOfDay(for: lastActive)
                let todayMidnight = calendar.startOfDay(for: Date())
                let components = calendar.dateComponents([.day], from: lastActiveMidnight, to: todayMidnight)
                if let daysBetween = components.day, daysBetween > 1 { //streak broken
                    stats.currentStreak = 0
                    try? context.save()
                    print("Broken streak detected on launch, reset to 0")
                } else { //streak still active
                    print("Streak still active on launch, current streak: \(stats.currentStreak)")
                }
            }
        }
    }
}
