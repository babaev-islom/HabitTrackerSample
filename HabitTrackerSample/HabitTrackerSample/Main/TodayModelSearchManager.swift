//
//  TodayModelSearchManager.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 01/08/22.
//

import Foundation

final class TodayModelSearchManager {
    private init() {}
    
    static func findTodayModel(in models: [WeekDay]) -> Int {
        var selectedIndex = 0
        models.enumerated().forEach { index, model in
            switch model.type {
            case .today: selectedIndex = index
            default: break
            }
        }
        return selectedIndex
    }
}
