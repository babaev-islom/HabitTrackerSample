//
//  DayCollectionViewCell+TestHelpers.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 01/08/22.
//

import UIKit
@testable import HabitTrackerSample

extension DayCollectionViewCell {
   var isViewSelected: Bool {
       selectedView.isHidden == false
   }
   
   var dayText: String? {
       dayOfTheWeekLabel.text
   }
   
   var dateText: String? {
       dateOfTheMonthLabel.text
   }
}
