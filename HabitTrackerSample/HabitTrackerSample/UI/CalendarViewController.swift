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
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.isPrefetchingEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
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
        
        view.addSubview(collectionView)
        view.backgroundColor = .white
        
        configureCollection(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.heightAnchor.constraint(equalToConstant: 64)
        ])
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
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        dataSource(forSection: indexPath.section, in: collectionView)
            .collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)

    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        dataSource(forSection: indexPath.section, in: collectionView).collectionView?(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath) ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        dataSource(forSection: section, in: collectionView).collectionView?(collectionView, layout: collectionViewLayout, insetForSectionAt: section) ?? .zero
    }
}
