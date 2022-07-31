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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dayCellControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return dayCellControllers[indexPath.item].dequeueCell(in: collectionView, for: indexPath)
    }
}
extension SectionCellController: UICollectionViewDelegate {}
extension SectionCellController: UICollectionViewDelegateFlowLayout {}
