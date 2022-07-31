//
//  DayViewModelTests.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 31/07/22.
//

import XCTest
@testable import HabitTrackerSample

struct PresentableDayModel {
    
}

final class DayViewModel {
    static func map(weekDays: [WeekDay]) -> [PresentableDayModel] {
        []
    }
}

class DayViewModelTests: XCTestCase {
    func test_map_resultsWithEmptyListOfPresentableModels() {
        let result = DayViewModel.map(weekDays: [])
        
        XCTAssertTrue(result.isEmpty)
    }
}
