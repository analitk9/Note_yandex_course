//
//  NotebookService.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 06/08/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class NotebookService {
    
    
    private func createPath() -> String? {
        guard  let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil}
        let dirurl = path.appendingPathComponent("Notebooks")
        var isDir: ObjCBool = false
        if !FileManager.default.fileExists(atPath: dirurl.path, isDirectory: &isDir), !isDir.boolValue {
            do {
                try FileManager.default.createDirectory(at: dirurl, withIntermediateDirectories: true)
            } catch {
            }
        }
        let filename = dirurl.appendingPathComponent("MyNotebook.sav")
        return filename.path
    }
    
    public func loadFromFile(notebook: FileNotebook)-> FileNotebook?  {
        guard  let filename = createPath() else {return nil}
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filename))
            let js = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            notebook.fillbyDict(notesDict: parse(from: js))
            return notebook
        } catch {
            print ("ошибка чтения файла")
            return nil
        }
    }
    
    public func loadFromDB(notebook: FileNotebook, bgContext: NSManagedObjectContext) -> FileNotebook? {
       var notes = [Note]()

        let fetchRequest: NSFetchRequest<SimpleNote> = SimpleNote.fetchRequest()
        bgContext.performAndWait {
            do {
                let coreDataNotes = try bgContext.fetch(fetchRequest)
                for noteCD in coreDataNotes {
                    // создаем массив [Note]
                    let uid = noteCD.uid!
                    let title = noteCD.title!
                    let content = noteCD.content!
                    let color = noteCD.color as! UIColor
                    let important =   Important.init(rawValue: noteCD.importance!)!
                    let destructionDate = noteCD.selfDestructionDate ?? nil
                    let note = Note(uid: uid, title: title, content: content, color: color, important: important, destructionDate: destructionDate)
                    notes.append(note)
                }
            } catch {
               print(error)
            }
        }
        
        notebook.fill(by: notes)
        
     return notebook
    }

    public func saveToFile(notebook: FileNotebook)-> Bool {
      
        guard  let filename = createPath() else {return false}
        let notesJson = createJson(from: notebook.notes)
        do {
            let data = try JSONSerialization.data(withJSONObject: notesJson , options: [])
            
            return FileManager.default.createFile(atPath: filename, contents: data) // возвращает результат записи
           
        } catch {
            return false
        }
       
    }
    
    public func saveToDB(note: Note, bgContext: NSManagedObjectContext) -> Bool {
        if removeFromDB(note: note, bgContext: bgContext){
            print("это редактирование, удалили для перезаписи")
        }else {
            print("это новая запись")
        }
        var result = false
        let simpleNote = SimpleNote(context: bgContext)
        simpleNote.color = note.color as NSObject
        simpleNote.content = note.content
        simpleNote.importance = note.importance.returnString()
        simpleNote.title = note.title
        simpleNote.uid = note.uid
        simpleNote.selfDestructionDate = note.selfDestructionDate
        bgContext.performAndWait {
            do {
                try  bgContext.save()
                result = true
            } catch  {
                print(error )
            }
        }
        return result
    }
    
    public func removeFromDB(note: Note, bgContext: NSManagedObjectContext) -> Bool {
        var result = false
        
        let fetchRequest: NSFetchRequest<SimpleNote> = SimpleNote.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid = %@", note.uid)
        bgContext.performAndWait {
            do {
                let coreDataNotes = try bgContext.fetch(fetchRequest)
                if coreDataNotes.count != 0 {
                    bgContext.delete(coreDataNotes[0])
                    do {
                        try bgContext.save()
                        result = true
                    } catch {
                        print(error)
                    }
                }
               
                
            } catch {
                print(error)
            }
        }
        
        
        return result
    }
    
    func createJson(from notes:[String: Note]) -> [String: Any] {
        var notesJson = [String: Any]()
        for note in notes {
            notesJson[note.key] = note.value.json
        }
        return notesJson
    }
    
    func parse(from json: [String: Any]) ->  [String: Note]{
        var newNotes = [String: Note]()
        for  value in json {
            let uid = value.key
            let note = Note.parse(json: value.value as! [String : Any])
            newNotes[uid] = note!
        }
        return newNotes
    }
}
