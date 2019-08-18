//
//  NoteTableViewController.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 16/07/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit

class NoteTableViewController: UITableViewController {
    
    var noteBook = FileNotebook()
    var notes = [Note]()
    var editMode = false
    var selectedRow: Int?
    
    let backendQueue = OperationQueue()
    let dbQueue = OperationQueue()
    let commonQueue = OperationQueue()
    var accessToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       configureData()
       createBarButton()
       configureBarButton()
        
    }
    
   private func  configureData() {
    

  // print( KeychainWrapper.standard.removeObject(forKey: "url"))
    guard KeychainWrapper.standard.string(forKey: "SecretToken") != nil  else {
        let authView = (self.storyboard?.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController)
        authView!.delegate = self
        
        self.present(authView!, animated: true, completion: nil)
        return
    }
    
    //вызов LoadNotesOperation

  let op =   LoadNotesOperation(notebook: noteBook, backendQueue: backendQueue, dbQueue: dbQueue)
    
    op.completionBlock = {
        let updateUI = BlockOperation {
            
            self.prepareNoteArray()
            self.tableView.reloadData()
        }
        OperationQueue.main.addOperation(updateUI)
    }
   
    OperationQueue().addOperation(op)

    }
    

    private func prepareNoteArray(){
        notes = []
        for (_, value) in noteBook.notes {
        notes.append(value)
        }
    }
    private func configureBarButton() {
        if let leftBarButton = navigationItem.leftBarButtonItem {
            leftBarButton.tintColor = editMode ? .red : .blue
            leftBarButton.title = editMode ? "Done" : "Edit"
        }
    }
    private  func createBarButton(){
        let leftBarButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItem.Style.plain, target: self, action: #selector(editPressed))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    @objc func editPressed() {
       editMode = !editMode
        configureBarButton()
    }
    

    //возвращаем новую или отредактированную заметку 
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue){
        if  unwindSegue.identifier == "back" {
            let sourceVC = unwindSegue.source as? NoteViewController
            guard  let receiveNote = sourceVC?.currentNote! else {return}
            //вызов SaveNoteOperation
          
           SaveNoteOperation(note: receiveNote,
                            notebook: noteBook,
                            backendQueue: backendQueue,
                            dbQueue: dbQueue).start()
            
            let updateUI = BlockOperation {
              
                self.prepareNoteArray()
                self.tableView.reloadData()
            }
            OperationQueue.main.addOperation(updateUI)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if let seg = segue.identifier,
            seg == "editNoteSegue" {
            if let noteVC = segue.destination as? NoteViewController,
                let selectedRow = selectedRow  {
                noteVC.currentNote = notes[selectedRow]
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as! NoteTableViewCell
        cell.colorNote.backgroundColor = notes[indexPath.row].color
        cell.contentLabel.text = notes[indexPath.row].content
        cell.titleLabel.text = notes[indexPath.row].title
        

        return cell
    }

  override  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
  override  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // вызов RemoveNoteOperation
            let removeOper = RemoveNoteOperation(note: notes[indexPath.row],
                                                          notebook: noteBook,
                                                          backendQueue: backendQueue,
                                                          dbQueue: dbQueue)
           
            removeOper.completionBlock = {
                let updateUI = BlockOperation {
                    
                    print("количество при обновлении \(self.noteBook.notes.count)")
                    self.prepareNoteArray()
                    self.tableView.reloadData()
                }
                OperationQueue.main.addOperation(updateUI)
            }
            commonQueue.addOperation(removeOper)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return editMode ? UITableViewCell.EditingStyle.delete : UITableViewCell.EditingStyle.none
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
     
        selectedRow = indexPath.row
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

 }
extension NoteTableViewController: TokenKeeper
{
    func updateToken(_ token: String) {
        KeychainWrapper.standard.set(token, forKey: "SecretToken")
        
       configureData()
    }
    
}

