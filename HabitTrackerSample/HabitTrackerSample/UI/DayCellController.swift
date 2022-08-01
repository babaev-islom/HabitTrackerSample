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
        switch model.dateState {
        case .inThePast:
            cell?.dayOfTheWeekLabel.textColor = .black
            cell?.dateOfTheMonthLabel.textColor = .black
        case .today:
            cell?.dayOfTheWeekLabel.textColor = .blue
            cell?.dateOfTheMonthLabel.textColor = .blue
        case .inTheFuture:
            cell?.dayOfTheWeekLabel.textColor = .lightGray
            cell?.dateOfTheMonthLabel.textColor = .lightGray
        }
        return cell!
    }
    
    func select() {
        cell?.selectedView.isHidden = false
    }
    
    func deselect() {
        cell?.selectedView.isHidden = true
    }
    
    func reuse() {
        cell = nil
    }
}
