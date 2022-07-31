//
//  DayViewModelTests.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 31/07/22.
//

import XCTest
@testable import HabitTrackerSample

enum DateState {
    case today
    case inThePast
    case inTheFuture
}

struct PresentableDayModel {
    let dayOfTheWeek: String
    let dateOfTheMonth: String
    let dateState: DateState
}

final class DayViewModel {
    static func map(
        weekDays: [WeekDay],
        timeZone: TimeZone,
        locale: Locale,
        calendar: Calendar
    ) -> [PresentableDayModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = "dd"
        
        var models = [PresentableDayModel]()
        weekDays.forEach { day in
            let values = mapWeekDay(day.type, calendar: calendar, dateFormatter: dateFormatter)
            models.append(
                PresentableDayModel(
                    dayOfTheWeek: values.dayOfTheWeek,
                    dateOfTheMonth: values.dateOfTheMonth,
                    dateState: values.state
                )
            )
        }
        return models
    }
    
    private static func mapWeekDay(
        _ type: WeekDayType,
        calendar: Calendar,
        dateFormatter: DateFormatter
    ) -> (dayOfTheWeek: String, dateOfTheMonth: String, state: DateState) {
        var dayOfTheWeekString: String
        var dateOfTheMonthString: String
        var dateStateType: DateState
        
        switch type {
        case let .inThePast(date):
            let dayOfTheWeek = calendar.component(.weekday, from: date) - 1
            dayOfTheWeekString = dateFormatter.shortWeekdaySymbols[dayOfTheWeek]
            dateOfTheMonthString = dateFormatter.string(from: date)
            dateStateType = .inThePast
            
        case let .today(date):
            let dayOfTheWeek = calendar.component(.weekday, from: date) - 1
            dayOfTheWeekString = dateFormatter.shortWeekdaySymbols[dayOfTheWeek]
            dateOfTheMonthString = dateFormatter.string(from: date)
            dateStateType = .today
            
        case let .inTheFuture(date):
            let dayOfTheWeek = calendar.component(.weekday, from: date) - 1
            dayOfTheWeekString = dateFormatter.shortWeekdaySymbols[dayOfTheWeek]
            dateOfTheMonthString = dateFormatter.string(from: date)
            dateStateType = .inTheFuture
        }
        
        return (dayOfTheWeekString, dateOfTheMonthString, dateStateType)
    }
}

class DayViewModelTests: XCTestCase {
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
