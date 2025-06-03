//
//  WeekdaySwitchCell.swift
//  Tracker
//
//  Created by Dmitriy Noise on 01.06.2025.
//

import UIKit

class WeekdaySwitchCell: UITableViewCell {
    
    static let identifier = "WeekdaySwitchCell"
    
    private var currentWeekday: Weekday?
    var onToggle: ((Weekday, Bool) -> Void)?
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 17)
        
        return obj
    }()
    
    private let toggleSwitch: UISwitch = {
        let obj = UISwitch()
        obj.onTintColor = .cBlue
        
        return obj
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupСell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Public Methods
    func configure(weekday: Weekday, isOn: Bool) {
        currentWeekday = weekday
        titleLabel.text = weekday.name
        toggleSwitch.isOn = isOn
    }
    
    // MARK: - Private methods
    private func setupСell() {
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubviews(titleLabel, toggleSwitch)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        toggleSwitch.addTarget(self, action: #selector(weekdaySelected(_:)), for: .valueChanged)
    }
    
    // MARK: - objc
    @objc private func weekdaySelected(_ sender: UISwitch) {

        guard let weekday = currentWeekday else { return }
        onToggle?(weekday, sender.isOn)
    }
}
