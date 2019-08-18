import Foundation

enum SaveNotesDBResult {
    case success
    case failure(NetworkError)
}


class SaveNoteDBOperation: BaseDBOperation {
    private let note: Note?
    var result: SaveNotesDBResult?
    let notebookService = NotebookService()
    
    init(note: Note?,
         notebook: FileNotebook) {
        self.note = note
        super.init(notebook: notebook)
    }
    
    override func main() {
        notebook.add(note)
        if notebookService.saveToFile(notebook: notebook) {
           // print("save to file done")
           result = .success
             finish()
        } else {
            result = .failure(.unreachable)
             print("save to file wronge")
             finish()
        }
   
       
    }
}
