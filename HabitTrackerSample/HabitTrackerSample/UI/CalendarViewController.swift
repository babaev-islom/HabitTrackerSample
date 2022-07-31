//
//  CalendarViewController.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import UIKit

final class CalendarViewController: UIViewController {
    typealias CellController = UICollectionViewDataSource & UICollectionViewDelegate & UICollectionViewDelegateFlowLayout
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let cellControllers: [CellController]
    private let configureCollection: (UICollectionView) -> Void
    
    init(
        cellControllers: [CellController],
        configureCollection: @escaping (UICollectionView) -> Void
    ) {
        self.cellControllers = cellControllers
        self.configureCollection = configureCollection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollection(collectionView)
    }
}

extension CalendarViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        let numberOfSections = cellControllers.reduce(0) { partialResult, dataSource in
            return partialResult + (dataSource.numberOfSections?(in: collectionView) ?? 1)
        }
        return numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource(forSection: section, in: collectionView).collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dataSource(forSection: indexPath.section, in: collectionView)
            .collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    private func dataSource(forSection section: Int, in collectionView: UICollectionView) -> CellController {
        var sectionCount = 0
        for dataSource in cellControllers {
            sectionCount += dataSource.numberOfSections?(in: collectionView) ?? 1
            if section < sectionCount {
                return dataSource
            }
        }
        fatalError("No data source found for \(section)")
    }
}

extension CalendarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource(forSection: indexPath.section, in: collectionView)
            .collectionView?(collectionView, didSelectItemAt: indexPath)
    }
}
