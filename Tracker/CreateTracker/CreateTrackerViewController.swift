//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 26.05.2025.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Создание трекера"
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 16)
        
        return obj
    }()
    
    private let habitButton: UIButton = {
        let obj = UIButton()
        obj.setTitle("Привычка", for: .normal)
        obj.backgroundColor = .yaBlack
        obj.setTitleColor(.white, for: .normal)
        obj.setTitleColor(.gray, for: .highlighted)
        obj.layer.cornerRadius = 16
        
        
        
        return obj
    }()
    
    private let eventButton: UIButton = {
        let obj = UIButton()
        obj.setTitle("Нерегулярное событие", for: .normal)
        obj.backgroundColor = .yaBlack
        obj.setTitleColor(.white, for: .normal)
        obj.setTitleColor(.gray, for: .highlighted)
        obj.layer.cornerRadius = 16

        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActrions()
        setupConstraint()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
    }
    
    private func setupActrions() {
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(didTapEventButton), for: .touchUpInside)
    }
    
    private func setupConstraint() {
        
        view.addSubviews(habitButton, eventButton)
        
        NSLayoutConstraint.activate([
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - objc
    @objc private func didTapEventButton() {
        // ...
    }
    
    @objc private func didTapHabitButton() {
        present(UINavigationController(rootViewController: CreateHabitViewController()), animated: true)
    }
}
