//
//  CategoryCreateViewController.swift
//  Tracker
//
//  Created by Dmitriy Noise on 13.06.2025.
//

import UIKit

final class CategoryCreateViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let obj = UILabel()
        obj.text = "Новая категория"
        obj.textColor = .yaBlack
        obj.font = UIFont.systemFont(ofSize: 16)
        
        return obj
    }()
    
    private lazy var nameTextField: UITextField = {
        let obj = UITextField()
        obj.font = UIFont.systemFont(ofSize: 17)
        obj.textColor = .yaBlack
        obj.backgroundColor = .fieldBackground
        obj.layer.cornerRadius = 16
        obj.attributedPlaceholder = NSAttributedString(
            string: "Введите название категории",
            attributes: [.foregroundColor: UIColor.yaDarkGray]
        )
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        obj.leftView = paddingView
        obj.leftViewMode = .always
        obj.rightView = paddingView
        obj.rightViewMode = .always
        
        return obj
    }()
    
    private lazy var createButton: UIButton = {
        let obj = UIButton()
        obj.setTitle("Готово", for: .normal)
        obj.setTitleColor(.yaWhite, for: .normal)
        obj.setTitleColor(.yaWhite, for: .disabled)
        obj.backgroundColor = .yaBlack
        obj.layer.cornerRadius = 16
        
        return obj
    }()
    
    // MARK: - Init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        setupUI()
        createButton(isEnabled: false)
    }
    
    // MARK: - Private methods
    private func setupUI() {
        navigationItem.titleView = titleLabel
        view.backgroundColor = .yaWhite
        view.addTapGestureToHideKeyboard()
        view.addSubviews(nameTextField, createButton)
        
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            createButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func createButton(isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.backgroundColor = isEnabled ? .yaBlack : .yaDarkGray
    }
}

// MARK: - UITextFieldDelegate
extension CategoryCreateViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let isEmptyText = textField.text?.isEmpty ?? true
        createButton(isEnabled: !isEmptyText)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
