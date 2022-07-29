//
//  CalendarDaysLoader.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 29/07/22.
//

import Foundation

final class CalendarDaysLoader: WeekDaysLoader {
    
    private let generator: DateGenerator
    private let intervalInThePast: () -> DateInterval
    private let intervalInTheFuture: () -> DateInterval
    private let today: () -> Date
    private let calendar: Calendar
    
    init(
        generator: DateGenerator,
        intervalInThePast: @escaping () -> DateInterval,
        intervalInTheFuture: @escaping () -> DateInterval,
        today: @escaping () -> Date,
        calendar: Calendar
    ) {
        self.generator = generator
        self.intervalInThePast = intervalInThePast
        self.intervalInTheFuture = intervalInTheFuture
        self.today = today
        self.calendar = calendar
    }
    
    func loadDays() -> [WeekDay] {
        var days = [WeekDay]()
        let dates = generator.generateDates()
        dates.forEach { date in
            if isInThePast(date) {
                days.append(WeekDay(type: .inThePast(date)))
            } else if isToday(date) {
                days.append(WeekDay(type: .today(date)))
            } else if isInTheFuture(date) {
                days.append(WeekDay(type: .inTheFuture(date)))
            }
        }
        return days
    }
    
    private func isInThePast(_ date: Date) -> Bool {
        intervalInThePast().contains(date)
    }
    
    private func isInTheFuture(_ date: Date) -> Bool {
        intervalInTheFuture().contains(date)
    }
    
    private func isToday(_ date: Date) -> Bool {
        let dayDifferences = calendar.dateComponents([.day], from: date, to: today()).day
        return dayDifferences == 0
    }
}
