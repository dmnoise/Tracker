//
//  EmojiCell.swift
//  Tracker
//
//  Created by Dmitriy Noise on 27.05.2025.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    static let identifier = "EmojiCell"
    
    // MARK: - Private properties
    private lazy var textLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 32)
        
        return obj
    }()
    
    private lazy var substrateView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .clear
        obj.layer.cornerRadius = 16
        obj.layer.masksToBounds = true
        
        return obj
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setEmoji(_ emoji: Character) {
        textLabel.text = String(emoji)
    }
    
    func isSelected(_ isSelected: Bool) {
        substrateView.backgroundColor = isSelected ? .yaLightGray : .clear
    }
    
    // MARK: - Private methods
    private func setupConstraints() {
        contentView.addSubviews(substrateView, textLabel)
        
        NSLayoutConstraint.activate([
            substrateView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            substrateView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            substrateView.widthAnchor.constraint(equalToConstant: 52),
            substrateView.heightAnchor.constraint(equalToConstant: 52),
            
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
