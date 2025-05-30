//
//  EmojiCell.swift
//  Tracker
//
//  Created by Dmitriy Noise on 27.05.2025.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    static let identifier = "EmojiCell"
    
    private var textLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 32)
        obj.text = "A"
        
        return obj
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.masksToBounds = true
        contentView.addSubviews(textLabel)
        
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func setEmoji(_ emoji: Character) {
        textLabel.text = String(emoji)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
