//
//  CalendarViewControllerTests.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 31/07/22.
//

import XCTest
@testable import HabitTrackerSample

final class CalendarFactory {
    static func makeCalendarViewController(loader: WeekDaysLoader) -> CalendarViewController {
        return CalendarViewController(cellControllers: [])
    }
}

final class CalendarViewController: UIViewController {
    typealias CellController = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
    
    private let cellControllers: [CellController]
    
    init(cellControllers: [CellController]) {
        self.cellControllers = cellControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class CalendarViewControllerTests: XCTestCase {
    func test_viewDidLoad_doesNotRenderDays() {
        let stub = WeekDaysLoaderStub()
        let sut = CalendarFactory.makeCalendarViewController(loader: stub)
            
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfRenderedDays(), 0)
    }
    
    
    private class WeekDaysLoaderStub: WeekDaysLoader {
        func loadDays() -> [WeekDay] {
            []
        }
    }

}

private extension CalendarViewController {
    private var weekDaySection: Int { 0 }
    
    func numberOfRenderedDays() -> Int {
        return collectionView.numberOfItems(inSection: weekDaySection)
    }
}
