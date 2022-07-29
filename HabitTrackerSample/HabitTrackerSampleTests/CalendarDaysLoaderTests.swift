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
        let dates = generator.generateDates()
        if let firstDate = dates.first {
            return [WeekDay(type: .today(firstDate))]
        }
        return []
    }
}


final class CalendarDaysLoaderTests: XCTestCase {
    
    func test_loadDays_doesNotLoadDays() {
        let generator = StubDateGenerator()
        let sut = CalendarDaysLoader(generator: generator)
        
        generator.stub(with: [])
        let result = sut.loadDays()
        
        XCTAssertEqual(result, [])
    }

    func test_loadDays_loadsOneDay() {
        let anyDate = Date()
        let expectedDay = WeekDay(type: .today(anyDate))
        let generator = StubDateGenerator()
        let sut = CalendarDaysLoader(generator: generator)
        
        generator.stub(with: [anyDate])
        let result = sut.loadDays()

        XCTAssertEqual(result, [expectedDay])
    }

    
    private class StubDateGenerator: DateGenerator {
        
        private var _stub: [Date]?
        
        func stub(with dates: [Date]) {
            self._stub = dates
        }
        
        func generateDates() -> [Date] {
            guard let stub = _stub else {
                fatalError("Stub the generator before using it. Dev mistake!")
            }
            return stub
        }
    }
    
    
}
