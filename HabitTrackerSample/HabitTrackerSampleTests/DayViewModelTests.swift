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
}

struct PresentableDayModel {
    let dayOfTheWeek: String
    let dateOfTheMonth: String
    let dateState: DateState
}

final class DayViewModel {
    static func map(weekDays: [WeekDay]) -> [PresentableDayModel] {
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
            default: break
            }
        }
        return models
    }
}

class DayViewModelTests: XCTestCase {
    func test_map_resultsWithEmptyListOfPresentableModels() {
        let result = DayViewModel.map(weekDays: [])
        
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_map_withWeekDayTodayTypeAndSpecificDate_resultsWithMappedModelWithTodayState() {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        
        let weekDay = WeekDay(type: .today(july18))
        let result = DayViewModel.map(weekDays: [weekDay])
        
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.dayOfTheWeek, "Mon")
        XCTAssertEqual(result.first?.dateOfTheMonth, "18")
        XCTAssertEqual(result.first?.dateState, .today)
    }
}
