//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 18.07.2025.
//

import UIKit

final class FiltersViewController: UIViewController {
    private let viewModel: FiltersViewModel
    private let defaults = UserDefaults.standard
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = NSLocalizedString("filters", comment: "")
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 16)
        
        return obj
    }()
    
    private lazy var tableView: UITableView = {
        let obj = UITableView(frame: .zero, style: .insetGrouped)
        obj.rowHeight = 75
        obj.backgroundColor = .clear
        obj.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        obj.allowsSelection = true
        obj.allowsMultipleSelection = false
        
        return obj
    }()
    
    // MARK: - Init
    init(viewModel: FiltersViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        binding()        
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.addSubviews(tableView)
        view.backgroundColor = .white
        
        navigationItem.titleView = titleLabel
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
    
    private func binding() {
        viewModel.selectedIndexPath.bind { [weak self] selectedIndexPath in
            guard let self, let selectedIndexPath else { return }
            
            for cell in self.tableView.visibleCells {
                guard let indexPath = self.tableView.indexPath(for: cell) else { continue }
                
                let isSelected = indexPath == selectedIndexPath
                (cell as? CategoryTableViewCell)?.setSelected(isSelected)
                
                if isSelected {
                    saveSelectedFilter(at: indexPath)
                    dismiss(animated: true)
                }
            }
        }
    }
    
    private func saveSelectedFilter(at indexPath: IndexPath) {
        let filterType = viewModel.filteres[indexPath.row].type
        defaults.set(filterType.rawValue, forKey: "selectedFilter")
    }
}

// MARK: - UITableViewDelegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell
        else {
            return UITableViewCell()
        }
        
        let cellVM = viewModel.cellViewModel(at: indexPath)
        
        cell.textLabel?.text = cellVM.title
        cell.setSelected(cellVM.isSelected)
        
        return cell
    }
}

