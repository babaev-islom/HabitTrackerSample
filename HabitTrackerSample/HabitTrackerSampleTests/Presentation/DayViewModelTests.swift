//
//  DayViewModelTests.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 31/07/22.
//

import XCTest
@testable import HabitTrackerSample

final class DayViewModelTests: XCTestCase {
    private let timeZone = TimeZone(identifier: "GMT")!
    private let locale = Locale(identifier: "en_US_POSIX")
    private let calendar = Calendar(identifier: .gregorian)
    
    func test_map_resultsWithEmptyListOfPresentableModels() {
        let result = DayViewModel.map(weekDays: [], timeZone: timeZone, locale: locale, calendar: calendar)
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_map_withWeekDayTodayTypeAndSpecificDate_resultsWithMappedModelWithTodayState() {
        let july18 = Date(timeIntervalSince1970: 1658102400)

        let weekDay = WeekDay(type: .today(july18))
        let result = DayViewModel.map(
            weekDays: [weekDay],
            timeZone: timeZone,
            locale: locale,
            calendar: calendar
        )

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.dayOfTheWeek, "Mon")
        XCTAssertEqual(result.first?.dateOfTheMonth, "18")
        XCTAssertEqual(result.first?.dateState, .today)
    }

    func test_map_withWeekDayInThePastTypeAndSpecificDate_resultsWithMappedModelWithInThePastState() {
        let july19 = Date(timeIntervalSince1970: 1658188800)

        let weekDay = WeekDay(type: .inThePast(july19))
        let result = DayViewModel.map(
            weekDays: [weekDay],
            timeZone: timeZone,
            locale: locale,
            calendar: calendar
        )

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.dayOfTheWeek, "Tue")
        XCTAssertEqual(result.first?.dateOfTheMonth, "19")
        XCTAssertEqual(result.first?.dateState, .inThePast)
    }
    
    func test_map_threeWeekDays_resultsInThreePresentableModels() {
        let july19 = Date(timeIntervalSince1970: 1658188800)
        let july20 = Date(timeIntervalSince1970: 1658275200)
        let july21 = Date(timeIntervalSince1970: 1658361600)

        let weekDayToday = WeekDay(type: .today(july19))
        let weekDayInThePast = WeekDay(type: .inThePast(july20))
        let weekDayInTheFuture = WeekDay(type: .inTheFuture(july21))

        let result = DayViewModel.map(
            weekDays: [
                weekDayToday,
                weekDayInThePast,
                weekDayInTheFuture
            ],
            timeZone: timeZone,
            locale: locale,
            calendar: calendar
        )

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0].dayOfTheWeek, "Tue", "Expected July 19 to be Tuesday")
        XCTAssertEqual(result[0].dateOfTheMonth, "19", "Expected July 19 Date to be mapped into 19")
        XCTAssertEqual(result[0].dateState, .today, "Expected today type")
        
        XCTAssertEqual(result[1].dayOfTheWeek, "Wed", "Expected July 20 to be Wednesday")
        XCTAssertEqual(result[1].dateOfTheMonth, "20", "Expected July 20 Date to be mapped into 20")
        XCTAssertEqual(result[1].dateState, .inThePast, "Expected inThePast type")
        
        XCTAssertEqual(result[2].dayOfTheWeek, "Thu", "Expected July 21 to be Thursday")
        XCTAssertEqual(result[2].dateOfTheMonth, "21", "Expected July 21 to be mapped into 21")
        XCTAssertEqual(result[2].dateState, .inTheFuture, "Expected inTheFuture type")
    }
}
