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
    private let viewModel: CategoryCatalogViewModel
    
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = NSLocalizedString("category", comment: "")
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 16)
        
        return obj
    }()
    
    private lazy var label: UILabel = {
        let obj = UILabel()
        obj.text = NSLocalizedString("categoryPlaceholder", comment: "")
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
        obj.setTitle(NSLocalizedString("addCategory", comment: ""), for: .normal)
        obj.setTitleColor(.yaWhite, for: .normal)
        obj.backgroundColor = .yaBlack
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    // MARK: - Init
    init(
        viewModel: CategoryCatalogViewModel,
        delegate: CategoryCatalogViewControllerProtocol? = nil
    ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
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
        
        createButton.addTarget(self, action: #selector(didTapCreateCategoryButton), for: .touchUpInside)
    }
    
    // MARK: - Private methods
    private func setupUI() {
        view.addSubviews(placeholderView, createButton, tableView)
        view.backgroundColor = .white
        placeholderView.addArrangedSubview(imageView)
        placeholderView.addArrangedSubview(label)
        
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
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)
    }
    
    private func binding() {
        viewModel.categories.bind { [weak self] _ in
            guard let self else { return }
            self.placeholderView.isHidden = !viewModel.categories.value.isEmpty
            
            if self.view.window != nil {
                self.tableView.reloadData()
            }
        }
        
        viewModel.selectedIndexPath.bind { [weak self] selectedIndexPath in
            guard let self, let selectedIndexPath else { return }
            
            for cell in self.tableView.visibleCells {
                guard let indexPath = self.tableView.indexPath(for: cell) else { continue }
                
                let isSelected = indexPath == selectedIndexPath
                (cell as? CategoryTableViewCell)?.setSelected(isSelected)
            }
        }
    }
    
    // MARK: - objc
    @objc private func didTapCreateCategoryButton() {
        let vc = UINavigationController(
            rootViewController: CategoryCreateViewController(delegate: self)
        )
        
        present(vc, animated: true)
    }
}

// MARK: - CategoryCreateViewControllerProtocol
extension CategoryCatalogViewController: CategoryCreateViewControllerProtocol {
    func didTapCreateCategory(_ title: String) {
        
        viewModel.createCategory(title: title)
        
        viewModel.selectedIndexPath.value = nil
        delegate?.setSelectedCategory(indexPath: nil)
    }
}

// MARK: - UITableViewDelegate
extension CategoryCatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        viewModel.selectRow(at: indexPath)
        delegate?.setSelectedCategory(indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

// MARK: - UITableViewDataSource
extension CategoryCatalogViewController: UITableViewDataSource {
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
