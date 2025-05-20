//
//  SplashScreen.swift
//  Tracker
//
//  Created by Dmitriy Noise on 19.05.2025.
//

import UIKit

protocol SplashScreenDelegate: AnyObject {
    func switchToTabBar()
}

final class SplashScreen: UIViewController {
    
    weak var delegate: SplashScreenDelegate?
    
    // MARK: - Private properties
    private let logo: UIImageView = {
        let image = UIImage(resource: .logo)
        let obj = UIImageView(image: image)
        obj.contentMode = .scaleAspectFit
        return obj
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        delegate?.switchToTabBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = UIColor(resource: .yaBlue)
        view.addSubviews(logo)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logo.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
