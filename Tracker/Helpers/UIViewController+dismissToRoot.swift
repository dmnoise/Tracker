//
//  UIViewController+dismissToRoot.swift
//  Tracker
//
//  Created by Dmitriy Noise on 04.06.2025.
//

import UIKit

extension UIViewController {
    func dismissToRoot(animated: Bool = true, completion: (() -> Void)? = nil) {
        var root = self
        while let parent = root.presentingViewController {
            root = parent
        }
        root.dismiss(animated: animated, completion: completion)
    }
}
