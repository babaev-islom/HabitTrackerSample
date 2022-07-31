//
//  DayCollectionViewCell.swift
//  HabitTrackerSample
//
//  Created by Islom Babaev on 31/07/22.
//

import UIKit

final class DayCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: DayCollectionViewCell.self)

    private(set) var selectedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.cornerRadius = 8
        view.isHidden = true
        return view
    }()
    
    private(set) var dayOfTheWeekLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private(set) var dateOfTheMonthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private(set) var progressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 3
        return view
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(dayOfTheWeekLabel)
        contentView.addSubview(dateOfTheMonthLabel)
        contentView.addSubview(progressView)
        contentView.addSubview(selectedView)
        
        NSLayoutConstraint.activate([
            dayOfTheWeekLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            dayOfTheWeekLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dayOfTheWeekLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            dateOfTheMonthLabel.topAnchor.constraint(equalTo: dayOfTheWeekLabel.bottomAnchor, constant: 4),
            dateOfTheMonthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            dateOfTheMonthLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: dateOfTheMonthLabel.bottomAnchor, constant: 4),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            progressView.heightAnchor.constraint(equalToConstant: 6),
            progressView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            selectedView.topAnchor.constraint(equalTo: contentView.topAnchor),
            selectedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            selectedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 6)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        dayOfTheWeekLabel.text = nil
        dateOfTheMonthLabel.text = nil
        selectedView.isHidden = true
    }
}
