//
//  StatsViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 17.05.2025.
//

import UIKit

class TrackerViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Трекер"
        obj.textColor = .black
        obj.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        return obj
    }()
    
    private let searchView: UISearchBar = {
        let obj = UISearchBar()
        obj.placeholder = "Поиск"
        obj.searchBarStyle = .minimal
        
        return obj
    }()
    
    private let label: UILabel = {
        let obj = UILabel()
        obj.text = "Что будем отслеживать?"
        obj.font = .systemFont(ofSize: 18)
        obj.sizeToFit()
        obj.textAlignment = .center
        
        return obj
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(resource: .superStar)
        let obj = UIImageView(image: image)
        
        return obj
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupNavigationBar()
        setupConstrains()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func setupConstrains() {
        view.addSubviews(titleLabel, searchView, imageView, label)
                
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchView.heightAnchor.constraint(equalToConstant: 36),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupNavigationBar() {
        let leftButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: nil
        )
        
        let button: UIButton = {
            let obj = UIButton()
            obj.setTitle("14.14.14", for: .normal)
            obj.setTitleColor(.yaBlack, for: .normal)
            obj.backgroundColor = .yaGray
            obj.layer.cornerRadius = 8
            
            obj.widthAnchor.constraint(equalToConstant: 77).isActive = true
            obj.heightAnchor.constraint(equalToConstant: 34).isActive = true
            
            return obj
        }()
        
        let rightButton = UIBarButtonItem(customView: button)
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: .yaBlack)
        
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.tintColor = UIColor(resource: .yaBlack)

    }
    
}

