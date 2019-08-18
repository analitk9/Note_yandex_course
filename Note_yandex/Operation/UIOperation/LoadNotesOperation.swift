//
//  LoadNotesOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Denis Evdokimov on 27/07/2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation
import CoreData
class LoadNotesOperation: AsyncOperation {
    
    private let notebook: FileNotebook
    private let loadFromDb: LoadNotesDBOperation
    private var loadFromBackend: LoadNotesBackendOperation
    
    private(set) var result: Bool?
    
     init(notebook: FileNotebook,
                  backendQueue: OperationQueue,
                  dbQueue: OperationQueue,
                  bgContext: NSManagedObjectContext) {
        self.notebook = notebook
        loadFromDb = LoadNotesDBOperation(notebook: notebook, bgContext: bgContext)
        loadFromBackend = LoadNotesBackendOperation(notebook: notebook)
        super.init()
        
        self.addDependency(loadFromDb)
        self.addDependency(loadFromBackend)
        loadFromDb.addDependency(loadFromBackend)
        backendQueue.addOperation(loadFromBackend)
        dbQueue.addOperation(loadFromDb)
     
    }
    override func main() {
        print("начинаем загружать данные")
    
        switch loadFromBackend.result! {
        case .success(let notebook):
            if let notebook = notebook {
                let notes = notebook.notes
                //данные с бэка пришли
                result = true
                self.notebook.fillbyDict(notesDict: notes)
                // так как в приоритете всегда бэк, то при получение данных с бэка, перезаписываем ими локальную бд
                _ = NotebookService().saveToFile(notebook: self.notebook)

            }else{
                self.notebook.fillbyDict(notesDict: loadFromDb.notebook.notes)

            }
             finish()
        case .failure:
            result = false
            // в бэке не было данных, взяли из файла

            self.notebook.fillbyDict(notesDict: loadFromDb.notebook.notes)
            finish()


        }

    }
}
