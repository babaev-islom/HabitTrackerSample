//
//  CalendarViewControllerTests.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 31/07/22.
//

import XCTest

final class CalendarViewController: UIViewController {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collection
    }()
}

final class CalendarViewControllerTests: XCTestCase {
    func test_viewDidLoad_doesNotRenderDays() {
        let sut = CalendarViewController()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfRenderedDays(), 0)
    }
}

private extension CalendarViewController {
    private var weekDaySection: Int { 0 }
    
    func numberOfRenderedDays() -> Int {
        return collectionView.numberOfItems(inSection: weekDaySection)
    }
}
