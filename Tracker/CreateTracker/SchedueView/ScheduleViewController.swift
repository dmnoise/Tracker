//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 30.05.2025.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    weak var delegate: CreateHabitViewControllerProotocol?
    
    // MARK: - Init
    init(delegate: CreateHabitViewControllerProotocol? = nil, selectedDays: Set<Weekday> = []) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        self.selectedDays = selectedDays
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    private var selectedDays: Set<Weekday> = []
    private var weekdays = Weekday.allCases
    
    private let titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Расписание"
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 16)
        
        return obj
    }()
    
    private let tableView: UITableView = {
        let obj = UITableView()
        obj.backgroundColor = .fieldBackground
        obj.allowsSelection = false
        obj.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        obj.separatorStyle = .singleLine
        obj.layer.masksToBounds = true
        obj.layer.cornerRadius = 10
        obj.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        
        return obj
    }()
    
    private var saveButton: UIButton = {
        let obj = UIButton()
        obj.backgroundColor = .yaBlack
        obj.tintColor = .yaWhite
        obj.layer.cornerRadius = 16
        obj.setTitle("Готово", for: .normal)
        
        return obj
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        
        saveButton.addTarget(self, action: #selector(didTapSavedButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    // MARK: - Private methods
    private func setupUI() {
        navigationItem.titleView = titleLabel
        view.backgroundColor = .yaWhite
    }
    
    private func setupTableView() {
        
        tableView.dataSource = self
        
        view.addSubviews(saveButton, tableView)
        
        tableView.rowHeight = 75
        
        NSLayoutConstraint.activate([
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.heightAnchor.constraint(equalToConstant: 524),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        tableView.register(WeekdaySwitchCell.self, forCellReuseIdentifier: WeekdaySwitchCell.identifier)
    }
    
    // MARK: - objc
    @objc private func didTapSavedButton() {

        delegate?.updateSelectedDays(weekdays: selectedDays)
        dismiss(animated: true)
    }
    
    @objc private func didTapCancelButton() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekdays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekdaySwitchCell.identifier, for: indexPath) as? WeekdaySwitchCell else {
            return UITableViewCell()
        }
        
        let weekday = weekdays[indexPath.row]
        
        cell.configure(weekday: weekday, isOn: selectedDays.contains(weekday))
        cell.onToggle = { [weak self] weekday, isOn in
            guard let self else { return }
            
            if isOn {
                selectedDays.insert(weekday)
            } else {
                selectedDays.remove(weekday)
            }
        }
        
        return cell
    }
}
