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
        if let firstWeekDay = weekDays.first {
            switch firstWeekDay.type {
            case .today:
                models.append(
                    PresentableDayModel(
                        dayOfTheWeek: "Mon",
                        dateOfTheMonth: "18",
                        dateState: .today
                    )
                )
            case let .inThePast(date):
                let dayOfTheWeek = calendar.component(.weekday, from: date) - 1
                let dayOfTheWeekString = dateFormatter.shortWeekdaySymbols[dayOfTheWeek]
                let dayOfTheMonth = dateFormatter.string(from: date)

                models.append(
                    PresentableDayModel(
                        dayOfTheWeek: dayOfTheWeekString,
                        dateOfTheMonth: dayOfTheMonth,
                        dateState: .inThePast
                    )
                )
            default: break
            }
        }
        return models
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
}
