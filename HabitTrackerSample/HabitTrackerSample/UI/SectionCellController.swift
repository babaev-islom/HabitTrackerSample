//
//  SectionCellController.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import UIKit

final class SectionCellController: NSObject {
    private var currentCellIndex: Int
    private var previousCellIndex: Int?

    private let dayCellControllers: [DayCellController]
    
    init(
        dayCellControllers: [DayCellController],
        selectedCellIndex: Int
    ) {
        self.dayCellControllers = dayCellControllers
        self.currentCellIndex = selectedCellIndex
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

extension SectionCellController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        previousCellIndex = currentCellIndex
        currentCellIndex = indexPath.item
        
        if let previousIndex = previousCellIndex {
            dayCellControllers[previousIndex].deselect()
        }
        
        dayCellControllers[currentCellIndex].select()
    }
}

extension SectionCellController: UICollectionViewDelegateFlowLayout {}
