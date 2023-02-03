//
//  ListNotesViewController.swift
//  NotesTestTask
//
//  Created by Dmitryi Velko on 02.02.2023.
//

import UIKit

class ListNotesViewController: UIViewController {
    
    private let listTable: UITableView = {
        let table = UITableView()
        let identifier = NotesTableViewCell.identifier
        table.register(NotesTableViewCell.self, forCellReuseIdentifier: identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(listTable)
        
        listTable.delegate = self
        listTable.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        listTable.frame = view.bounds
    }
    
    func configure(with title: String) {
        self.title = title
    }


}

//MARK: - UITableViewDelegate
extension ListNotesViewController: UITableViewDelegate {
    
}

//MARK: - UITableViewDataSource
extension ListNotesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = NotesTableViewCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        
        
        
        return cell
    }
    
    
}
