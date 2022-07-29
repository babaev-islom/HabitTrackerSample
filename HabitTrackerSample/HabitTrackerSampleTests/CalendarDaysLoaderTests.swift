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
    private let lastWeekInterval: () -> DateInterval
    
    init(generator: DateGenerator, lastWeekInterval: @escaping () -> DateInterval) {
        self.generator = generator
        self.lastWeekInterval = lastWeekInterval
    }
    
    func loadDays() -> [WeekDay] {
        var days = [WeekDay]()
        let dates = generator.generateDates()
        dates.forEach { date in
            if lastWeekInterval().contains(date) {
                days.append(WeekDay(type: .pastWeek(date)))
            }
        }
        return days
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
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "GMT")!

        let today = Date()
        let yesterday = calendar.date(byAdding: .day, value: -1, to: today)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        let (sut, generator) = makeSUT(lastWeekInterval: {
            DateInterval(start: yesterday, end: tomorrow)
        })

        generator.stub(with: [today])
        let result = sut.loadDays()

        XCTAssertEqual(result.count, 1)
    }
    
    func test_loadDays_withLastWeekDate_loadsWeekDayWithPastWeekType() {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        let july19 = Date(timeIntervalSince1970: 1658188800)
        let july20 = Date(timeIntervalSince1970: 1658319564)
        let july24 = Date(timeIntervalSince1970: 1658620800)
        let (sut, generator) = makeSUT(lastWeekInterval: { DateInterval(start: july18, end: july24)})

        generator.stub(with: [july19, july20])
        let result = sut.loadDays()

        XCTAssertEqual(result, [
            WeekDay(type: .pastWeek(july19)),
            WeekDay(type: .pastWeek(july20))
        ])
    }
    
    private func makeSUT(
        lastWeekInterval: @escaping () -> DateInterval = DateInterval.init
    ) -> (sut: CalendarDaysLoader, generator: StubDateGenerator) {
        let generator = StubDateGenerator()
        let sut = CalendarDaysLoader(generator: generator, lastWeekInterval: lastWeekInterval)
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
