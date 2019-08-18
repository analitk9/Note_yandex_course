//
//  FileNotebook.swift
//  YaNote
//
//  Created by Denis Evdokimov on 27/06/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import Foundation
import CocoaLumberjack

class FileNotebook {
    private let filePath = "notes_storage"
    private(set) var notes = [String: Note]()
    
    public func add(_ note: Note?){
        if let note = note {
            notes[note.uid] = note
        }
    }
    
    public func remove(with uid: String) {
        notes[uid] = nil
    }

    public func returnNoteArray()->[Note]{
       var notesArr = [Note]()
        for (_, value) in notes {
            notesArr.append(value)
        }
        return notesArr
    }
    
    
    public func fill(by notes: [Note]) {
        for note in notes {
            add(note)
        }
    }
    public func fillbyDict(notesDict: [String: Note]) {
       self.notes = notesDict
        
    }
    
  
    func simpleDataNoteCreate(){
        add(Note( title: "Первая заметка", content: "Текст первой заметки, короткий", color: .red, important: .normal, destructionDate: nil))
        add(Note( title: "Вторая заметка", content: "Текст второй заметки, тоже короткий", color: .green, important: .critical, destructionDate: nil))
        add(Note( title: "Третья заметка", content: "Текст третьей заметки, уже длиннее и длиннее", color: .gray, important: .unimportant, destructionDate: nil))
        add(Note( title: "Четвертая заметка", content: "Текст четвертой заметки. Тут уже повторы повторы. Тут уже повторы повторы.Тут уже повторы повторы.Тут  уже повторы повторы.Тут уже повторы повторы.Тут уже повторы повторы.", color: .yellow, important: .normal, destructionDate: nil))
        add(Note( title: "Пятая заметка", content: "Текст пятой заметки", color: .cyan, important: .normal, destructionDate: nil))
        add(Note( title: "Шестая заметка", content: "Текст шестой заметки, опять средней длины или чуть больше чем средней", color: .blue, important: .normal, destructionDate: nil))
        add(Note( title: "Седьмая заметка", content: "Текст седьмой заметки заметно отличается от вего что было написано раньше, тем что тут нет ни каких повторов", color: .black, important: .normal, destructionDate: nil))
        
    }
}
