//
//  NoteViewController.swift
//  NotesTestTask
//
//  Created by Dmitryi Velko on 02.02.2023.
//

import UIKit

class NoteViewController: UIViewController {
    
    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(noteTextView)
        setupConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))

    }
    
    private func setupConstraints() {
        let noteTextViewConstraints = [
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            noteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(noteTextViewConstraints)
    }
    
    @objc private func saveButtonTapped() {
        let noteElement = Note(noteTitle: title, noteContent: noteTextView.text)
        DataPersistenceManager.shared.saveNote(with: noteElement) { result in
            switch result {
            case .success():
                NotificationCenter.default.post(name: NSNotification.Name("add"), object: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    func configure(with title: String, note: String) {
        self.title = title
        noteTextView.text = note
    }


}

