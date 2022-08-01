//
//  CalendarViewController+TestHelpers.swift
//  HabitTrackerSampleTests
//
//  Created by Islom Babaev on 01/08/22.
//

import UIKit
@testable import HabitTrackerSample

extension CalendarViewController {
   private var weekDaySection: Int { 0 }
   
   func numberOfRenderedDays() -> Int {
       return collectionView.numberOfItems(inSection: weekDaySection)
   }
   
   func cell(at index: Int) -> DayCollectionViewCell? {
       let indexPath = IndexPath(item: index, section: weekDaySection)
       let ds = collectionView.dataSource
       return ds?.collectionView(collectionView, cellForItemAt: indexPath) as? DayCollectionViewCell
   }
   
   func selectCell(at index: Int) {
       let indexPath = IndexPath(item: index, section: weekDaySection)
       let dl = collectionView.delegate
       dl?.collectionView?(collectionView, didSelectItemAt: indexPath)
   }
   
   func simulateCellNotVisible(at index: Int, cell: UICollectionViewCell) {
       let indexPath = IndexPath(item: index, section: weekDaySection)
       let dl = collectionView.delegate
       dl?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
   }
}
