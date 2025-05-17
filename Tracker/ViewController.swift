//
//  ViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 17.05.2025.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var label: UILabel = {
        
        let obj = UILabel()
        obj.text = "Hello!"
        obj.font = .systemFont(ofSize: 20)
        obj.sizeToFit()
        obj.textAlignment = .center
        obj.translatesAutoresizingMaskIntoConstraints = false
        
        return obj
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(label)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }


}

