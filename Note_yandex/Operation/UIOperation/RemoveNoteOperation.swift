//
//  RemoveNoteOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Denis Evdokimov on 27/07/2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation

class RemoveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private var saveToBackend: SaveNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        
        super.init()
        
      
            self.notebook.remove(with: note.uid)
            let saveToBackend = SaveNotesBackendOperation(notebook:  self.notebook)
            self.saveToBackend = saveToBackend
            self.addDependency(saveToBackend)
        
        backendQueue.addOperation(saveToBackend)
        
        
    }
    
    override func main() {
        
        
        switch saveToBackend!.result! {
        case .success( let notebook):
            SaveNoteDBOperation(note: nil, notebook: notebook).start()
            result = true
        case .failure:
            result = false
        }
        finish()
    }
}
