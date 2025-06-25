//
//  TrackerCell.swift
//  Tracker
//
//  Created by Dmitriy Noise on 27.05.2025.
//

import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapCompletedButton(at indexPath: IndexPath, isCompleted: Bool)
}

final class TrackerCell: UICollectionViewCell {
    
    weak var delegate: TrackerCellDelegate?
    
    static let identifier = "TrackerCell"
    
    //MARK: - UI
    private lazy var cardView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .cGreen
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    private lazy var emojiLabel: UILabel = {
        let obj = UILabel()
        obj.text = "🙂"
        obj.font = UIFont.systemFont(ofSize: 12)
        obj.backgroundColor = UIColor(ciColor: .white).withAlphaComponent(0.3)
        obj.layer.cornerRadius = 12
        obj.layer.masksToBounds = true
        obj.textAlignment = .center
        
        return obj
    }()
    
    private lazy var textLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 12)
        obj.textColor = .white
        obj.numberOfLines = 2
        obj.lineBreakMode = .byWordWrapping
        
        return obj
    }()
    
    private lazy var counterDaysLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .black
        obj.font = UIFont.systemFont(ofSize: 12)
        obj.text = "0 дней"
        
        return obj
    }()
    
    private lazy var completeButton: UIButton = {
        let obj = UIButton()
        obj.layer.cornerRadius = 17
        obj.clipsToBounds = true
        obj.backgroundColor = .cGreen
        obj.tintColor = .white
        
        return obj
    }()
    
    private(set) var trackerID: UUID?
    private var indexPath: IndexPath?
    private var isCompleted = false
    private var countDays: Int = 0 {
        didSet {
            counterDaysLabel.text = "\(countDays) \(dayWord(for: countDays))"
        }
    }
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configure(indexPath: IndexPath, tracker: Tracker, isCompletedToday: Bool, countDays: Int) {
        self.indexPath = indexPath
        trackerID = tracker.id
        emojiLabel.text = String(tracker.emoji)
        textLabel.text = tracker.name
        cardView.backgroundColor = tracker.color
        completeButton.backgroundColor = tracker.color
       
        isCompleted = isCompletedToday
        self.countDays = countDays
        updateCompletedButtonStatus()
    }
    
    func changeCompletedButtonStatus() {
        isCompleted.toggle()
        countDays += isCompleted ? 1 : -1
        
        updateCompletedButtonStatus()
    }
    
    // MARK: - objc
    @objc private func didTapCompledetButton() {
        guard let indexPath else { return }
        delegate?.didTapCompletedButton(at: indexPath, isCompleted: !isCompleted)
    }
    
    
    // MARK: - Private Methods
    private func setupUI() {
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .clear
        contentView.addSubviews(cardView, counterDaysLabel, completeButton)
        
        cardView.addSubviews(emojiLabel, textLabel)
        completeButton.addTarget(self, action: #selector(didTapCompledetButton), for: .touchUpInside)
    }
    
    private func updateCompletedButtonStatus() {
        let image: ImageResource = isCompleted ? .done : .plus
        let opacity: Float = isCompleted ? 0.3 : 1.0
        
        completeButton.setImage(UIImage(resource: image), for: .normal)
        completeButton.layer.opacity = opacity
    }
    
    private func dayWord(for number: Int) -> String {
        let remainder10 = number % 10
        let remainder100 = number % 100
        
        if remainder100 >= 11 && remainder100 <= 14 {
            return "дней"
        }
        
        switch remainder10 {
        case 1:
            return "день"
        case 2, 3, 4:
            return "дня"
        default:
            return "дней"
        }
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
            
            completeButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            completeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 34),
            completeButton.heightAnchor.constraint(equalToConstant: 34),
            
            counterDaysLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            counterDaysLabel.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -8),
            counterDaysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16 )
        ])
    }
}
