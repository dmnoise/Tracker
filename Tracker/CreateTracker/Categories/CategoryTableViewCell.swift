//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Dmitriy Noise on 12.06.2025.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    static let identifier = "CategoryCell"
    
    private lazy var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .imageCheckmark)
        imageView.isHidden = true
        
        return imageView
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setSelected(_ selected: Bool) {
        checkmarkImageView.isHidden = !selected
    }
    
    // MARK: - Private methods
    private func setupUI() {
        contentView.addSubviews(checkmarkImageView)
        contentView.backgroundColor = .backgroundTable
        
        NSLayoutConstraint.activate([
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
}
