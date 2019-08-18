//
//  LoadNotesDBOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Denis Evdokimov on 27/07/2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation
import CoreData
enum LoadNotesDBResult {
    case success(FileNotebook)
    case failure(NetworkError)
}

class LoadNotesDBOperation: BaseDBOperation {
    
    let notebookService = NotebookService()
    var result: LoadNotesDBResult?
    let bgContext: NSManagedObjectContext!
    

     init(notebook: FileNotebook, bgContext: NSManagedObjectContext) {
        self.bgContext = bgContext
        super.init(notebook: notebook)
    }
    
    override func main() {
        
        if let notes =  notebookService.loadFromDB(notebook: notebook, bgContext: bgContext){
           result = .success(notes)
        } else {
            result = .failure(.unreachable)
        }
       
        finish()
    }
}
