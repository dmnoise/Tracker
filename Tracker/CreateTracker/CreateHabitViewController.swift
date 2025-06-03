//
//  CreateHabitViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 26.05.2025.
//

import UIKit

protocol CreateHabitViewControllerProtocol: AnyObject {
    func updateSelectedDays(weekdays: Set<Weekday>)
}

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
        obj.backgroundColor = .fieldBackground
        obj.layer.cornerRadius = 16
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        obj.leftView = paddingView
        obj.leftViewMode = .always
        obj.rightView = paddingView
        obj.rightViewMode = .always
        
        return obj
    }()
    
    private var limitHeightConstraint: NSLayoutConstraint?
    private let limitOfSymbols: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 17)
        obj.textColor = .lightRed
        obj.text = "Ограничение 38 символов"
        obj.isHidden = true
        
        return obj
    }()
    
    private let stackView: UIStackView = {
        let obj = UIStackView()
        obj.axis = .vertical
        obj.backgroundColor = .fieldBackground
        obj.layer.cornerRadius = 16
        obj.alignment = .fill
        obj.distribution = .fill
        obj.spacing = 0
        
        obj.isLayoutMarginsRelativeArrangement = true
        obj.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        return obj
    }()
    
    private let separatorView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .yaDarkGray
        obj.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return obj
    }()
    
    private let collectionView: UICollectionView = {
        let obj = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        obj.backgroundColor = .clear
        
        obj.isHidden = true // TODO: Что-то меня понесло, тут это пока скроем
        
        return obj
    }()
    
    private let cancelButton: UIButton = {
        let obj = UIButton()
        obj.setTitle("Отменить", for: .normal)
        obj.setTitleColor(.lightRed, for: .normal)
        obj.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        obj.backgroundColor = .yaWhite
        obj.layer.borderWidth = 1
        obj.layer.borderColor = UIColor(resource: .lightRed).cgColor
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    private let createButton: UIButton = {
        let obj = UIButton()
        obj.setTitle("Создать", for: .normal)
        obj.setTitleColor(.yaWhite, for: .normal)
        obj.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        obj.backgroundColor = .yaDarkGray
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    private let hStackButtoons: UIStackView = {
        let obj = UIStackView()
        obj.axis = .horizontal
        obj.distribution = .fillProportionally
        obj.spacing = 8
        
        return obj
    }()
    
    private let emoji: [Character] = [
        "🙂","😻","🌺","🐶","❤️","😱",
        "😇","😡","🥶","🤔","🙌","🍔",
        "🥦","🏓","🥇","🎸","🏝️","😪"
    ]
    
    private let color: [UIColor] = [
        .cLightRed, .cOrange, .cBlue, .cPurple, .cGreen, .cPink,
        .cPastel, .cLightBlue, .cLightGreen, .cDarkBlue, .cRed, .cLightPink,
        .cBeige, .cAnotherBlue, .cLilac, .cLightLilac, .cAnotherLilac, .cAnotherGreen
    ]
    
    private let param = GeometricParams(cellCount: 6, leftInset: 0, rightInset: 0, cellSpacing: 20)
    
    private var selectedDays: Set<Weekday> = []
    
    private let categoryView = HabitOptionView(title: "Категория")
    private let scheduleView = HabitOptionView(title: "Расписание")

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupCollectionView()
        addTratgets()
        
        categoryView.setSubtitle("Важное")
        scheduleView.setSubtitle(selectedDays.shortNamesString)
        
        view.addTapGestureToHideKeyboard()
    }
    
    // MARK: - Private methods
    private func addTratgets() {
        scheduleView.addTarget(self, action: #selector(didTapScheduleButton), for: .touchUpInside)
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        
        view.addSubviews(nameTextField, limitOfSymbols, stackView, collectionView, hStackButtoons)
        
        stackView.addArrangedSubview(categoryView)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(scheduleView)
        
        hStackButtoons.addArrangedSubview(cancelButton)
        hStackButtoons.addArrangedSubview(createButton)
    }
    
    private func setupCollectionView() {
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.reloadData()
    }
    
    private func setupConstraints() {
        
        limitHeightConstraint = limitOfSymbols.heightAnchor.constraint(equalToConstant: 0)
        limitHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            limitOfSymbols.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            limitOfSymbols.centerXAnchor.constraint(equalTo: nameTextField.centerXAnchor),
   
            stackView.topAnchor.constraint(equalTo: limitOfSymbols.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
     
            separatorView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            collectionView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            hStackButtoons.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            hStackButtoons.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
            hStackButtoons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func limitLabel(isHidden: Bool) {
        
        limitHeightConstraint?.constant = isHidden ? 0 : 22
        limitOfSymbols.isHidden = isHidden
    }
    
    // MARK: - objc
    @objc private func didTapScheduleButton() {
        
        let vc = UINavigationController(
            rootViewController: ScheduleViewController(delegate: self, selectedDays: selectedDays)
        )
        
        present(vc, animated: true)
    }
    
    @objc private func didTapCreateButton() {
        limitLabel(isHidden: false)
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
}

// MARK: - CreateHabitViewControllerProotocol
extension CreateHabitViewController: CreateHabitViewControllerProtocol {
    func updateSelectedDays(weekdays: Set<Weekday>) {
        
        selectedDays = weekdays
        scheduleView.setSubtitle(selectedDays.shortNamesString)
    }
}

// MARK: - UICollectionViewDataSource
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

// MARK: - UICollectionViewDelegateFlowLayout
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
