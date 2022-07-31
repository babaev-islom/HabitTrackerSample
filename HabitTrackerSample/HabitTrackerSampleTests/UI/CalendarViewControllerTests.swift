//
//  CalendarViewControllerTests.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 31/07/22.
//

import XCTest
@testable import HabitTrackerSample

final class CalendarViewControllerTests: XCTestCase {
    
    func test_viewDidLoad_doesNotRenderDays() {
        let loader = WeekDaysLoaderStub()
        loader.stub(with: [])

        let sut = makeSUT(loader: loader)

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfRenderedDays(), 0)
    }
    
    
    func test_viewDidLoad_withOneCell_rendersOneDay() throws {
        let july19 = Date(timeIntervalSince1970: 1658188800)
        let loader = WeekDaysLoaderStub()
        loader.stub(with: [WeekDay(type: .today(july19))])
        
        let sut = makeSUT(loader: loader)
        sut.loadViewIfNeeded()

        let cell = try XCTUnwrap(sut.cell(at: 0))
        XCTAssertFalse(cell.selectedView.isHidden)
        XCTAssertEqual(cell.dayOfTheWeekLabel.text, "Tue")
        XCTAssertEqual(cell.dateOfTheMonthLabel.text, "19")
    }
    
    private func makeSUT(loader: WeekDaysLoaderStub) -> CalendarViewController {
        return CalendarFactory.makeCalendarViewController(loader: loader)
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
    
    func cell(at index: Int) -> DayCollectionViewCell? {
        let indexPath = IndexPath(item: index, section: weekDaySection)
        let ds = collectionView.dataSource
        return ds?.collectionView(collectionView, cellForItemAt: indexPath) as? DayCollectionViewCell
    }
}
