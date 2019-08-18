import Foundation
import CoreData

enum SaveNotesDBResult {
    case success
    case failure(NetworkError)
}


class SaveNoteDBOperation: BaseDBOperation {
    let note: Note
    var result: SaveNotesDBResult?
    let notebookService = NotebookService()
    let bgContext: NSManagedObjectContext!
    
    init(note: Note,
         notebook: FileNotebook,
         bgContext: NSManagedObjectContext) {
        self.note = note
        self.bgContext = bgContext
        super.init(notebook: notebook)
    }
    
    override func main() {
         notebook.add(note)
        if notebookService.saveToDB(note: note, bgContext: bgContext) {
           result = .success
             finish()
        } else {
            result = .failure(.unreachable)
             print("save to file wronge")
             finish()
        }
   
       
    }
}
