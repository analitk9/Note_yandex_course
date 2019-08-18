//
//  NotebookService.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 06/08/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import Foundation

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
