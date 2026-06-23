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
    
    //test 2: persistence
    @Test func testSettingsManagerPersistence() {
        let manager = SettingsManager.shared
        
        manager.isTimerPauseEnabled = true
        #expect(UserDefaults.standard.bool(forKey: "isTimerPauseEnabled") == true)
        
        manager.isTimerPauseEnabled = false
        #expect(UserDefaults.standard.bool(forKey: "isTimerPauseEnabled") == false)
    }
}
