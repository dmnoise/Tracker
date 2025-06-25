//
//  CategoryCatalogViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 11.06.2025.
//

import UIKit

protocol CategoryCatalogViewControllerProtocol: AnyObject {
    func setSelectedCategory(indexPath: IndexPath?)
}

final class CategoryCatalogViewController: UIViewController {
    
    weak var delegate: CategoryCatalogViewControllerProtocol?
    
    private lazy var titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Категория"
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 16)
        
        return obj
    }()
    
    private lazy var label: UILabel = {
        let obj = UILabel()
        obj.text = "Привычки и события можно\nобьеденять по смыслу"
        obj.font = .systemFont(ofSize: 12)
        obj.textColor = .yaBlack
        obj.sizeToFit()
        obj.textAlignment = .center
        obj.numberOfLines = 2
        obj.setContentHuggingPriority(.defaultLow, for: .horizontal)
        obj.translatesAutoresizingMaskIntoConstraints = false
        
        return obj
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(resource: .superStar)
        let obj = UIImageView(image: image)
        obj.translatesAutoresizingMaskIntoConstraints = false
        
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
        let obj = UITableView(frame: .zero, style: .insetGrouped)
        obj.rowHeight = 75
        obj.backgroundColor = .clear
        obj.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        obj.allowsSelection = true
        obj.allowsMultipleSelection = false
        
        return obj
    }()
    
    private lazy var createButton: UIButton = {
        let obj = UIButton()
        obj.setTitle("Добавить категорию", for: .normal)
        obj.setTitleColor(.yaWhite, for: .normal)
        obj.backgroundColor = .yaBlack
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    private let trackerCategoryStore = TrackerCategoryStore()
    private var categories: [TrackerCategory] = []
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Init
    init(delegate: CategoryCatalogViewControllerProtocol? = nil, selectedIndexPath: IndexPath? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.delegate = delegate
        self.selectedIndexPath = selectedIndexPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = trackerCategoryStore.categories
        
        setupUI()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
        
        createButton.addTarget(self, action: #selector(didTapCreateCategoryButton), for: .touchUpInside)
    }
    
    // MARK: - Private methods
    private func updateCategoryList() {
        categories = trackerCategoryStore.categories
        placeholderView.isHidden = !categories.isEmpty
        
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.addSubviews(placeholderView, createButton, tableView)
        view.backgroundColor = .white
        placeholderView.addArrangedSubview(imageView)
        placeholderView.addArrangedSubview(label)
        placeholderView.isHidden = !categories.isEmpty
        
        navigationItem.titleView = titleLabel
        
        NSLayoutConstraint.activate([
            placeholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: createButton.topAnchor, constant: -16),
        ])
    }
    
    // MARK: - objc
    @objc private func didTapCreateCategoryButton() {
        let vc = UINavigationController(
            rootViewController: CategoryCreateViewController(delegate: self)
        )
        
        present(vc, animated: true)
    }
}

extension CategoryCatalogViewController: CategoryCreateViewControllerProtocol {
    func didTapCreateCategory(_ title: String) {
        
        trackerCategoryStore.createCategory(TrackerCategory(title: title, trackers: []))
        
        if let selectedIndexPath {
            tableView.deselectRow(at: selectedIndexPath, animated: false)
            self.selectedIndexPath = nil
            delegate?.setSelectedCategory(indexPath: nil)
        }
        
        updateCategoryList()
    }
}

// MARK: - UITableViewDelegate
extension CategoryCatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryTableViewCell else { return }
        
        if let selectedIndexPath {
            guard let cell = tableView.cellForRow(at: selectedIndexPath) as? CategoryTableViewCell else { return }
            cell.setSelected(false)
        }
        
        cell.setSelected(true)
        selectedIndexPath = indexPath
        
        delegate?.setSelectedCategory(indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension CategoryCatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell
        else {
            return UITableViewCell()
        }
        
        let isSelected = selectedIndexPath == indexPath
        cell.textLabel?.text = categories[indexPath.row].title
        cell.setSelected(isSelected)
    
        return cell
    }
}
