//
//  SectionCellController.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import UIKit

final class SectionCellController: NSObject {
    private let dayCellControllers: [DayCellController]
    
    init(dayCellControllers: [DayCellController]) {
        self.dayCellControllers = dayCellControllers
    }
}

extension SectionCellController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dayCellControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        UICollectionViewCell()
    }
}
extension SectionCellController: UICollectionViewDelegate {}
extension SectionCellController: UICollectionViewDelegateFlowLayout {}
