//
//  DataPersistenceManager.swift
//  NotesTestTask
//
//  Created by Dmitryi Velko on 02.02.2023.
//

import Foundation
import UIKit
import CoreData

final class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToOverwriteNote
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()

    func saveNote(with noteElement: Note, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let item = NoteItem(context: context)
        
        item.title = noteElement.noteTitle
        item.note = noteElement.noteContent
        item.image = noteElement.noteImage
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func overwriteNoteInDatabase(title: String, newNote: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSManagedObject>(entityName: "NoteItem")
        request.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            let results = try context.fetch(request)
            let objectToUpdate = results.first
            objectToUpdate?.setValue(newNote, forKey: "note")
            try context.save()
        } catch {
            print(DatabaseError.failedToOverwriteNote.localizedDescription)
        }
    }
    
    func checkingDuplicateInDatabase(title: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSManagedObject>(entityName: "NoteItem")
        request.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            let results = try context.fetch(request)
            return results.count > 0
        } catch let error as NSError {
            print("Error updating object: \(error), \(error.userInfo)")
            return false
        }
    }
    
    func fetchingNotesFromDatabase(completion: @escaping (Result<[NoteItem], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<NoteItem>
        request = NoteItem.fetchRequest()
        
        do {
            let notes = try context.fetch(request)
            completion(.success(notes))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    
    func deleteNote(with model: NoteItem, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
}
