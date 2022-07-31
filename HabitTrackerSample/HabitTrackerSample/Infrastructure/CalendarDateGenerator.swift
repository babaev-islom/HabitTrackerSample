//
//  CalendarDateGenerator.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import Foundation

final class CalendarDateGenerator: DateGenerator {
    private let interval: () -> DateInterval
    private let calendar: Calendar
    
    init(interval: @escaping () -> DateInterval, calendar: Calendar) {
        self.interval = interval
        self.calendar = calendar
    }
    
    func generateDates() -> [Date] {
        let start = interval().start
        let end = interval().end
        guard start != end else { return [] }
        
        return generateDates(from: start, to: end)
    }
    
    private func generateDates(from startDate: Date, to endDate: Date) -> [Date] {
        var dates = [Date]()
        var mutableStartDate = startDate
        while mutableStartDate.compare(endDate) != .orderedDescending {
            dates.append(mutableStartDate)
            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: mutableStartDate) else {
                continue
            }
            mutableStartDate = nextDay
        }
        return dates
    }
}
