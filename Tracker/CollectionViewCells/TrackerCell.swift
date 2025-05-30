//
//  TrackerCell.swift
//  Tracker
//
//  Created by Dmitriy Noise on 27.05.2025.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapCompletedButton(_ cell: TrackerCell, isCompleted: Bool)
}

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    static let identifier = "TrackerCell"
    
    //MARK: - UI
    private let cardView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .cGreen
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    private let emojiLabel: UILabel = {
        let obj = UILabel()
        obj.text = "🙂"
        obj.font = UIFont.systemFont(ofSize: 12)
        obj.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.3)
        obj.layer.cornerRadius = 12
        obj.layer.masksToBounds = true
        obj.textAlignment = .center
        
        return obj
    }()
    
    private let textLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 12)
        obj.textColor = .white
        obj.numberOfLines = 2
        obj.lineBreakMode = .byWordWrapping
        
        return obj
    }()
    
    private let counterDaysLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = UIFont.systemFont(ofSize: 12)
        obj.text = "0 дней"
        
        return obj
    }()
    
    private let addButton: UIButton = {
        let obj = UIButton()
        obj.layer.cornerRadius = 17
        obj.clipsToBounds = true
        obj.setImage(UIImage(systemName: "plus"), for: .normal)
        obj.backgroundColor = .cGreen
        obj.tintColor = .white
        
        return obj
    }()
    
    private(set) var trackerID: UUID?
    private var isCompleted = false
    private var countDays: Int = 0 {
        didSet {
            counterDaysLabel.text = "\(countDays) дней"
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupConstraint()
    }
    
    // MARK: - Public Methods
    func configure(tracker: Tracker, isCompletedToday: Bool, countDays: Int) {
        trackerID = tracker.id
        emojiLabel.text = tracker.emoji
        textLabel.text = tracker.name
        cardView.backgroundColor = tracker.color
        addButton.backgroundColor = tracker.color
       
        counterDaysLabel.text = "\(countDays) дней"
        isCompleted = isCompletedToday
        
        self.countDays = countDays
        
        updateCompletedButtonStatus()
    }
    
    func changeCompletedButtonStatus() {
        isCompleted.toggle()
        updateCompletedButtonStatus()
        
        if isCompleted {
            countDays += 1
        } else {
            countDays -= 1
        }
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear
        contentView.addSubviews(cardView, counterDaysLabel, addButton)
        
        cardView.addSubviews(emojiLabel, textLabel)
        
        addButton.addTarget(self, action: #selector(didTapCompledetButton), for: .touchUpInside)
    }
    private func updateCompletedButtonStatus() {
        
        let imageName = isCompleted ? "checkmark" : "plus"
        let opacity: Float = isCompleted ? 0.3 : 1.0
        
        addButton.setImage(UIImage(systemName: imageName), for: .normal)
        addButton.layer.opacity = opacity
    }
    
    @objc private func didTapCompledetButton() {
      
        delegate?.didTapCompletedButton(self, isCompleted: !isCompleted)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            
            textLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            textLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            addButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            addButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalToConstant: 34),
            
            counterDaysLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            counterDaysLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),
            counterDaysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16 )
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
