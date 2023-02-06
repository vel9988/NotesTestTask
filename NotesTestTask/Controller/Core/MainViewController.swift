//
//  MainViewController.swift
//  NotesTestTask
//
//  Created by Dmitryi Velko on 02.02.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Property
    private var notes = [NoteItem]()
    
    
    // MARK: - Subviews
    private let notesTable: UITableView = {
        let table = UITableView()
        let identifier = NotesTableViewCell.identifier
        table.register(NotesTableViewCell.self, forCellReuseIdentifier: identifier )
        return table
    }()

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Notes"
        view.addSubview(notesTable)
        
        notesTable.delegate = self
        notesTable.dataSource = self
        
        configureNavBar()
        fetchLocalNotes()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("add"),
                                               object: nil,
                                               queue: nil) { _ in
            self.fetchLocalNotes()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        notesTable.frame = view.bounds
    }
    
    //MARK: - Private method
    private func fetchLocalNotes() {
        DataPersistenceManager.shared.fetchingNotesFromDatabase { [weak self] result in
            switch result {
            case .success(let notes):
                self?.notes = notes
                DispatchQueue.main.async {
                    self?.notesTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar() {
        let imageButton = UIImage(systemName: "plus")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: imageButton,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addAction))
    }
    
    //MARK: - Button method
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
        cell.backgroundColor = .systemBlue
        cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let note = notes.reversed()[indexPath.row]
        let noteTitle = note.title ?? "Note"
        cell.configure(with: NoteViewModel(noteTitle: noteTitle))
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteNote(with: notes[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    self?.notes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = notes.reversed()[indexPath.row]
        let noteTitle = note.title ?? ""
        let noteContent = note.note ?? ""
        let image: UIImage?
        if note.image == nil {
            image = nil
        } else {
            image = UIImage(data: note.image!)
        }
        DispatchQueue.main.async { [weak self] in
            let vc = NoteViewController()
            vc.configure(with: noteTitle, note: noteContent, isNewNote: false, noteImage: image)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    
}

