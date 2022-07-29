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
    private let nextWeekInterval: () -> DateInterval
    private let today: () -> Date
    private let calendar: Calendar
    
    init(
        generator: DateGenerator,
        lastWeekInterval: @escaping () -> DateInterval,
        nextWeekInterval: @escaping () -> DateInterval,
        today: @escaping () -> Date,
        calendar: Calendar
    ) {
        self.generator = generator
        self.lastWeekInterval = lastWeekInterval
        self.nextWeekInterval = nextWeekInterval
        self.today = today
        self.calendar = calendar
    }
    
    func loadDays() -> [WeekDay] {
        var days = [WeekDay]()
        let dates = generator.generateDates()
        dates.forEach { date in
            if isInLastWeekInterval(date) {
                days.append(WeekDay(type: .inThePast(date)))
            } else if isToday(date) {
                days.append(WeekDay(type: .today(date)))
            } else if inNextWeekInterval(date) {
                days.append(WeekDay(type: .inTheFuture(date)))
            }
        }
        return days
    }
    
    private func isInLastWeekInterval(_ date: Date) -> Bool {
        lastWeekInterval().contains(date)
    }
    
    private func inNextWeekInterval(_ date: Date) -> Bool {
        nextWeekInterval().contains(date)
    }
    
    private func isToday(_ date: Date) -> Bool {
        let dayDifferences = calendar.dateComponents([.day], from: date, to: today()).day
        return dayDifferences == 0
    }
}


final class CalendarDaysLoaderTests: XCTestCase {
    
    func test_loadDays_doesNotLoadDays() {
        let (sut, generator) = makeSUT()
        
        generator.stub(with: [])
        let result = sut.loadDays()
        
        XCTAssertTrue(result.isEmpty)
    }

    func test_loadDays_withWeekDateInThePast_loadsWeekDayInThePast() {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        let july19 = Date(timeIntervalSince1970: 1658188800)
        let july20 = Date(timeIntervalSince1970: 1658319564)
        let july24 = Date(timeIntervalSince1970: 1658620800)
        let (sut, generator) = makeSUT(lastWeekInterval: { DateInterval(start: july18, end: july24)})

        generator.stub(with: [july19, july20])
        let result = sut.loadDays()

        XCTAssertEqual(result, [
            WeekDay(type: .inThePast(july19)),
            WeekDay(type: .inThePast(july20))
        ])
    }
    
    func test_loadDays_withWeekDateInTheFuture_loadsWeekDayInTheFuture() {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        let july19 = Date(timeIntervalSince1970: 1658188800)
        let july24 = Date(timeIntervalSince1970: 1658620800)
        let (sut, generator) = makeSUT(nextWeekInterval: { DateInterval(start: july18, end: july24)})


        generator.stub(with: [july19])
        let result = sut.loadDays()

        XCTAssertEqual(result, [
            WeekDay(type: .inTheFuture(july19)),
        ])
    }
    
    func test_loadDays_withTodaysDate_loadsWeekDayWithTodayType() {
        let today = Date(timeIntervalSince1970: 1658188800)
        let todayOneSecondLater = Date(timeIntervalSince1970: 1658188801)
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "GMT")!
        let (sut, generator) = makeSUT(today: { today }, calendar: calendar)

        generator.stub(with: [todayOneSecondLater])
        let result = sut.loadDays()

        XCTAssertEqual(result, [
            WeekDay(type: .today(todayOneSecondLater))
        ])
    }
    
    func test_loadDays_withAllIntervals_loadsAllWeekTypes() {
        let july18 = TimeInterval(1658102400)
        let dateStartInThePast = Date(timeIntervalSince1970: july18)

        let july27 = TimeInterval(1658880000)
        let dateEndInThePast = Date(timeIntervalSince1970: july27)

        let july19 = TimeInterval(1658188800)
        let specificDayInThePast = Date(timeIntervalSince1970: july19)

        let intervalInThePast = DateInterval(start: dateStartInThePast, end: dateEndInThePast)
        
        let july28 = TimeInterval(1658966400)
        let today = Date(timeIntervalSince1970: july28)

        let july29 = TimeInterval(1659052800)
        let dateStartInTheFuture = Date(timeIntervalSince1970: july29)

        let august7 = TimeInterval(1659830400)
        let dateEndInTheFuture = Date(timeIntervalSince1970: august7)

        let august2 = TimeInterval(1659398400)
        let specificDayInTheFuture = Date(timeIntervalSince1970: august2)

        let intervalInTheFuture = DateInterval(start: dateStartInTheFuture, end: dateEndInTheFuture)
        
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "GMT")!

        let (sut, generator) = makeSUT(
            lastWeekInterval: { intervalInThePast },
            nextWeekInterval: { intervalInTheFuture },
            today: { today },
            calendar: calendar
        )

        generator.stub(with: [
            specificDayInThePast,
            specificDayInTheFuture,
            today
        ])
        let result = sut.loadDays()

        XCTAssertEqual(result, [
            WeekDay(type: .inThePast(specificDayInThePast)),
            WeekDay(type: .inTheFuture(specificDayInTheFuture)),
            WeekDay(type: .today(today))
        ])
    }

    private func makeSUT(
        lastWeekInterval: @escaping () -> DateInterval = DateInterval.init,
        nextWeekInterval: @escaping () -> DateInterval = DateInterval.init,
        today: @escaping () -> Date = Date.init,
        calendar: Calendar = Calendar(identifier: .iso8601)
    ) -> (sut: CalendarDaysLoader, generator: StubDateGenerator) {
        let generator = StubDateGenerator()
        let sut = CalendarDaysLoader(
            generator: generator,
            lastWeekInterval: lastWeekInterval,
            nextWeekInterval: nextWeekInterval,
            today: today,
            calendar: calendar
        )
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
