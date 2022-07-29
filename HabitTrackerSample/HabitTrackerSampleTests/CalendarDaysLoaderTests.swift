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
    private let thisWeekInterval: () -> DateInterval
    private let nextWeekInterval: () -> DateInterval
    private let today: () -> Date
    private let calendar: Calendar
    
    init(
        generator: DateGenerator,
        lastWeekInterval: @escaping () -> DateInterval,
        thisWeekInterval: @escaping () -> DateInterval,
        nextWeekInterval: @escaping () -> DateInterval,
        today: @escaping () -> Date,
        calendar: Calendar
    ) {
        self.generator = generator
        self.lastWeekInterval = lastWeekInterval
        self.thisWeekInterval = thisWeekInterval
        self.nextWeekInterval = nextWeekInterval
        self.today = today
        self.calendar = calendar
    }
    
    func loadDays() -> [WeekDay] {
        var days = [WeekDay]()
        let dates = generator.generateDates()
        dates.forEach { date in
            if isInLastWeekInterval(date) {
                days.append(WeekDay(type: .pastWeek(date)))
            } else if isToday(date) {
                days.append(WeekDay(type: .today(date)))
            } else if inThisWeekInterval(date) {
                days.append(WeekDay(type: .thisWeek(date)))
            } else if inNextWeekInterval(date) {
                days.append(WeekDay(type: .nextWeek(date)))
            }
        }
        return days
    }
    
    private func isInLastWeekInterval(_ date: Date) -> Bool {
        lastWeekInterval().contains(date)
    }
    
    private func inThisWeekInterval(_ date: Date) -> Bool {
        thisWeekInterval().contains(date)
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
    
    func test_loadDays_withThisWeekDate_loadsWeekDayWithThisWeekType() {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        let july19 = Date(timeIntervalSince1970: 1658188800)
        let july24 = Date(timeIntervalSince1970: 1658620800)
        let (sut, generator) = makeSUT(thisWeekInterval: { DateInterval(start: july18, end: july24)})


        generator.stub(with: [july19])
        let result = sut.loadDays()

        XCTAssertEqual(result, [
            WeekDay(type: .thisWeek(july19)),
        ])
    }
    
    func test_loadDays_withNextWeekDate_loadsWeekDayWithNextWeekType() {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        let july19 = Date(timeIntervalSince1970: 1658188800)
        let july24 = Date(timeIntervalSince1970: 1658620800)
        let (sut, generator) = makeSUT(nextWeekInterval: { DateInterval(start: july18, end: july24)})


        generator.stub(with: [july19])
        let result = sut.loadDays()

        XCTAssertEqual(result, [
            WeekDay(type: .nextWeek(july19)),
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
        let july24 = TimeInterval(1658620800)
        let july19 = TimeInterval(1658188800)
        
        let previousWeekMonday = Date(timeIntervalSince1970: july18)
        let previousWeekSunday = Date(timeIntervalSince1970: july24)
        let specificDayInPreviousWeek = Date(timeIntervalSince1970: july19)
        let previousWeekInterval = DateInterval(start: previousWeekMonday, end: previousWeekSunday)
        
        let july25 = TimeInterval(1658707200)
        let july31 = TimeInterval(1659225600)
        let july29 = TimeInterval(1659052800)

        let thisWeekMonday = Date(timeIntervalSince1970: july25)
        let thisWeekSunday = Date(timeIntervalSince1970: july31)
        let specificDayInThisWeek = Date(timeIntervalSince1970: july29)
        let thisWeekInterval = DateInterval(start: thisWeekMonday, end: thisWeekSunday)
        
        let august1 = TimeInterval(1659312000)
        let august7 = TimeInterval(1659830400)
        let august2 = TimeInterval(1659398400)

        let nextWeekStart = Date(timeIntervalSince1970: august1)
        let nextWeekEnd = Date(timeIntervalSince1970: august7)
        let specificDayInNextWeek = Date(timeIntervalSince1970: august2)
        let nextWeekInterval = DateInterval(start: nextWeekStart, end: nextWeekEnd)
        
        let july28 = TimeInterval(1658966400)
        let today = Date(timeIntervalSince1970: july28)
        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "GMT")!
        
        let (sut, generator) = makeSUT(
            lastWeekInterval: { previousWeekInterval },
            thisWeekInterval: { thisWeekInterval },
            nextWeekInterval: { nextWeekInterval },
            today: { today },
            calendar: calendar
        )

        generator.stub(with: [
            specificDayInPreviousWeek,
            specificDayInThisWeek,
            specificDayInNextWeek,
            today
        ])
        let result = sut.loadDays()

        XCTAssertEqual(result, [
            WeekDay(type: .pastWeek(specificDayInPreviousWeek)),
            WeekDay(type: .thisWeek(specificDayInThisWeek)),
            WeekDay(type: .nextWeek(specificDayInNextWeek)),
            WeekDay(type: .today(today))
        ])
    }
    
    private func makeSUT(
        lastWeekInterval: @escaping () -> DateInterval = DateInterval.init,
        thisWeekInterval: @escaping () -> DateInterval = DateInterval.init,
        nextWeekInterval: @escaping () -> DateInterval = DateInterval.init,
        today: @escaping () -> Date = Date.init,
        calendar: Calendar = Calendar(identifier: .iso8601)
    ) -> (sut: CalendarDaysLoader, generator: StubDateGenerator) {
        let generator = StubDateGenerator()
        let sut = CalendarDaysLoader(
            generator: generator,
            lastWeekInterval: lastWeekInterval,
            thisWeekInterval: thisWeekInterval,
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
