//
//  WeekType.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 29/07/22.
//

import Foundation

enum WeekDayType: Equatable {
    case inThePast(Date)
    case today(Date)
    case nextWeek(Date)
}
