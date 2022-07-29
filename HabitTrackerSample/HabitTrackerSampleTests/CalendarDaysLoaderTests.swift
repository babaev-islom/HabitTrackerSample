//
//  CalendarDaysLoaderTests.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 29/07/22.
//

import XCTest
@testable import HabitTrackerSample

protocol DateGenerator {
    func generateDates() -> [Date]
}

final class CalendarDaysLoader: WeekDaysLoader {
    
    private let generator: DateGenerator
    
    init(generator: DateGenerator) {
        self.generator = generator
    }
    
    func loadDays() -> [WeekDay] {
        []
    }
}


final class CalendarDaysLoaderTests: XCTestCase {
    
    func test_loadDays_doesNotLoadDays() {
        let generator = StubDateGenerator()
        let sut = CalendarDaysLoader(generator: generator)
        
        let result = sut.loadDays()
        
        XCTAssertEqual(result, [])
    }
    
    private class StubDateGenerator: DateGenerator {
        func generateDates() -> [Date] {
            []
        }
    }
    
    
}
