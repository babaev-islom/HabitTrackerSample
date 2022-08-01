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
        XCTAssertTrue(cell.isViewSelected)
        XCTAssertEqual(cell.dayText, "Tue")
        XCTAssertEqual(cell.dateText, "19")
    }
    
    func test_viewDidLoad_withTwoCells_rendersTwoDays() throws {
        let july18 = Date(timeIntervalSince1970: 1658102400)
        let july19 = Date(timeIntervalSince1970: 1658188800)
        
        let loader = WeekDaysLoaderStub()
        loader.stub(with: [
            WeekDay(type: .inThePast(july18)),
            WeekDay(type: .today(july19))]
        )
        
        let sut = makeSUT(loader: loader)
        sut.loadViewIfNeeded()

        let cell1 = try XCTUnwrap(sut.cell(at: 0))
        XCTAssertFalse(cell1.isViewSelected)
        XCTAssertEqual(cell1.dayText, "Mon")
        XCTAssertEqual(cell1.dateText, "18")

        let cell2 = try XCTUnwrap(sut.cell(at: 1))
        XCTAssertTrue(cell2.isViewSelected)
        XCTAssertEqual(cell2.dayText, "Tue")
        XCTAssertEqual(cell2.dateText, "19")
    }
    
    func test_cellSelection_withThreeCells_setsLastCellAsSelected() throws {
        let loader = WeekDaysLoaderStub()
        loader.stub(with: [
            WeekDay(type: .inThePast(Date())),
            WeekDay(type: .today(Date())),
            WeekDay(type: .inTheFuture(Date()))
        ])
        
        let sut = makeSUT(loader: loader)
        sut.loadViewIfNeeded()
        
        let cell1 = try XCTUnwrap(sut.cell(at: 0))
        let cell2 = try XCTUnwrap(sut.cell(at: 1))
        let cell3 = try XCTUnwrap(sut.cell(at: 2))

        XCTAssertFalse(cell1.isViewSelected, "Should be deselected since it has inThePast type")
        XCTAssertTrue(cell2.isViewSelected, "Should be selected since it has today type")
        XCTAssertFalse(cell3.isViewSelected, "Should be deselected since it has inTheFuture type")
        
        sut.selectCell(at: 0)
        XCTAssertTrue(cell1.isViewSelected, "Should become selected after it was selected")
        XCTAssertFalse(cell2.isViewSelected, "Should become deselected after 1st cell was selected")
        XCTAssertFalse(cell3.isViewSelected, "Selection state should not have changed after 1st cell was selected")
    }
    
    func test_cellSelectionOfAlreadySelectedCell_withThreeCells_doesNotSelectOtherCells() throws {
        let loader = WeekDaysLoaderStub()
        loader.stub(with: [
            WeekDay(type: .inThePast(Date())),
            WeekDay(type: .today(Date())),
            WeekDay(type: .inTheFuture(Date()))
        ])
        
        let sut = makeSUT(loader: loader)
        sut.loadViewIfNeeded()
        
        let cell1 = try XCTUnwrap(sut.cell(at: 0))
        let cell2 = try XCTUnwrap(sut.cell(at: 1))
        let cell3 = try XCTUnwrap(sut.cell(at: 2))

        XCTAssertFalse(cell1.isViewSelected, "Should be deselected since it has inThePast type")
        XCTAssertTrue(cell2.isViewSelected, "Should be selected since it has today type")
        XCTAssertFalse(cell3.isViewSelected, "Should be deselected since it has inTheFuture type")
        
        sut.selectCell(at: 1)
        XCTAssertFalse(cell1.isViewSelected, "Should not change selection state after 1st cell was selected")
        XCTAssertTrue(cell2.isViewSelected, "Should not change cell selection even though it was already selected")
        XCTAssertFalse(cell3.isViewSelected, "Should not change selection state after 1st cell was selected")
        
        sut.selectCell(at: 0)
        XCTAssertTrue(cell1.isViewSelected, "Should be set as selected after selecting it")
        XCTAssertFalse(cell2.isViewSelected, "Should be deselected after selecting 1st cell")
        XCTAssertFalse(cell3.isViewSelected, "Should not change selection state after 0st cell was selected")
    }
    
    func test_cellSelection_withThreeCells_rendersSelectedCellAppropriatelyAfterReuse() throws {
        let loader = WeekDaysLoaderStub()
        loader.stub(with: [
            WeekDay(type: .inThePast(Date())),
            WeekDay(type: .today(Date())),
            WeekDay(type: .inTheFuture(Date())),
        ])
        
        let sut = makeSUT(loader: loader)
        sut.loadViewIfNeeded()
        
        let cell1 = try XCTUnwrap(sut.cell(at: 0))
        let cell2 = try XCTUnwrap(sut.cell(at: 1))
        let cell3 = try XCTUnwrap(sut.cell(at: 2))
       
        XCTAssertFalse(cell1.isViewSelected, "Should be deselected since it has inThePast type")
        XCTAssertTrue(cell2.isViewSelected, "Should be selected since it has today type")
        XCTAssertFalse(cell3.isViewSelected, "Should be deselected since it has inTheFuture type")
        
        sut.selectCell(at: 0)
        XCTAssertTrue(cell1.isViewSelected, "Should be set as selected after selecting it")
        XCTAssertFalse(cell2.isViewSelected, "Should be deselected after selecting 1st cell")
        XCTAssertFalse(cell3.isViewSelected, "Should not change selection state after 0st cell was selected")
        
        sut.simulateCellNotVisible(at: 1, cell: cell2)
        
        let cell4 = try XCTUnwrap(sut.cell(at: 1))
        XCTAssertFalse(cell4.isViewSelected, "Should not be selected since 0st cell was selected and 1st cell was reused")
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
