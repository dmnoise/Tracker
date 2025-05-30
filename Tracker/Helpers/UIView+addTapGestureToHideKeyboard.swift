//
//  UIView+addTapGestureToHideKeyboard.swift
//  Tracker
//
//  Created by Dmitriy Noise on 30.05.2025.
//

import UIKit

extension UIView {

    func addTapGestureToHideKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(tapGesture)
    }

    private var topSuperview: UIView? {
        var view = superview
        while view?.superview != nil {
            view = view!.superview
        }
        return view
    }

    @objc private func dismissKeyboard() {
        topSuperview?.endEditing(true)
    }
}
