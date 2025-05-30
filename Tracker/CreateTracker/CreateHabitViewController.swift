//
//  CreateHabitViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 26.05.2025.
//

import UIKit

final class CreateHabitViewController: UIViewController {
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Новая привычка"
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 16)
        
        return obj
    }()
    
    private let nameTextField: UITextField = {
        let obj = UITextField()
        obj.placeholder = "Введите название трекера"
        obj.font = UIFont.systemFont(ofSize: 17)
        obj.backgroundColor = .yaGray
        obj.layer.cornerRadius = 16
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        obj.leftView = paddingView
        obj.leftViewMode = .always
        obj.rightView = paddingView
        obj.rightViewMode = .always
        
        return obj
    }()
    
    private let stackView: UIStackView = {
        let obj = UIStackView()
        obj.axis = .vertical
        obj.backgroundColor = .yaGray
        obj.layer.cornerRadius = 16
        obj.alignment = .fill
        obj.distribution = .fillProportionally
        obj.spacing = 0
        
        obj.isLayoutMarginsRelativeArrangement = true
        obj.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return obj
    }()
    
    private let categoryButton: UIButton = {
        let obj = UIButton()
        obj.setTitle("Категория", for: .normal)
        obj.setTitleColor(.yaBlack, for: .normal)
        obj.setTitleColor(.gray, for: .highlighted)
        obj.contentHorizontalAlignment = .left
        
        return obj
    }()
    
    private let separatorView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .yaDarkGray
        obj.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return obj
    }()
    
    private let scheduleButton: UIButton = {
        let obj = UIButton()
        obj.setTitle("Расписание", for: .normal)
        obj.setTitleColor(.yaBlack, for: .normal)
        obj.setTitleColor(.gray, for: .highlighted)
        obj.contentHorizontalAlignment = .left
        
        return obj
    }()
    
    private let collectionView: UICollectionView = {
        let obj = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        obj.backgroundColor = .clear
        
        return obj
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupCollectionView()
        
        view.addTapGestureToHideKeyboard()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        
        view.addSubviews(nameTextField, stackView, collectionView)
        
        stackView.addArrangedSubview(categoryButton)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(scheduleButton)
        
        addChevron(to: categoryButton)
        addChevron(to: scheduleButton)
    }
    
    private func setupCollectionView() {
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            stackView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 150),
            
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addChevron(to button: UIButton) {
        let chevron = UIImageView()
        chevron.image = UIImage(systemName: "chevron.right")
        chevron.tintColor = .yaDarkGray
        
        button.addSubviews(chevron)
        
        NSLayoutConstraint.activate([
            chevron.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -16),
            chevron.widthAnchor.constraint(equalToConstant: 12),
            chevron.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    let emoji: [Character] = [
        "🙂","😻","🌺","🐶","❤️","😱",
        "😇","😡","🥶","🤔","🙌","🍔",
        "🥦","🏓","🥇","🎸","🏝️","😪"
    ]
    
    let color: [UIColor] = [
        .cLightRed, .cOrange, .cBlue, .cPurple, .cGreen, .cPink,
        .cPastel, .cLightBlue, .cLightGreen, .cDarkBlue, .cRed, .cLightPink,
        .cBeige, .cAnotherBlue, .cLilac, .cLightLilac, .cAnotherLilac, .cAnotherGreen
    ]
    
    let param = GeometricParams(cellCount: 6, leftInset: 0, rightInset: 0, cellSpacing: 20)
}

extension CreateHabitViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        section == 0 ? emoji.count : color.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else { return UICollectionViewCell()}
            
            cell.prepareForReuse()
            cell.setEmoji(emoji[indexPath.row])
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell()}
            
            cell.prepareForReuse()
            cell.contentView.backgroundColor = color[indexPath.row]
            
            return cell
        }
    }
    
    
}

extension CreateHabitViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        param.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        param.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: param.leftInset, bottom: 10, right: param.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let avaliableWidth = collectionView.frame.width - param.paddingWidth
        let cellWidth = avaliableWidth / CGFloat(param.cellCount)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
