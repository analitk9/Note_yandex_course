//
//  LoadNotesDBOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Denis Evdokimov on 27/07/2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation

enum LoadNotesDBResult {
    case success(FileNotebook)
    case failure(NetworkError)
}

class LoadNotesDBOperation: BaseDBOperation {
    
    let notebookService = NotebookService()
    var result: LoadNotesDBResult?
    

    override init(notebook: FileNotebook) {
        
        super.init(notebook: notebook)
    }
    
    override func main() {
        
        if let notes =  notebookService.loadFromFile(notebook: notebook){
           result = .success(notes)
        } else {
            result = .failure(.unreachable)
        }
       
        finish()
    }
}
