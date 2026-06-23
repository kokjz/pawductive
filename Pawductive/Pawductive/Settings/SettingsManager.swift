//
//  SettingsManager.swift
//  Pawductive
//
//  Created by Kok Jun Zhe on 23/6/26.
//

import Foundation
import Observation

@Observable
class SettingsManager {
    static let shared = SettingsManager()
    
    var isTimerPauseEnabled: Bool {
        didSet { UserDefaults.standard.set(isTimerPauseEnabled, forKey: "isTimerPauseEnabled") }
    }
    
    private init() {
        //set to false by default
        self.isTimerPauseEnabled = UserDefaults.standard.object(forKey: "isTimerPauseEnabled") as? Bool ?? false
    }
}
