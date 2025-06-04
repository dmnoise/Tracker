//
//  Untitled.swift
//  Tracker
//
//  Created by Dmitriy Noise on 03.06.2025.
//

import UIKit

final class HabitOptionView: UIControl {
    
    // MARK: - Subviews
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .yaBlack
        
        return obj
    }()
    
    private let subtitleLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .yaDarkGray
        
        return obj
    }()
    
    private let chevronImageView: UIImageView = {
        let obj = UIImageView()
        obj.image = UIImage(systemName: "chevron.right")
        obj.tintColor = .yaDarkGray
        
        return obj
    }()
    
    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        
        titleLabel.text = title
        
        setupConstarints()
        setupStyle()

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setSubtitle(_ text: String?) {
        subtitleLabel.text = text
        subtitleLabel.isHidden = (text == nil)
    }
    
    // MARK: - Private methods
    private func setupConstarints() {
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        let hStack = UIStackView(arrangedSubviews: [stack, chevronImageView])
        hStack.alignment = .center
        hStack.spacing = 8
        
        addSubview(hStack)
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),
            
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 20),
            
            hStack.topAnchor.constraint(equalTo: topAnchor),
            hStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            hStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
    }
    
    // MARK: - objc
    @objc private func didTap() {
        sendActions(for: .touchUpInside)
    }
}
