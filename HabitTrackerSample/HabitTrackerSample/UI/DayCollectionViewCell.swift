//
//  DayCollectionViewCell.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import UIKit

final class DayCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: DayCollectionViewCell.self)

    private(set) var selectedView = UIView()
    private(set) var dayOfTheWeekLabel = UILabel()
    private(set) var dateOfTheMonthLabel = UILabel()
}
