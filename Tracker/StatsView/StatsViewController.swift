//
//  StatsViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 19.05.2025.
//

import UIKit

final class StatsViewController: UIViewController {
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = NSLocalizedString("stats", comment: "")
        obj.textColor = .mainText
        obj.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        return obj
    }()
    
    private lazy var label: UILabel = {
        let obj = UILabel()
        obj.text = NSLocalizedString("statsPlaceholder", comment: "")
        obj.textColor = .mainText
        obj.font = .systemFont(ofSize: 12)
        
        return obj
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(resource: .cryingMan)
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
    
    private lazy var tableView: UITableView = {
        let obj = UITableView(frame: .zero, style: .plain)
        obj.rowHeight = 102
        obj.separatorStyle = .none
        obj.allowsSelection = false
        obj.backgroundColor = .background
        
        return obj
    }()
    
    // MARK: - Private properties
    var trackers: [Tracker] = []
    var trackerStore = TrackerStore()
    var trackerRecordStore = TrackerRecordStore()
    
    var stats: [Stats] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        tableView.dataSource = self
        tableView.register(StatsTableViewCell.self, forCellReuseIdentifier: StatsTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        trackers = trackerStore.trackers
        updatePlaceholderState()
        updateStats()
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.backgroundColor = .background
        view.addSubviews(titleLabel, tableView, placeholderView)

        placeholderView.addArrangedSubview(imageView)
        placeholderView.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 71),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateStats() {
        // TODO: доделать тут все и сохранять статистку куда-то
        let trackersFinished = trackerRecordStore.records.count

        stats = [
            Stats(count: 0, description: NSLocalizedString("bestPeriod", comment: "")),
            Stats(count: 0, description: NSLocalizedString("idealDays", comment: "")),
            Stats(count: trackersFinished, description: NSLocalizedString("trackersCompleted", comment: "")),
            Stats(count: 0, description: NSLocalizedString("average", comment: ""))
        ]
        
        tableView.reloadData()
    }
    
    private func updatePlaceholderState() {
        let isHidden = !trackers.isEmpty
        placeholderView.isHidden = isHidden
        tableView.isHidden = !isHidden
    }
}

// MARK: - UITableViewDataSource
extension StatsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        stats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: StatsTableViewCell.identifier, for: indexPath) as? StatsTableViewCell else {
            return UITableViewCell()
        }
        
        let stat = Stats(
            count: stats[indexPath.row].count,
            description: stats[indexPath.row].description
        )
        
        cell.configuration(stats: stat)
        
        return cell
    }
}
