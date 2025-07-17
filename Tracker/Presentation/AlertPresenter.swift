//
//  AlertPresenter.swift
//  Tracker
//
//  Created by Dmitriy Noise on 17.07.2025.
//

import UIKit

final class AlertPresenter {
    private let model: AlertModel
    
    init(from alertModel: AlertModel) {
        self.model = alertModel
    }
    
    func presentAlert(from viewController: UIViewController) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: model.preferredStyle)
        
        model.actions.forEach { action in
            let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                action.handler?()
            }
            
            alert.addAction(alertAction)
        }
        
        alert.view.accessibilityIdentifier = "AlertPresent"
        viewController.present(alert, animated: true, completion: nil)
    }
}
