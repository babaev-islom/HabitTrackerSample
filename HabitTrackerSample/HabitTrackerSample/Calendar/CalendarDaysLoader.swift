//
//  CalendarDaysLoader.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 29/07/22.
//

import Foundation

final class CalendarDaysLoader: WeekDaysLoader {
    
    private let generator: DateGenerator
    private let lastWeekInterval: () -> DateInterval
    private let nextWeekInterval: () -> DateInterval
    private let today: () -> Date
    private let calendar: Calendar
    
    init(
        generator: DateGenerator,
        lastWeekInterval: @escaping () -> DateInterval,
        nextWeekInterval: @escaping () -> DateInterval,
        today: @escaping () -> Date,
        calendar: Calendar
    ) {
        self.generator = generator
        self.lastWeekInterval = lastWeekInterval
        self.nextWeekInterval = nextWeekInterval
        self.today = today
        self.calendar = calendar
    }
    
    func loadDays() -> [WeekDay] {
        var days = [WeekDay]()
        let dates = generator.generateDates()
        dates.forEach { date in
            if isInLastWeekInterval(date) {
                days.append(WeekDay(type: .inThePast(date)))
            } else if isToday(date) {
                days.append(WeekDay(type: .today(date)))
            } else if inNextWeekInterval(date) {
                days.append(WeekDay(type: .inTheFuture(date)))
            }
        }
        return days
    }
    
    private func isInLastWeekInterval(_ date: Date) -> Bool {
        lastWeekInterval().contains(date)
    }
    
    private func inNextWeekInterval(_ date: Date) -> Bool {
        nextWeekInterval().contains(date)
    }
    
    private func isToday(_ date: Date) -> Bool {
        let dayDifferences = calendar.dateComponents([.day], from: date, to: today()).day
        return dayDifferences == 0
    }
}
