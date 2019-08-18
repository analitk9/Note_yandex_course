//
//  RemoveNoteDBOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Denis Evdokimov on 27/07/2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation

enum RemoveNotesDBResult {
    case success
    case failure(NetworkError)
    
}

class RemoveNoteDBOperation: BaseDBOperation {
    private let note: Note
    var result: RemoveNotesDBResult?
    
    init(note: Note,
         notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
       
        notebook.remove(with: note.uid)
        if  NotebookService().saveToFile(notebook: self.notebook) {
               result = .success
            print("записали изменения в файл")
            finish()
        }else {
            print("error не смогли записать в файл")
            finish()
        }
//        let oper = SaveNoteDBOperation( note: nil, notebook: notebook)
//        oper.completionBlock =  {
//            print("удалили запись RemoveNoteDBOperation")
//             self.finish()
//
//        }
//        OperationQueue().addOperation(oper)
        
        
      
    }
    
}
