//
//  DayCellController.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import Foundation
import UIKit

final class DayCellController {
    private var cell: DayCollectionViewCell?
    private let model: PresentableDayModel
    
    init(model: PresentableDayModel) {
        self.model = model
    }
    
    func dequeueCell(in collectionView: UICollectionView, for indexPath: IndexPath) -> DayCollectionViewCell {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionViewCell.reuseIdentifier, for: indexPath) as? DayCollectionViewCell
        cell?.dayOfTheWeekLabel.text = model.dayOfTheWeek
        cell?.dateOfTheMonthLabel.text = model.dateOfTheMonth
        cell?.selectedView.isHidden = model.dateState != .today
        return cell!
    }
    
    func select() {
        cell?.selectedView.isHidden = false
    }
    
    func deselect() {
        cell?.selectedView.isHidden = true
    }
}
