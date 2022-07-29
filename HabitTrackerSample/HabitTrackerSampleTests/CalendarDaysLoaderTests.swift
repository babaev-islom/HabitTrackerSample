//
//  CalendarDaysLoaderTests.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 29/07/22.
//

import XCTest
@testable import HabitTrackerSample

final class CalendarDaysLoader: WeekDaysLoader {
    func loadDays() -> [WeekDay] {
        []
    }
}


final class CalendarDaysLoaderTests: XCTestCase {
    
    func test_loadDays_doesNotLoadDays() {
        let sut = CalendarDaysLoader()
        
        let result = sut.loadDays()
        
        XCTAssertEqual(result, [])
    }
    
}
