//
//  StatsViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 17.05.2025.
//

import UIKit

protocol TrackerViewControllerProtocol: AnyObject {
    func didTapCreate(tracker: Tracker, to category: String)
}

class TrackerViewController: UIViewController, TrackerViewControllerProtocol {
    func didTapCreate(tracker: Tracker, to category: String) {
        loadTrackersService.addTracker(tracker, to: category)
        updateData()
    }
    
    
    private lazy var titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Трекер"
        obj.textColor = .black
        obj.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        return obj
    }()
    
    private lazy var searchView: UISearchBar = {
        let obj = UISearchBar()
        obj.placeholder = "Поиск"
        obj.searchBarStyle = .minimal
        
        return obj
    }()
    
    private lazy var label: UILabel = {
        let obj = UILabel()
        obj.text = "Что будем отслеживать?"
        obj.font = .systemFont(ofSize: 12)
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

    private let loadTrackersService = LoadTrackersService.shared
    
    private let paramCV = GeometricParams(cellCount: 2, leftInset: 16, rightInset: 16, cellSpacing: 9)
  
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        setupUI()
        setupNavigationBar()
        setupConstrains()
        setupCollectionView()
        view.addTapGestureToHideKeyboard()
    }

    
    // MARK: - Private methods
    private func updateData() {
        categories = loadTrackersService.loadData()
        updateVisibleTrackers()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
    }
    
    private func setupConstrains() {
        
        view.addSubviews(titleLabel, searchView, collectionView, placeholderView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderView.addArrangedSubview(imageView)
        placeholderView.addArrangedSubview(label)
                
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            searchView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            searchView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchView.heightAnchor.constraint(equalToConstant: 36),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            collectionView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 10),
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
    
    private func updateVisibleTrackers() {
        
        guard let categories else { return }
        
        visibleCategories = categories.filteredHabitsAndEvents(on: selectedDate, recordTrackers: completedTrackers)
        
        updatePlaceholderState()
        collectionView.reloadData()
    }
    
    // MARK: - objc
    @objc private func datePickerValueChanget(_ sender: UIDatePicker) {
        
        let selectedDate = sender.date
        self.selectedDate = selectedDate
        
        updateVisibleTrackers()
    }
    
    @objc private func createTracker() {
        present(
            UINavigationController(rootViewController: SelectTypeTrackerViewController(delegate: self)),
            animated: true
        )
    }
}

// MARK: - TrackerCellDelegate
extension TrackerViewController: TrackerCellDelegate {
    func didTapCompletedButton(_ cell: TrackerCell, isCompleted: Bool) {
        
        guard
            let trackerID = cell.trackerID,
            selectedDate <= Date()
        else { return }
        
        let tracker = TrackerRecord(trackerID: trackerID, date: selectedDate)
        
        if isCompleted {
            completedTrackers.insert(tracker)
        } else {
            completedTrackers.remove(tracker)
        }
        
        cell.changeCompletedButtonStatus()
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
         
        cell.prepareForReuse()
        cell.delegate = self
        cell.configure(
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
        view.titleLabel.text = categories?[indexPath.section].title
        
        return view
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackerViewController: UICollectionViewDelegateFlowLayout {

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
}
