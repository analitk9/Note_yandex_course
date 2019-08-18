//
//  RemoveNoteOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Denis Evdokimov on 27/07/2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation
import CoreData
class RemoveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private var saveToBackend: SaveNotesBackendOperation?
    private var removeDBOperation: RemoveNoteDBOperation?
    private(set) var result: Bool? = false
    private let bgContext: NSManagedObjectContext!
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue, bgContext:  NSManagedObjectContext) {
        self.note = note
        self.notebook = notebook
        self.bgContext = bgContext
        super.init()
        
        self.notebook.remove(with: note.uid)
        
        let saveToBackend = SaveNotesBackendOperation(notebook:  self.notebook)
        self.saveToBackend = saveToBackend
        
        let removeDBBlock = BlockOperation {
            let removeDBOperation = RemoveNoteDBOperation(note: note, notebook: notebook, bgContext: bgContext)
            self.removeDBOperation = removeDBOperation
            self.addDependency(removeDBOperation)
            backendQueue.addOperation(removeDBOperation)
        }
            self.addDependency(removeDBBlock)
            removeDBBlock.addDependency(saveToBackend)
            dbQueue.addOperation(removeDBBlock)
            self.addDependency(saveToBackend)
        
        self.addDependency(saveToBackend)
        backendQueue.addOperation(saveToBackend)
        
        
    }
    
    override func main() {
        
//        switch saveToBackend!.result! {
//        case .success( let notebook):
//            SaveNoteDBOperation(note: note, notebook: notebook, bgContext: bgContext).start()
//            result = true
//        case .failure:
//            result = false
//        }
//        
        
        finish()
    }
}
