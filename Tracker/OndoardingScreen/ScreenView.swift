//
//  ScreenView.swift
//  Tracker
//
//  Created by Dmitriy Noise on 08.07.2025.
//

import UIKit

final class ScreenView: UIViewController {
    
    private var backgroundImage: UIImage?
    private var text: String?
    
    private lazy var backgroundView: UIImageView = {
        let obj = UIImageView()
        obj.contentMode = .scaleAspectFill
        obj.backgroundColor = .clear
        
        return obj
    }()
    
    private lazy var textLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        obj.textColor = .yaBlack
        obj.textAlignment = .center
        obj.numberOfLines = 2
        obj.lineBreakMode = .byWordWrapping
        
        return obj
    }()
    
    // MARK: - Initializers
    init(text: String, image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        
        self.text = text
        self.backgroundImage = image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        
        guard let backgroundImage, let text else { return }
        
        backgroundView.image = backgroundImage
        textLabel.text = text
     
        view.addSubviews(backgroundView, textLabel)
        view.backgroundColor = .background
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270) // 130 - требуемый по макету, 140 - кнопка и отступы от нее
        ])
    }
}
