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
    
    var gracePeriodSeconds: Int {
        didSet { UserDefaults.standard.set(gracePeriodSeconds, forKey: "gracePeriodSeconds") }
    }
    
    private init() {
        //timer pause set to false by default
        self.isTimerPauseEnabled = UserDefaults.standard.object(forKey: "isTimerPauseEnabled") as? Bool ?? false
        //grace period set to 0 by default
        self.gracePeriodSeconds = UserDefaults.standard.object(forKey: "gracePeriodSeconds") as? Int ?? 0
    }
}
