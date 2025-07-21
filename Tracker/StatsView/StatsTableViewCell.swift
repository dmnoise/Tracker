//
//  StatsTableViewCell.swift
//  Tracker
//
//  Created by Dmitriy Noise on 21.07.2025.
//

import UIKit

final class StatsTableViewCell: UITableViewCell {
    static let identifier = "StatsCell"
    
    // MARK: - UI
    private lazy var rgbBorderView: UIView = {
        let obj = GradientView()
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    private lazy var containerView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .background
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    private lazy var counter: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        obj.textColor = .mainText
        obj.text = "0"
        
        return obj
    }()
    
    private lazy var descriptionCounter: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        obj.textColor = .mainText
        obj.text = "Трекеров завершено"
        
        return obj
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configuration(stats: Stats) {
        counter.text = String(stats.count)
        descriptionCounter.text = stats.description
    }
    
    
    // MARK: - Private methods
    private func setupUI() {
        contentView.addSubviews(rgbBorderView)
        contentView.backgroundColor = .background
        
        rgbBorderView.addSubviews(containerView)
        containerView.addSubviews(counter, descriptionCounter)
        
        NSLayoutConstraint.activate([
            rgbBorderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rgbBorderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rgbBorderView.heightAnchor.constraint(equalToConstant: 90),
            rgbBorderView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            containerView.leadingAnchor.constraint(equalTo: rgbBorderView.leadingAnchor, constant: 1),
            containerView.trailingAnchor.constraint(equalTo: rgbBorderView.trailingAnchor, constant: -1),
            containerView.topAnchor.constraint(equalTo: rgbBorderView.topAnchor, constant: 1),
            containerView.bottomAnchor.constraint(equalTo: rgbBorderView.bottomAnchor, constant: -1),
            
            counter.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            counter.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            counter.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            
            descriptionCounter.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            descriptionCounter.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            descriptionCounter.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
        ])
    }
}
