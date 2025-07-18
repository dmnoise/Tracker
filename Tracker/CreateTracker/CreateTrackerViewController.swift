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
    var editedTracker: Tracker?
    
    // MARK: - Init
    init(delegate: TrackerViewControllerProtocol? = nil, trackerType: Constants.TrackerType, tracker: Tracker? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.trackerType = trackerType
        self.delegate = delegate
        self.editedTracker = tracker
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let obj = UILabel()
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
            string: NSLocalizedString("textInputTracker", comment: ""),
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
        obj.isHidden = true
        let text = NSLocalizedString("characterLimit", comment: "")
        obj.text = String(format: text, Constants.maxNameLength)
        
        return obj
    }()
    
    private lazy var countOfDaysLabel: UILabel = {
        let obj = UILabel()
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        obj.text = "12 дней"
        obj.textAlignment = .center
        obj.isHidden = trackerType != .edit
        
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
        obj.setTitle(NSLocalizedString("cancel", comment: "Кнопка отмены создания трекера"), for: .normal)
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
        let textButton = trackerType != .edit
            ? NSLocalizedString("create", comment: "Кнопка создания трекера")
            : NSLocalizedString("save", comment: "Кнопка сохранения трекера")
        obj.setTitle(textButton, for: .normal)
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
    private let trackerRecordStore = TrackerRecordStore()
    
    private let categoryView = HabitOptionView(title: NSLocalizedString("category", comment: ""))
    private let scheduleView = HabitOptionView(title: NSLocalizedString("schedue", comment: ""))
    
    private let paramCV = GeometricParams(cellCount: 6, leftInset: 16, rightInset: 16, cellSpacing: 5)
    
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
    
    // MARK: - Private methods
    private func addTratgets() {
        scheduleView.addTarget(self, action: #selector(didTapScheduleButton), for: .touchUpInside)
        categoryView.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        switch trackerType {
        case .habbit:
            titleLabel.text = NSLocalizedString("newHabit", comment: "")
        case .event:
            titleLabel.text = NSLocalizedString("newEvent", comment: "")
        case .edit:
            titleLabel.text = NSLocalizedString("editingHabit", comment: "")
            configuireEditedTracker()
        }
        
        navigationItem.titleView = titleLabel
        
        view.addSubviews(scrollView, hStackButtoons)
        scrollView.addSubviews(contentView)
        contentView.addSubviews(countOfDaysLabel, nameTextField, textFieldErrorLabel, stackView, collectionView)
        
        stackView.addArrangedSubview(categoryView)
                
        if trackerType == .habbit || (trackerType == .edit && !selectedDays.isEmpty) {
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
        
        // У nameTextField разные отступы, или 40 от countOfDaysLabel или 24 от топа. Не придумал как сделать иначе
        if trackerType == .edit {
            NSLayoutConstraint.activate([
                countOfDaysLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
                countOfDaysLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                countOfDaysLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                
                nameTextField.topAnchor.constraint(equalTo: countOfDaysLabel.bottomAnchor, constant: 40),
            ])
        } else {
            nameTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24).isActive = true
        }
        
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
            
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            textFieldErrorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            textFieldErrorLabel.centerXAnchor.constraint(equalTo: nameTextField.centerXAnchor),
   
            stackView.topAnchor.constraint(equalTo: textFieldErrorLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor),
     
            separatorView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
            
            collectionView.heightAnchor.constraint(equalToConstant: collectionViewHeight()),
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
    
    private func collectionViewHeight() -> CGFloat {
        let numberOfEmojis = emoji.count
        let numberOfColors = color.count
        let cellCount = 6
        let emojiRows = Int(ceil(Double(numberOfEmojis) / Double(cellCount)))
        let colorRows = Int(ceil(Double(numberOfColors) / Double(cellCount)))
        
        let cellSpacing: CGFloat = 5
        let horizontalInset: CGFloat = 16
        let headerHeight: CGFloat = 32
        let sectionSpacing: CGFloat = 24
        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - horizontalInset * 2 - CGFloat(cellCount - 1) * cellSpacing
        let cellWidth = availableWidth / CGFloat(cellCount)
        
        let totalHeight = headerHeight + (CGFloat(emojiRows) * cellWidth) +
        headerHeight + (CGFloat(colorRows) * cellWidth) + sectionSpacing
        
        return totalHeight
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
        let isDaysSelected = !selectedDays.isEmpty || (trackerType == .event || selectedDays.isEmpty && trackerType == .edit)
        let isSelectedEmojiAndColor = selectedEmoji != nil && selectedColor != nil
        let isSelectedCategory = selectedCategory != nil
        
        changeCreateButton(isEnabled: isTextValid && isDaysSelected && isSelectedEmojiAndColor && isSelectedCategory)
    }
    
    /// Конфигурация вью под редактируемый трекер
    private func configuireEditedTracker() {
        guard let editedTracker else { return }
        
        let completedTrackers: Set<TrackerRecord> = trackerRecordStore.records
        let countDays = completedTrackers.filter { $0.trackerID == editedTracker.id }.count
        let daysString = String.localizedStringWithFormat(
            NSLocalizedString("countDays", comment: "Кол-во отмеченных дней"),
            countDays
        )

        countOfDaysLabel.text = daysString
        nameTextField.text = editedTracker.name
        selectedEmoji = editedTracker.emoji
        selectedColor = editedTracker.color
        updateSelectedDays(weekdays: editedTracker.schedule)

        restoreSelectedCategory()
        validateForm()
    }
    
    private func restoreSelectedCategory() {
        guard let editedTracker, let trackerCategoryStore else { return }
        categories = trackerCategoryStore.categories
        
        if let catIndex = categories.firstIndex(where: {
            $0.trackers.contains(where: { $0.id == editedTracker.id })
        }) {
            selectedCategory = IndexPath(row: catIndex, section: 0)
            categoryView.setSubtitle(categories[catIndex].title)
        }
    }
    
    // MARK: - objc
    @objc private func didTapCategoryButton() {
        
        let viewModel = CategoryCatalogViewModel(selectedIndexPath: selectedCategory)
        let viewController = CategoryCatalogViewController(viewModel: viewModel, delegate: self)
        
        present(UINavigationController(rootViewController:viewController), animated: true)
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
        
        let tracker = Tracker(id: editedTracker?.id ?? UUID(), name: name, color: selectedColor, emoji: selectedEmoji, schedule: selectedDays)
        let categoryName = categories[selectedCategory.row].title
        
        limitLabel(isHidden: true)
        delegate?.didTapCreate(tracker: tracker, to: categoryName, type: trackerType)
  
        self.dismissToRoot(animated: true)
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
}

// MARK: - CategoryCatalogViewControllerProtocol
extension CreateTrackerViewController: CategoryCatalogViewControllerProtocol {
    func setSelectedCategory(indexPath: IndexPath?) {
        guard let trackerCategoryStore else { return }
        
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
            
            let isThisEmojiSelected = selectedEmoji == emoji[indexPath.row]
            cell.isSelected(isThisEmojiSelected)
            cell.isSelected = isThisEmojiSelected

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else { return UICollectionViewCell()}
            
            cell.prepareForReuse()
            cell.setColor(color[indexPath.row])
            
            let marshaller = UIColorMarshalling()
            let isColorSelected = selectedColor != nil &&
                marshaller.hexString(from: color[indexPath.row]) == marshaller.hexString(from: selectedColor!)
            cell.isSelected(isColorSelected)
            cell.isSelected = isColorSelected
            
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
                
        headerView.titleLabel.text = indexPath.section == 0
            ? NSLocalizedString("emoji", comment: "")
            : NSLocalizedString("color", comment: "")
        
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
        switch indexPath.section {
        case 0: // emoji
            if let prevEmojiIndex = emoji.firstIndex(of: selectedEmoji ?? Character("-")),
               prevEmojiIndex != indexPath.row
            {
                let prevIndexPath = IndexPath(row: prevEmojiIndex, section: 0)
                collectionView.deselectItem(at: prevIndexPath, animated: false)
                if let prevCell = collectionView.cellForItem(at: prevIndexPath) as? EmojiCell {
                    prevCell.isSelected(false)
                }
            }
            
            selectedEmoji = emoji[indexPath.row]
            
            if let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell {
                cell.isSelected(true)
            }
       
        case 1: // цвет
            let marshaller = UIColorMarshalling()
            if let prevColor = selectedColor,
               let prevColorIndex = color.firstIndex(where: { marshaller.hexString(from: $0) == marshaller.hexString(from: prevColor) }),
               prevColorIndex != indexPath.row
            {
                let prevIndexPath = IndexPath(row: prevColorIndex, section: 1)
                collectionView.deselectItem(at: prevIndexPath, animated: false)
                if let prevCell = collectionView.cellForItem(at: prevIndexPath) as? ColorCell {
                    prevCell.isSelected(false)
                }
            }
            
            selectedColor = color[indexPath.row]
            
            if let cell = collectionView.cellForItem(at: indexPath) as? ColorCell {
                cell.isSelected(true)
            }
            
        default:
            return
        }
        
        validateForm()
    }
}
