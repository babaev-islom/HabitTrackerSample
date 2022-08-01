//
//  SceneDelegate.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 29/07/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = TimeZone(identifier: "GMT")!
        return calendar
    }()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
        let today = Date()
        let startOfToday = calendar.startOfDay(for: today)
        let yesterday = calendar.date(byAdding: .day, value: -1, to: startOfToday)!
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!
        let previousWeekMonday = calendar.date(byAdding: .day, value: -7, to: startOfToday)!
        let nextSunday = calendar.date(byAdding: .day, value: 13, to: startOfToday)!
        
        let fullInterval = DateInterval(start: previousWeekMonday, end: nextSunday)
        let dateGenerator = CalendarDateGenerator(interval: { fullInterval }, calendar: calendar)
        
        let intervalInThePast = DateInterval(start: previousWeekMonday, end: yesterday)
        let intervalInTheFuture = DateInterval(start: tomorrow, end: nextSunday)
        let calendarLoader = CalendarDaysLoader(
            generator: dateGenerator,
            intervalInThePast: { intervalInThePast },
            intervalInTheFuture: { intervalInTheFuture },
            today: { startOfToday },
            calendar: calendar
        )
        
        let viewController = CalendarFactory.makeCalendarViewController(loader: calendarLoader)
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = viewController
        self.window?.makeKeyAndVisible()
    }

}

