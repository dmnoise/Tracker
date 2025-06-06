//
//  UIView+addSubviews.swift
//  Tracker
//
//  Created by Dmitriy Noise on 17.05.2025.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
}
