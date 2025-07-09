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
    
    private let defaults = UserDefaults.standard
    
    // MARK: - Private properties
    private lazy var logo: UIImageView = {
        let image = UIImage(resource: .logo)
        let obj = UIImageView(image: image)
        obj.contentMode = .scaleAspectFit
        return obj
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !defaults.bool(forKey: "firstLaunch") {
            defaults.set(true, forKey: "firstLaunch")
            
            let onboarding = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
            onboarding.modalPresentationStyle = .fullScreen
            onboarding.modalTransitionStyle = .crossDissolve
            
            present(onboarding, animated: true)
        } else {
            delegate?.switchToTabBar()
        }
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
