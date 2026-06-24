//
//  SettingsManagerTests.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 23/6/26.
//

import Testing
import Foundation
@testable import Pawductive

@Suite struct SettingsManagerTests {
    
    //test 1: test settingsmanager memory address
    @Test func testSettingsManagerMemoryAddress() {
        let manager1 = SettingsManager.shared
        let manager2 = SettingsManager.shared
        
        #expect(manager1 === manager2)
    }
    
    //test 2: settings persistence
    @Test func testSettingsManagerPersistence() {
        let manager = SettingsManager.shared
        
        manager.isTimerPauseEnabled = true
        #expect(UserDefaults.standard.bool(forKey: "isTimerPauseEnabled") == true)
        manager.isTimerPauseEnabled = false
        #expect(UserDefaults.standard.bool(forKey: "isTimerPauseEnabled") == false)
        
        manager.gracePeriodSeconds = 0
        #expect(UserDefaults.standard.integer(forKey: "gracePeriodSeconds") == 0)
        manager.gracePeriodSeconds = 15
        #expect(UserDefaults.standard.integer(forKey: "gracePeriodSeconds") == 15)
        manager.gracePeriodSeconds = 30
        #expect(UserDefaults.standard.integer(forKey: "gracePeriodSeconds") == 30)
        manager.gracePeriodSeconds = 60
        #expect(UserDefaults.standard.integer(forKey: "gracePeriodSeconds") == 60)
        manager.gracePeriodSeconds = 90
        #expect(UserDefaults.standard.integer(forKey: "gracePeriodSeconds") == 90)
        
        manager.gracePeriodSeconds = 0
    }
}
