//
//  ColorCell.swift
//  Tracker
//
//  Created by Dmitriy Noise on 27.05.2025.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    static let identifier = "ColorCell"
    
    // MARK: - Private properties
    private lazy var squareColorView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .black
        obj.layer.cornerRadius = 8
        obj.layer.masksToBounds = true
        
        return obj
    }()
    
    private lazy var substrateView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .clear
        obj.layer.borderWidth = 0
        obj.layer.cornerRadius = 8
        obj.layer.masksToBounds = true
        
        return obj
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setColor(_ color: UIColor) {
        squareColorView.backgroundColor = color
        substrateView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    }
    
    func isSelected(_ isSelected: Bool) {
        substrateView.layer.borderWidth = isSelected ? 3 : 0
    }
    
    // MARK: - Private methods
    private func setupUI() {
        contentView.addSubviews(substrateView, squareColorView)
        
        NSLayoutConstraint.activate([
            substrateView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            substrateView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            substrateView.widthAnchor.constraint(equalToConstant: 52),
            substrateView.heightAnchor.constraint(equalToConstant: 52),
            
            squareColorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            squareColorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            squareColorView.widthAnchor.constraint(equalToConstant: 40),
            squareColorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
