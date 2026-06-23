//
//  MissionDetails.swift
//  Pawductive
//
//  Created by Lee Zi Rong on 23/6/26.
//

nonisolated struct MissionDetails: Codable {
    var action: String
    var targetType: String
    var targetName: String
    
    func matches(details: MissionDetails, isSpecific: Bool) -> Bool {
        let result = self.action == details.action && self.targetType == details.targetType
        return isSpecific ? result && self.targetName == details.targetName : result
    }
}
