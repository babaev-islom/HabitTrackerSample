//
//  CalendarFactory.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import Foundation

final class CalendarFactory {
    static func makeCalendarViewController(loader: WeekDaysLoader) -> CalendarViewController {
        let days = loader.loadDays()
        let selectedIndex = TodayModelSearchManager.findTodayModel(in: days)
        let adapter = CalendarLoaderAdapter(
            timeZone: TimeZone(identifier: "GMT")!,
            locale: Locale(identifier: "en_US_POSIX"),
            calendar: Calendar(identifier: .gregorian),
            selectedIndex: selectedIndex
        )
        let cellControllers = adapter.mapWeekDays(weekDays: days)
        let controller = CalendarViewController(
            cellControllers: cellControllers,
            configureCollection: { collectionView in
                collectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.reuseIdentifier)
            }
        )
        controller.scrollToCenter = { collectionView in
            let indexPath = IndexPath(item: selectedIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        return controller
    }
}
