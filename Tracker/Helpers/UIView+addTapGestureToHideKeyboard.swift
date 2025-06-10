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
        tapGesture.cancelsTouchesInView = false
        findTopSuperview()?.addGestureRecognizer(tapGesture)
    }
    
    private func findTopSuperview() -> UIView? {
        var view: UIView? = self
        while let superview = view?.superview {
            view = superview
        }
        return view
    }
    
    @objc private func dismissKeyboard() {
        self.window?.endEditing(true)
    }
}
