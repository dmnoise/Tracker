//
//  AlertModel.swift
//  Tracker
//
//  Created by Dmitriy Noise on 17.07.2025.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String?
    let actions: [AlertAction]
    let preferredStyle: UIAlertController.Style
}

struct AlertAction {
    let title: String
    let style: UIAlertAction.Style
    let handler: (() -> Void)?
}
