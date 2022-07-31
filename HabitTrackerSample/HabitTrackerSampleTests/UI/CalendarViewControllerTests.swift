//
//  CalendarViewControllerTests.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 31/07/22.
//

import XCTest
@testable import HabitTrackerSample



final class CalendarLoaderAdapter {
    private let timeZone: TimeZone
    private let locale: Locale
    private let calendar: Calendar
    
    init(timeZone: TimeZone, locale: Locale, calendar: Calendar) {
        self.timeZone = timeZone
        self.locale = locale
        self.calendar = calendar
    }

    func mapWeekDays(weekDays: [WeekDay]) -> [SectionCellController] {
        let presentableModels = DayViewModel.map(weekDays: weekDays, timeZone: timeZone, locale: locale, calendar: calendar)
        let cellControllers = presentableModels.map(DayCellController.init)
        return [
            SectionCellController(
                dayCellControllers: cellControllers
            )
        ]
    }
}

final class CalendarFactory {
    static func makeCalendarViewController(loader: WeekDaysLoader) -> CalendarViewController {
        let days = loader.loadDays()
        let adapter = CalendarLoaderAdapter(
            timeZone: TimeZone(identifier: "GMT")!,
            locale: Locale(identifier: "en_US_POSIX"),
            calendar: Calendar(identifier: .gregorian)
        )
        let cellControllers = adapter.mapWeekDays(weekDays: days)
        return CalendarViewController(cellControllers: cellControllers)
    }
}




final class CalendarViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_doesNotRenderDays() {
        let loader = WeekDaysLoaderStub()
        loader.stub(with: [])

        let sut = CalendarFactory.makeCalendarViewController(loader: loader)
            
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfRenderedDays(), 0)
    }
    
    
    func test_viewDidLoad_withOneCell_rendersOneDay() {
        let loader = WeekDaysLoaderStub()
        loader.stub(with: [WeekDay(type: .today(Date()))])
        
        let sut = CalendarFactory.makeCalendarViewController(loader: loader)
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.numberOfRenderedDays(), 1)
    }
    
    
    private class WeekDaysLoaderStub: WeekDaysLoader {
        private var _stub: [WeekDay]?
        func stub(with days: [WeekDay]) {
            self._stub = days
        }
        
        func loadDays() -> [WeekDay] {
            guard let stub = _stub else {
                fatalError("Stub the loader before using")
            }
            
            return stub
        }
    }

}

private extension CalendarViewController {
    private var weekDaySection: Int { 0 }
    
    func numberOfRenderedDays() -> Int {
        return collectionView.numberOfItems(inSection: weekDaySection)
    }
}
