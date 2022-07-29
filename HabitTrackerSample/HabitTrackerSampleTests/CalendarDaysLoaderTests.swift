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
    private let lastWeek: () -> Date
    
    init(generator: DateGenerator, lastWeek: @escaping () -> Date ) {
        self.generator = generator
        self.lastWeek = lastWeek
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
        let (sut, generator) = makeSUT()
        
        generator.stub(with: [])
        let result = sut.loadDays()
        
        XCTAssertTrue(result.isEmpty)
    }

    func test_loadDays_loadsOneDay() {
        let (sut, generator) = makeSUT()

        generator.stub(with: [Date()])
        let result = sut.loadDays()

        XCTAssertEqual(result.count, 1)
    }
    
    private func makeSUT(
        lastWeek: @escaping () -> Date = Date.init
    ) -> (sut: CalendarDaysLoader, generator: StubDateGenerator) {
        let generator = StubDateGenerator()
        let sut = CalendarDaysLoader(generator: generator, lastWeek: lastWeek)
        return (sut, generator)
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
