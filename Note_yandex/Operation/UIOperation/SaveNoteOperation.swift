import Foundation

class SaveNoteOperation: AsyncOperation {
    private let note: Note
    private let notebook: FileNotebook
    private let saveToDb: SaveNoteDBOperation
    private var saveToBackend: SaveNotesBackendOperation?
    
    private(set) var result: Bool? = false
    
    init(note: Note,
         notebook: FileNotebook,
         backendQueue: OperationQueue,
         dbQueue: OperationQueue) {
        self.note = note
        self.notebook = notebook
        
        saveToDb = SaveNoteDBOperation(note: note, notebook: notebook)

        super.init()
        
        let saveToDBTail = BlockOperation {
            let saveToBackend = SaveNotesBackendOperation(notebook: notebook)
            self.saveToBackend = saveToBackend
            self.addDependency(saveToBackend)
            backendQueue.addOperation(saveToBackend)
        }
        saveToDBTail.addDependency(saveToDb)
        dbQueue.addOperation(saveToDBTail)
     
        addDependency(saveToDb)
        addDependency(saveToDBTail)
        dbQueue.addOperation(saveToDb)
    }
    
    override func main() {

        finish()
    }
}
