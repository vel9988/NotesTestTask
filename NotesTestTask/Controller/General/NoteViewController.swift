//
//  NoteViewController.swift
//  NotesTestTask
//
//  Created by Dmitryi Velko on 02.02.2023.
//

import UIKit

class NoteViewController: UIViewController {
    
    //MARK: - Property
    private var isNewNote = true
    
    // MARK: - Subviews
    private let noteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let noteTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(noteImageView)
        view.addSubview(noteTextView)
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .save,
                            target: self,
                            action: #selector(saveButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: .camera,
                            target: self,
                            action: #selector(selectPhoto))
        ]
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    //MARK: - Setup constraint
    private var noteImageViewConstraints: [NSLayoutConstraint]!
    private var noteTextViewConstraints: [NSLayoutConstraint]!

    private func setupConstraints() {
        noteImageViewConstraints = [
            noteImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            noteImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -10),
            noteImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            noteImageView.bottomAnchor.constraint(equalTo: noteTextView.topAnchor, constant: 10)
        ]

        noteTextViewConstraints = [
            noteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            noteTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: noteImageView.image != nil ? 400 : 10),
            noteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]

        NSLayoutConstraint.activate(noteImageViewConstraints)
        NSLayoutConstraint.activate(noteTextViewConstraints)
    }
    
    //MARK: - Buttons methods
    @objc private func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func saveButtonTapped() {
        let image = noteImageView.image
        let imageData = image?.jpegData(compressionQuality: 0.8)
        let noteElement = Note(noteTitle: title, noteContent: noteTextView.text, noteImage: imageData)
        if isNewNote {
            DataPersistenceManager.shared.saveNote(with: noteElement) { result in
                switch result {
                case .success():
                    NotificationCenter.default.post(name: NSNotification.Name("add"), object: nil)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            DataPersistenceManager.shared.overwriteNoteInDatabase(title: title ?? "", newNote: noteTextView.text)
        }
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    //MARK: - Configure
    func configure(with title: String, note: String, isNewNote: Bool, noteImage: UIImage?) {
        self.title = title
        noteTextView.text = note
        self.isNewNote = isNewNote
        noteImageView.image = noteImage
    }
    
}

extension NoteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            noteImageView.image = selectedImage
            NSLayoutConstraint.deactivate(noteImageViewConstraints)
            NSLayoutConstraint.deactivate(noteTextViewConstraints)
            setupConstraints()
        }
        dismiss(animated: true, completion: nil)
    }
}





