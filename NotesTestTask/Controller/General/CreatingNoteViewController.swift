//
//  CreatingNoteViewController.swift
//  NotesTestTask
//
//  Created by Dmitryi Velko on 02.02.2023.
//

import UIKit

final class CreatingNoteViewController: UIViewController {
    
    // MARK: - Subviews
    private let noteTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        let placeholderString = NSAttributedString(string: "Enter the name of the note",
                                                   attributes: [.foregroundColor: UIColor.gray])
        textField.attributedPlaceholder = placeholderString
        textField.font = .systemFont(ofSize: 18)
        textField.backgroundColor = .white
        textField.textColor = .black
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = leftPaddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    private let createButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create", for: .normal)
        button.backgroundColor = .white
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 20
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Back", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 0.3
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        view.addSubview(noteTextField)
        view.addSubview(createButton)
        view.addSubview(backButton)
        
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        createButton.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    //MARK: - Buttons methods
    @objc private func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createAction() {
        
    }
    
    //MARK: - setupConstraint
    private func setupConstraints() {
        let noteTextFieldConstraint = [
            noteTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noteTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            noteTextField.heightAnchor.constraint(equalToConstant: 50),
            noteTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let createButtonConstraint = [
            createButton.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 40),
            createButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            createButton.widthAnchor.constraint(equalToConstant: 140),
            createButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let backButtonConstraint = [
            backButton.topAnchor.constraint(equalTo: noteTextField.bottomAnchor, constant: 40),
            backButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            backButton.widthAnchor.constraint(equalToConstant: 140),
            backButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(noteTextFieldConstraint)
        NSLayoutConstraint.activate(createButtonConstraint)
        NSLayoutConstraint.activate(backButtonConstraint)
    }
    

}
