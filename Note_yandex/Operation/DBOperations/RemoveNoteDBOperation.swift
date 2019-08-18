//
//  RemoveNoteDBOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Denis Evdokimov on 27/07/2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation
import CoreData
enum RemoveNotesDBResult {
    case success
    case failure(NetworkError)
    
}

class RemoveNoteDBOperation: BaseDBOperation {
    private let note: Note
    var result: RemoveNotesDBResult?
    let bgContext: NSManagedObjectContext!
    init(note: Note,
         notebook: FileNotebook,
         bgContext: NSManagedObjectContext) {
        
        self.bgContext = bgContext
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
       
        notebook.remove(with: note.uid)
        if  NotebookService().removeFromDB(note: note, bgContext: bgContext){
               result = .success
            print("записали изменения в файл")
            finish()
        }else {
            print("error не смогли записать в файл")
            finish()
        }
    }
    
}
