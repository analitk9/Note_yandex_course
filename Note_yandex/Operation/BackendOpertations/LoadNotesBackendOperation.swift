//
//  LoadNotesBackEndOperation.swift
//  ios-online-l5-ops-example
//
//  Created by Denis Evdokimov on 27/07/2019.
//  Copyright © 2019 Dmitry Galimzyanov. All rights reserved.
//

import Foundation


enum LoadNotesBackendResult {
    case success(FileNotebook?)
    case failure(NetworkError)
}

class LoadNotesBackendOperation: BaseDBOperation {
    
    var result: LoadNotesBackendResult?
    let gistService = GistService()
    
    
    override init(notebook: FileNotebook) {
        
        super.init(notebook: notebook)
        
    }
    
    override func main() {
        // todo возвращать правильно результат оперции ( сейчас после асинхронки сразу вызывается финиш и статус failure)
        gistService.getGists{ gists in
            guard let gists = gists else {return}
            if let rawUrl = self.gistService.returnRawUrl(gists: gists){
                    self.gistService.getNotebook(from: rawUrl) { notebook in
                        self.result = .success(notebook)
                        self.finish()
                    }

            }
        }
        KeychainWrapper.standard.removeObject(forKey: "url")
        result = .failure(.unreachable)
       finish()
    }
    
}

