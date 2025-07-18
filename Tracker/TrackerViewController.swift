//
//  StatsViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 17.05.2025.
//

import UIKit

protocol TrackerViewControllerProtocol: AnyObject {
    func didTapCreate(tracker: Tracker, to category: String, type: Constants.TrackerType)
}

class TrackerViewController: UIViewController {    
    private lazy var titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = NSLocalizedString("tracker", comment: "")
        obj.textColor = .black
        obj.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        return obj
    }()
    
    private lazy var searchBar: UISearchBar = {
        let obj = UISearchBar()
        obj.placeholder = NSLocalizedString("find", comment: "")
        obj.searchBarStyle = .minimal
        
        return obj
    }()
    
    private lazy var searchButton: UIButton = {
        let obj = UIButton()
        obj.setTitle(NSLocalizedString("filters", comment: ""), for: .normal)
        obj.setTitleColor(.yaWhite, for: .normal)
        obj.backgroundColor = .yaBlue
        obj.layer.cornerRadius = 16
        obj.contentEdgeInsets = UIEdgeInsets(top: 14, left: 20, bottom: 14, right: 20)
        
        return obj
    }()
    
    private lazy var label: UILabel = {
        let obj = UILabel()
        obj.text = NSLocalizedString("trackerPlaceholder", comment: "")
        obj.font = .systemFont(ofSize: 12)
        obj.textColor = .yaBlack
        obj.sizeToFit()
        obj.textAlignment = .center
        obj.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return obj
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(resource: .superStar)
        let obj = UIImageView(image: image)
        
        return obj
    }()
    
    private lazy var placeholderView: UIStackView = {
        let obj = UIStackView()
        obj.axis = .vertical
        obj.alignment = .center
        obj.distribution = .fill
        obj.spacing = 8
        
        return obj
    }()
    
    private lazy var collectionView: UICollectionView = {
        let obj = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        obj.backgroundColor = .yaWhite
        
        return obj
    }()
    
    // MARK: - Private properties
    private var selectedDate = Date()
    private var categories: [TrackerCategory]?
    private var visibleCategories: [TrackerCategory]?
    private var completedTrackers: Set<TrackerRecord> = []
    
    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private let trackerRecordStore = TrackerRecordStore()
    
    private let paramCV = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
  
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateVisibleTrackers()
        setupUI()
        setupNavigationBar()
        setupConstrains()
        setupCollectionView()
        view.addTapGestureToHideKeyboard()
        
        trackerStore.delegate = self
        searchBar.delegate = self
    }

    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func setupConstrains() {
        view.addSubviews(titleLabel, searchBar, collectionView, placeholderView, searchButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderView.addArrangedSubview(imageView)
        placeholderView.addArrangedSubview(label)
                
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 50),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        let leftButton = UIBarButtonItem(
            image: UIImage(resource: .icAddTracker),
            style: .plain,
            target: self,
            action: #selector(createTracker)
        )
        
        let datePicker: UIBarButtonItem = {
            let obj = UIDatePicker()
            obj.datePickerMode = .date
            obj.preferredDatePickerStyle = .compact
            obj.addTarget(self, action: #selector(datePickerValueChanget(_:)), for: .valueChanged)
            
            return UIBarButtonItem(customView: obj)
        }()
        
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.leftBarButtonItem?.tintColor = UIColor(resource: .yaBlack)
        
        navigationItem.rightBarButtonItem = datePicker
        navigationItem.rightBarButtonItem?.tintColor = UIColor(resource: .yaBlack)
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(SupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
    }
    
    private func updatePlaceholderState() {
        let isHidden = !(visibleCategories?.isEmpty ?? true)
        placeholderView.isHidden = isHidden
    }
    
    private func countOfCompleted(for trackerID: UUID) -> Int {
        completedTrackers.filter { $0.trackerID == trackerID }.count
    }
    
    private func isCompleted(for trackerID: UUID, on date: Date) -> Bool {
        return completedTrackers.contains {
            $0.trackerID == trackerID &&
            Calendar.current.isDate($0.date, inSameDayAs: date)
        }
    }
    
    private func updateVisibleTrackers(updateUI: Bool = true) {
        guard let categoryStore else { return }
        
        completedTrackers = trackerRecordStore.records
        categories = categoryStore.categories
        visibleCategories = categories?.filteredHabitsAndEvents(on: selectedDate, recordTrackers: completedTrackers)

        if updateUI {
            updatePlaceholderState()
            collectionView.reloadData()
        }
    }
    
    private func filterTrackers(searchText: String) {
        guard let categories else { return }
        
        if searchText.isEmpty {
            visibleCategories = categories
        } else {
            visibleCategories = categories.compactMap { category in
                let filteredTrackers = category.trackers.filter { $0.name.lowercased().contains(searchText.lowercased()) }
                guard !filteredTrackers.isEmpty else { return nil }
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
        }
        collectionView.reloadData()
    }
    
    private func resetSearchBar() { // FIXME: при скрытии отображаются пустые категории (без трекеров)
        searchBar.text = nil
        searchBar.resignFirstResponder()
        filterTrackers(searchText: "")
    }
    
    // MARK: - objc
    @objc private func datePickerValueChanget(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        self.selectedDate = selectedDate
        
        resetSearchBar()
        updateVisibleTrackers()
        collectionView.reloadData()
    }
    
    @objc private func createTracker() {
        present(
            UINavigationController(rootViewController: SelectTypeTrackerViewController(delegate: self)),
            animated: true
        )
    }
}

// MARK: - UISearchBarDelegate
extension TrackerViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterTrackers(searchText: searchText)
    }
}

// MARK: - TrackerStoreDelegate
extension TrackerViewController: TrackerStoreDelegate {
    func store(_ store: TrackerStore, didUpdate update: TrackerStoreUpdate) {
        let oldSectionCount = collectionView.numberOfSections
        updateVisibleTrackers(updateUI: false)
        updatePlaceholderState()
        let newSectionCount = visibleCategories?.count ?? 0

        if oldSectionCount != newSectionCount || !update.inserted.isEmpty {
            collectionView.reloadData()
            return
        }
        
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: update.inserted)
            collectionView.deleteItems(at: update.deleted)
            collectionView.reloadItems(at: update.updated)
            for move in update.moved {
                collectionView.moveItem(at: move.from, to: move.to)
            }
        }
    }
}


// MARK: - TrackerViewControllerProtocol
extension TrackerViewController: TrackerViewControllerProtocol {
    func didTapCreate(tracker: Tracker, to category: String, type: Constants.TrackerType) {
        switch type {
        case .habbit, .event:
            trackerStore.createTracker(tracker, to: category)
            updatePlaceholderState()
        case .edit:
            trackerStore.updateTracker(tracker, to: category)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in // FIXME: - убрать
                self?.updateVisibleTrackers()
            }
            
        }
    }
}

// MARK: - TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    func didTapCompletedButton(at indexPath: IndexPath, isCompleted: Bool) {
        
        guard
            selectedDate <= Date(),
            let tracker = visibleCategories?[indexPath.section].trackers[indexPath.row]
        else { return }
        
        let record = TrackerRecord(trackerID: tracker.id, date: selectedDate)
        
        do {
            if isCompleted {
                try trackerRecordStore.addRecord(record)
            } else {
                try trackerRecordStore.removeRecord(record)
            }
            
            updateVisibleTrackers(updateUI: false)
            
            guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else { return }
            cell.changeCompletedButtonStatus()
        } catch {
            print("Ошибка изменения записи :(\nError: \(error)")
        }
    }
}

// MARK: - UICollectionViewDataSource
extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories?[section].trackers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell,
            let tracker = visibleCategories?[indexPath.section].trackers[indexPath.row]
        else {
            return UICollectionViewCell()
        }
         
        cell.delegate = self
        cell.configure(
            indexPath: indexPath,
            tracker: tracker,
            isCompletedToday: isCompleted(for: tracker.id, on: selectedDate),
            countDays: countOfCompleted(for: tracker.id)
        )
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        var id: String
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            id = "header"
        default:
            id = ""
        }
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: id, for: indexPath) as! SupplementaryView
        view.titleLabel.text = visibleCategories?[indexPath.section].title
        
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY + frameHeight >= contentHeight - 20 {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.searchButton.alpha = 0
            }
        } else {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.searchButton.alpha = 1
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        paramCV.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        paramCV.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: paramCV.leftInset, bottom: 10, right: paramCV.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let avaliableWidth = collectionView.frame.width - paramCV.paddingWidth
        let cellWidth = avaliableWidth / CGFloat(paramCV.cellCount)
        
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfiguration configuration: UIContextMenuConfiguration,
        highlightPreviewForItemAt indexPath: IndexPath
    ) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerCell else {
            return nil
        }
        
        // Иначе не будет анимироваться больше ячейки
        cell.contentView.clipsToBounds = false

        let targetedView = cell.cardView
        let parameters = UIPreviewParameters()
        parameters.visiblePath = UIBezierPath(roundedRect: targetedView.bounds, cornerRadius: targetedView.layer.cornerRadius)
        
        return UITargetedPreview(view: targetedView, parameters: parameters)
    }

    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }

        return UIContextMenuConfiguration(actionProvider: { actions in
            let edit = UIAction(title: "Изменить") { [weak self] _ in
                guard
                    let self,
                    let tracker = visibleCategories?[indexPath.section].trackers[indexPath.row]
                else { return }
                
                let createTrackerVC = CreateTrackerViewController(delegate: self, trackerType: .edit, tracker: tracker)
                present(UINavigationController(rootViewController: createTrackerVC), animated: true)
            }

            let delete = UIAction(title: "Удалить", image: nil, attributes: .destructive) { [weak self] _ in
                guard
                    let self,
                    let tracker = visibleCategories?[indexPath.section].trackers[indexPath.row]
                else { return }
                
                let actions = [
                    AlertAction(title: "Удалить", style: .destructive, handler: {
                        self.trackerStore.deleteTracker(with: tracker.id)
                    }),
                    AlertAction(title: "Отмена", style: .cancel, handler: {})
                ]
                let model = AlertModel(
                    title: "",
                    message: "Вы уверены что хотите удалить трекер?",
                    actions: actions,
                    preferredStyle: .actionSheet
                )
                
                AlertPresenter(from: model).presentAlert(from: self)
            }
            
            return UIMenu(children: [edit,delete])
        })
    }
}
