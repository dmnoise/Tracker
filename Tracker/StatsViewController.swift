//
//  StatsViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 19.05.2025.
//

import UIKit

final class StatsViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Статистика"
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        return obj
    }()
    
    private let label: UILabel = {
        let obj = UILabel()
        obj.text = "Анализировать пока нечего"
        obj.textColor = .yaBlack
        obj.font = .systemFont(ofSize: 12)
        
        return obj
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(resource: .cryingMan)
        let obj = UIImageView(image: image)
        
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews(titleLabel, imageView, label)
        
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
}
