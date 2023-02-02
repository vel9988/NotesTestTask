//
//  MainViewController.swift
//  NotesTestTask
//
//  Created by Dmitryi Velko on 02.02.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    private var notes = [NoteElement]()
    
    private let notesTable: UITableView = {
        let table = UITableView()
        let identifier = NotesTableViewCell.identifier
        table.register(NotesTableViewCell.self, forCellReuseIdentifier: identifier )
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notes"
        
        notesTable.delegate = self
        notesTable.dataSource = self
        
        configureNavBar()


        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notesTable.frame = view.bounds
    }
    
    private func configureNavBar() {
        let imageButton = UIImage(systemName: "plus")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageButton,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addAction))
    }
    
    @objc private func addAction() {
        DispatchQueue.main.async { [weak self] in
            let vc = CreatingNoteViewController()
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }


}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = NotesTableViewCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NotesTableViewCell else { return UITableViewCell() }
        let note = notes[indexPath.row]
        let noteTitle = note.title ?? "Notes"
        cell.configure(with: NoteViewModel(noteTitle: noteTitle))
        
        return cell
    }
    
    
}

