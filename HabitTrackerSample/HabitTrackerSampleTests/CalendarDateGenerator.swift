//
//  CalendarDateGenerator.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 31/07/22.
//

import XCTest
@testable import HabitTrackerSample

class CalendarDateGenerator: DateGenerator {
    func generateDates() -> [Date] {
        []
    }
    
    
}

final class CalendarDateGeneratorTests: XCTestCase {
    func test_generateDates_loadsEmptyDates() {
        let sut = CalendarDateGenerator()
        
        let result = sut.generateDates()
        
        XCTAssertEqual(result, [])
    }
}
