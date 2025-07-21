//
//  UIView+GradientView.swift
//  Tracker
//
//  Created by Dmitriy Noise on 21.07.2025.
//

import UIKit

class GradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    init(colors: [UIColor] = [.red, .green, .blue]) {
        super.init(frame: .zero)
        setupGradient(colors: colors)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient(colors: [.red, .green, .blue])
    }

    private func setupGradient(colors: [UIColor]) {
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }
}
