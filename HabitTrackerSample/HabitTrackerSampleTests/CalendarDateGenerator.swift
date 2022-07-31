//
//  CalendarDateGenerator.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 31/07/22.
//

import XCTest
@testable import HabitTrackerSample

class CalendarDateGenerator: DateGenerator {
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

final class CalendarDateGeneratorTests: XCTestCase {
    
    func test_generateDates_withTheSameDateIntervalForEndAndStart_loadsEmptyDates() {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        let intervalWithTheSameStartAndEndDates = DateInterval(start: july18, end: july18)

        let sut = makeSUT(interval: { intervalWithTheSameStartAndEndDates })
        
        let result = sut.generateDates()
        
        XCTAssertEqual(result, [])
    }

    func test_generateDates_withIntervalOfOneDay_loadsTwoDates() {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        let july19 = Date(timeIntervalSince1970: 1658188800)

        let intervalFromJuly18ToJuly19 = DateInterval(start: july18, end: july19)
        let sut = makeSUT(interval: { intervalFromJuly18ToJuly19 })
        
        let result = sut.generateDates()

        XCTAssertEqual(result, [july18, july19])
    }
    
    func test_generateDates_withIntervalOfThreeDays_loadsFourDates() {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        let july21 = Date(timeIntervalSince1970: 1658361600)

        let intervalFromJuly18ToJuly21 = DateInterval(start: july18, end: july21)
        let sut = makeSUT(interval: { intervalFromJuly18ToJuly21 })
        
        let result = sut.generateDates()

        XCTAssertEqual(result.count, 4)
    }
    
    private func makeSUT(interval: @escaping () -> DateInterval) -> CalendarDateGenerator {
        let calendar: Calendar = {
            var calendar = Calendar(identifier: .iso8601)
            calendar.timeZone = TimeZone(identifier: "GMT")!
            calendar.locale = Locale(identifier: "en_US_POSIX")
            return calendar
        }()
        
        let sut = CalendarDateGenerator(interval: interval, calendar: calendar)
        return sut
    }

}
