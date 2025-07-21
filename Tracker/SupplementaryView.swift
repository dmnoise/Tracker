//
//  SupplementaryView.swift
//  Tracker
//
//  Created by Dmitriy Noise on 28.05.2025.
//

import UIKit

final class SupplementaryView: UICollectionReusableView {
    let titleLabel: UILabel = {
        let obj = UILabel()
        obj.textAlignment = .left
        obj.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        obj.textColor = .mainText
        
        return obj
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 28),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
