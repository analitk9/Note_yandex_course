import Foundation

enum NetworkError {
    case unreachable
}

enum SaveNotesBackendResult {
    case success(FileNotebook)
    case failure(NetworkError)
}

class SaveNotesBackendOperation: BaseBackendOperation {
    var result: SaveNotesBackendResult?
    var gistService = GistService()
    let notebook: FileNotebook
    
    init(notebook: FileNotebook) {
    self.notebook = notebook
     super.init()
    }
    
    override func main() {
        // todo  сделать окончание операции только после завершения записи на сервер
        let postGist = gistService.createGist(notebook: notebook)
      //  print("создали гист для записи в бэк  \(postGist)")
        let url = KeychainWrapper.standard.string(forKey: "url")
        let res = gistService.post(gist: postGist!, by: url)
      //  print("сделали запись на сервер статус   \(res)")
        if res {
            result = .success(notebook)
        }else  {
           result = .failure(.unreachable)
        }
        finish()
    }
}
