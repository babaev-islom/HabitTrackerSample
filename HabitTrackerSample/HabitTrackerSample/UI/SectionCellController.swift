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
        let controller = dayCellControllers[indexPath.item]
        let cell = controller.dequeueCell(in: collectionView, for: indexPath)

        if currentCellIndex == indexPath.item {
            controller.select()
        }
        
        return cell
    }
}

extension SectionCellController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentCellIndex != previousCellIndex {
            previousCellIndex = currentCellIndex
        } else {
            if let previousIndex = previousCellIndex {
                dayCellControllers[previousIndex].deselect()
            }
            previousCellIndex = nil
        }
//        previousCellIndex = currentCellIndex
        currentCellIndex = indexPath.item
        
        if let previousIndex = previousCellIndex {
            dayCellControllers[previousIndex].deselect()
        }
        
        dayCellControllers[currentCellIndex].select()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dayCellControllers[indexPath.item].reuse()
    }
}

extension SectionCellController: UICollectionViewDelegateFlowLayout {}
