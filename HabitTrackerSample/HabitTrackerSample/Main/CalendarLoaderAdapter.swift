//
//  CalendarLoaderAdapter.swift
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
                selectedCellIndex: TodayModelSearchManager.findTodayModel(in: weekDays)
            )
        ]
    }
}
