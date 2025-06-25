//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 26.05.2025.
//

import UIKit

protocol CreateTrackerViewControllerProtocol: AnyObject {
    func updateSelectedDays(weekdays: Set<Weekday>)
}

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: TrackerViewControllerProtocol?
    var trackerType: Constants.TrackerType = .habbit
    
    // MARK: - Init
    init(delegate: TrackerViewControllerProtocol? = nil, trackerType: Constants.TrackerType) {
        super.init(nibName: nil, bundle: nil)
        
        self.trackerType = trackerType
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Новая привычка"
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 16)
        
        return obj
    }()
    
    private lazy var scrollView: UIScrollView = {
        let obj = UIScrollView()
        obj.backgroundColor = .clear
        obj.showsVerticalScrollIndicator = false
        
        return obj
    }()
    
    private lazy var contentView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .clear
        
        return obj
    }()
    
    private lazy var nameTextField: UITextField = {
        let obj = UITextField()
        obj.font = UIFont.systemFont(ofSize: 17)
        obj.textColor = .yaBlack
        obj.backgroundColor = .fieldBackground
        obj.layer.cornerRadius = 16
        obj.attributedPlaceholder = NSAttributedString(
            string: "Введите название трекера",
            attributes: [.foregroundColor: UIColor.yaDarkGray]
        )
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        obj.leftView = paddingView
        obj.leftViewMode = .always
        obj.rightView = paddingView
        obj.rightViewMode = .always
        
        return obj
    }()
    
    private var limitHeightConstraint: NSLayoutConstraint?
    private lazy var textFieldErrorLabel: UILabel = {
        let obj = UILabel()
        obj.font = UIFont.systemFont(ofSize: 17)
        obj.textColor = .lightRed
        obj.text = "Ограничение \(Constants.maxNameLength) символов"
        obj.isHidden = true
        
        return obj
    }()
    
    private lazy var stackView: UIStackView = {
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
    
    private lazy var separatorView: UIView = {
        let obj = UIView()
        obj.backgroundColor = .yaDarkGray
        obj.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        return obj
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let obj = UICollectionView(frame: .zero, collectionViewLayout: layout)
        obj.backgroundColor = .clear
        obj.isScrollEnabled = false
        
        return obj
    }()
    
    private lazy var cancelButton: UIButton = {
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
    
    private lazy var createButton: UIButton = {
        let obj = UIButton()
        obj.setTitle("Создать", for: .normal)
        obj.setTitleColor(.yaWhite, for: .normal)
        obj.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        obj.backgroundColor = .yaDarkGray
        obj.layer.cornerRadius = 16
        obj.isEnabled = false
        
        return obj
    }()
    
    private lazy var hStackButtoons: UIStackView = {
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
    
    private var selectedCategory: IndexPath?
    private var selectedDays: Set<Weekday> = []
    private var selectedColor: UIColor?
    private var selectedEmoji: Character?
    private var categories: [TrackerCategory] = []
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private let categoryView = HabitOptionView(title: "Категория")
    private let scheduleView = HabitOptionView(title: "Расписание")
    
    private let paramCV = GeometricParams(cellCount: 6, leftInset: 16, rightInset: 16, cellSpacing: 5)
    private var collectionViewHeightConstraint: NSLayoutConstraint!

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupCollectionView()
        addTratgets()
        
        nameTextField.delegate = self
        
        view.addTapGestureToHideKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateCollectionViewHeight()
    }
    
    // MARK: - Private methods
    private func addTratgets() {
        scheduleView.addTarget(self, action: #selector(didTapScheduleButton), for: .touchUpInside)
        categoryView.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        titleLabel.text = trackerType != .event ? "Новая привычка" : "Новое нерегулярное событие"
        navigationItem.titleView = titleLabel
        
        view.addSubviews(scrollView, hStackButtoons)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(nameTextField, textFieldErrorLabel, stackView, collectionView)
        
        stackView.addArrangedSubview(categoryView)
        
        if trackerType == .habbit {
            stackView.addArrangedSubview(separatorView)
            stackView.addArrangedSubview(scheduleView)
        }
        
        hStackButtoons.addArrangedSubview(cancelButton)
        hStackButtoons.addArrangedSubview(createButton)
    }
    
    private func setupCollectionView() {
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.reloadData()
    }
    
    private func setupConstraints() {
        
        limitHeightConstraint = textFieldErrorLabel.heightAnchor.constraint(equalToConstant: 0)
        limitHeightConstraint?.isActive = true
        
        collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 500)
        collectionViewHeightConstraint.priority = .defaultHigh
        collectionViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: hStackButtoons.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            textFieldErrorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            textFieldErrorLabel.centerXAnchor.constraint(equalTo: nameTextField.centerXAnchor),
   
            stackView.topAnchor.constraint(equalTo: textFieldErrorLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
     
            separatorView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            
            collectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            hStackButtoons.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hStackButtoons.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hStackButtoons.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateCollectionViewHeight() {
        let headerHeight: CGFloat = 32
        let sectionSpacing: CGFloat = 24
        
        let emojiRows = ceil(CGFloat(emoji.count) / 6.0)
        let colorRows = ceil(CGFloat(color.count) / 6.0)
        
        let cellWidth = (collectionView.bounds.width - 32) / 6.0
        
        let totalHeight =
            headerHeight + (emojiRows * cellWidth) +
            headerHeight + (colorRows * cellWidth) +
            sectionSpacing
        
        collectionViewHeightConstraint.constant = totalHeight
        view.layoutIfNeeded()
    }
    
    private func limitLabel(isHidden: Bool) {
        limitHeightConstraint?.constant = isHidden ? 0 : 22
        textFieldErrorLabel.isHidden = isHidden
    }
    
    private func changeCreateButton(isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .yaBlack : .yaDarkGray
    }
    
    private func validateForm() {
        guard let text = nameTextField.text else {
            changeCreateButton(isEnabled: false)
            return
        }
        
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let length = trimmed.count
        
        limitLabel(isHidden: length < Constants.maxNameLength)
    
        let isTextValid = (1...Constants.maxNameLength).contains(length)
        let isDaysSelected = !selectedDays.isEmpty || trackerType == .event
        let isSelectedEmojiAndColor = selectedEmoji != nil && selectedColor != nil
        let isSelectedCategory = selectedCategory != nil
        
        changeCreateButton(isEnabled: isTextValid && isDaysSelected && isSelectedEmojiAndColor && isSelectedCategory)
    }
    
    // MARK: - objc
    @objc private func didTapCategoryButton() {
        present(UINavigationController(
                rootViewController:CategoryCatalogViewController(delegate: self, selectedIndexPath: selectedCategory)
        ), animated: true)
    }
    
    @objc private func didTapScheduleButton() {
        let vc = UINavigationController(
            rootViewController: ScheduleViewController(delegate: self, selectedDays: selectedDays)
        )
        
        present(vc, animated: true)
    }
    
    @objc private func didTapCreateButton() {
        guard let name = nameTextField.text, name.count < Constants.maxNameLength else {
            limitLabel(isHidden: false)
            return
        }

        guard let selectedEmoji, let selectedColor, let selectedCategory else { return }
        
        let tracker = Tracker(name: name, color: selectedColor, emoji: selectedEmoji, schedule: selectedDays)
        let categoryName = categories[selectedCategory.row].title
        
        limitLabel(isHidden: true)
        delegate?.didTapCreate(tracker: tracker, to: categoryName)
        
        self.dismissToRoot(animated: true)
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
}

// MARK: - CategoryCatalogViewControllerProtocol
extension CreateTrackerViewController: CategoryCatalogViewControllerProtocol {
    func setSelectedCategory(indexPath: IndexPath?) {
        
        categories = trackerCategoryStore.categories
        
        categoryView.setSubtitle(indexPath != nil ? categories[indexPath!.row].title : nil)
        selectedCategory = indexPath
        
        validateForm()
    }
}

// MARK: - UITextFieldDelegate
extension CreateTrackerViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        validateForm()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

// MARK: - CreateHabitViewControllerProotocol
extension CreateTrackerViewController: CreateTrackerViewControllerProtocol {
    func updateSelectedDays(weekdays: Set<Weekday>) {
        
        selectedDays = weekdays
        scheduleView.setSubtitle(selectedDays.shortNamesString)
        validateForm()
    }
}

// MARK: - UICollectionViewDataSource
extension CreateTrackerViewController: UICollectionViewDataSource {
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
            cell.setColor(color[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "header",
                for: indexPath
            ) as? SupplementaryView
        else {
            return UICollectionReusableView()
        }
                
        headerView.titleLabel.text = indexPath.section == 0 ? "Emoji" : "Цвет"
        
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        paramCV.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        paramCV.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: paramCV.leftInset, bottom: 0, right: paramCV.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let avaliableWidth = collectionView.frame.width - paramCV.paddingWidth
        let cellWidth = avaliableWidth / CGFloat(paramCV.cellCount)
        
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

extension CreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for selectedIndexPath in collectionView.indexPathsForSelectedItems ?? [] {
            if selectedIndexPath.section == indexPath.section && selectedIndexPath != indexPath {
                collectionView.deselectItem(at: selectedIndexPath, animated: true)
                collectionView.delegate?.collectionView?(collectionView, didDeselectItemAt: selectedIndexPath)
            }
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        switch cell {
        case let emojiCell as EmojiCell:
            emojiCell.isSelected(true)
            selectedEmoji = emoji[indexPath.row]
        
        case let colorCell as ColorCell:
            colorCell.isSelected(true)
            selectedColor = color[indexPath.row]
            
        default:
            return
        }
        
        validateForm()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        switch cell {
        case let emojiCell as EmojiCell:
            emojiCell.isSelected(false)
            selectedEmoji = nil
            
        case let colorCell as ColorCell:
            colorCell.isSelected(false)
            selectedColor = nil
            
        default:
            return
        }
        
        validateForm()
    }
}
