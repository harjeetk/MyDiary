//
//  CoreDBAdaptor.swift
//  MyDiary
//
//  Created by Harjeet Singh on 28/11/20.
//

import Foundation
import CoreData
import Foundation

class CoreDBAdaptor: NSObject {

    static let sharedDataAdaptor = CoreDBAdaptor()
    var managedContext = CoreDBManager.sharedDatabase.persistentContainer.viewContext
    
    func saveNotes(_ notes: [MyNotesRecord]) -> [MyNotes]{
        
        var arrayNotes = [MyNotes]()
        
        for note in notes{
            
            let arrayFetchedNotes = fetchNotesWhere(predicate: NSPredicate (format: "cdIdentifier = %@", note.id ?? ""))
            
            var myNote: MyNotes!
            
            if arrayFetchedNotes.count > 0, let fetchedNote = arrayFetchedNotes.first{//Checks if data already present or not
                myNote = fetchedNote
            }else{//Create new object
                myNote = MyNotes(entity: MyNotes.entity(), insertInto: managedContext)
            }
            
            myNote.cdIdentifier = note.id
            myNote.cdTitle = note.title
            myNote.cdContent = note.content
            myNote.cdDate = note.date
            
            arrayNotes.append(myNote)
            CoreDBManager.sharedDatabase.saveContext()
        }
        
        return arrayNotes
    }
    
    func fetchAllNotes() -> [MyNotes] {
        //This will fetch all the conversation without any condition is applied
        var arrayMyNotes:[MyNotes] = []
        let fetchRequest: NSFetchRequest<MyNotes> = MyNotes.fetchRequest()
        do {
            arrayMyNotes = (try managedContext.fetch(fetchRequest))
        } catch {
            print("Cannot fetch")
        }
        return arrayMyNotes
    }
    
    func fetchNotesWhere(predicate:NSPredicate?, sort:[NSSortDescriptor] = [], limit:Int = 0) -> [MyNotes] {
        //This will fetch all the conversation with any condition is applied
        var arrayMyNotes:[MyNotes] = []
        let fetchRequest: NSFetchRequest<MyNotes> = MyNotes.fetchRequest()
        fetchRequest.predicate = predicate
        (limit != 0) ? (fetchRequest.fetchLimit = limit) : nil
        (sort.count != 0) ? (fetchRequest.sortDescriptors = sort) : nil
        do {
            arrayMyNotes = (try managedContext.fetch(fetchRequest))
        } catch {
            print("Cannot fetch")
        }
        return arrayMyNotes
    }
    
    func deleteAllNotes () {
        //This will delete all teh conversation from the local db
        let deleteAll = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "MyNotes"))
        do {
            try managedContext.execute(deleteAll)
        }
        catch {
            print(error)
        }
        
        CoreDBManager.sharedDatabase.saveContext()
    }
    
    func updateNotes(note:MyNotes) {
        let fetchedNotes = fetchNotesWhere(predicate: NSPredicate(format: "cdIdentifier = %@", note.cdIdentifier ?? "0"))
        if fetchedNotes.count != 0 {
            let objectNote = fetchedNotes.first!
            objectNote.cdTitle = note.cdTitle
            objectNote.cdContent = note.cdContent
            objectNote.cdDate = Date().toString(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") //Update to the recent date
            CoreDBManager.sharedDatabase.saveContext()
        }
    }
    
    func deleteNotesWhere(note:MyNotes){
        let fetchedNotes = fetchNotesWhere(predicate: NSPredicate(format: "cdIdentifier = %@", note.cdIdentifier ?? "0"))
        for fetchedNote in fetchedNotes{
            managedContext.delete(fetchedNote)
            CoreDBManager.sharedDatabase.saveContext()
        }
    }
}
