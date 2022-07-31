//
//  CalendarFactory.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import Foundation

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
                dayCellControllers: cellControllers,
                selectedCellIndex: findTodayModel(in: presentableModels)
            )
        ]
    }
    
    private func findTodayModel(in models: [PresentableDayModel]) -> Int {
        var selectedIndex = 0
        models.enumerated().forEach { index, model in
            if model.dateState == .today { selectedIndex = index }
        }
        return selectedIndex
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
        let controller = CalendarViewController(
            cellControllers: cellControllers,
            configureCollection: { collectionView in
                collectionView.register(DayCollectionViewCell.self, forCellWithReuseIdentifier: DayCollectionViewCell.reuseIdentifier)
            }
        )
        return controller
    }
}
