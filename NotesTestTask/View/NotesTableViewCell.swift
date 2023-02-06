//
//  NotesTableViewCell.swift
//  NotesTestTask
//
//  Created by Dmitryi Velko on 02.02.2023.
//

import UIKit

final class NotesTableViewCell: UITableViewCell {
    
    //MARK: - Property
    static let identifier = "NotesTableViewCell"
    
    // MARK: - Subviews
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(noteLabel)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public method
    public func configure(with noteModel: NoteViewModel) {
        noteLabel.text = noteModel.noteTitle
    }
    
    //MARK: - Setup constraints
    private func setupConstraints() {
        let noteLabelConstraints = [
            noteLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            noteLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(noteLabelConstraints)
    }
    
}
