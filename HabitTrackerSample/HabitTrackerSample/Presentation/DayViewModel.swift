//
//  DayViewModel.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import Foundation

final class DayViewModel {
    
    private init() {}
    
    static func map(
        weekDays: [WeekDay],
        timeZone: TimeZone,
        locale: Locale,
        calendar: Calendar
    ) -> [PresentableDayModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        dateFormatter.calendar = calendar
        dateFormatter.dateFormat = "dd"
        
        var models = [PresentableDayModel]()
        weekDays.forEach { day in
            let values = mapWeekDay(day.type, calendar: calendar, dateFormatter: dateFormatter)
            models.append(
                PresentableDayModel(
                    dayOfTheWeek: values.dayOfTheWeek,
                    dateOfTheMonth: values.dateOfTheMonth,
                    dateState: values.state
                )
            )
        }
        return models
    }
    
    private static func mapWeekDay(
        _ type: WeekDayType,
        calendar: Calendar,
        dateFormatter: DateFormatter
    ) -> (dayOfTheWeek: String, dateOfTheMonth: String, state: DateState) {
        var dayOfTheWeekString: String
        var dateOfTheMonthString: String
        var dateStateType: DateState
        
        switch type {
        case let .inThePast(date):
            let dayOfTheWeek = calendar.component(.weekday, from: date) - 1
            dayOfTheWeekString = dateFormatter.shortWeekdaySymbols[dayOfTheWeek]
            dateOfTheMonthString = dateFormatter.string(from: date)
            dateStateType = .inThePast
            
        case let .today(date):
            let dayOfTheWeek = calendar.component(.weekday, from: date) - 1
            dayOfTheWeekString = dateFormatter.shortWeekdaySymbols[dayOfTheWeek]
            dateOfTheMonthString = dateFormatter.string(from: date)
            dateStateType = .today
            
        case let .inTheFuture(date):
            let dayOfTheWeek = calendar.component(.weekday, from: date) - 1
            dayOfTheWeekString = dateFormatter.shortWeekdaySymbols[dayOfTheWeek]
            dateOfTheMonthString = dateFormatter.string(from: date)
            dateStateType = .inTheFuture
        }
        
        return (dayOfTheWeekString, dateOfTheMonthString, dateStateType)
    }
}
