//
//  ViewController.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 28/06/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var destroyDatePicker: UIDatePicker!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var greenView: SquareView! {
        didSet{
            greenView.bkColor = .green
            greenView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var blueView: SquareView!{
        didSet{
           blueView.bkColor = .blue
           blueView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var redView: SquareView! {
        didSet{
            redView.bkColor = .red
            redView.layer.borderWidth = 1
            
        }
    }
    @IBOutlet weak var customColorView: SquareView!{
        didSet{
            customColorView.layer.borderWidth = 1
        }
    }

    @IBOutlet var interactiveSquare: [SquareView]! {
        didSet {
            for subview in interactiveSquare {
                let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
                tapRecognizer.delegate = self
                subview.addGestureRecognizer(tapRecognizer)
            }
        }
    }
    
    @IBAction func destroyDateSwitched(_ sender: UISwitch) {
        destroyDatePicker.isHidden = !sender.isOn
    }

    var currentNote: Note!
    var selectedColor: UIColor!
    
//- MARK: viewDidLoad
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
     
        //настраиваем верхнюю кнопку назад
        self.navigationItem.hidesBackButton = true
        let leftBeckButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backToTableView))
        self.navigationItem.leftBarButtonItems = [leftBeckButton]
        
       // greenView.isSelected = true

        
        let bar = UIToolbar()
        let reset = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(DoneTapped))
        bar.items = [reset]
        bar.sizeToFit()
        contentTextView.inputAccessoryView = bar
        titleTextField.inputAccessoryView = bar
        
        scrollView.keyboardDismissMode = .onDrag
        scrollView.delegate = self
   
    
        view.addSubview( gradientView, constrainedTo: scrollView, widthAnchorView: scrollView )
        contentTextView.delegate = self
        contentTextView.backgroundColor = UIColor.gray
        contentTextView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(upDateTextView(param:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(upDateTextView(param:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        textViewDidChange(contentTextView)
        
        destroyDatePicker.isHidden = true
        
        if let image = UIImage(named: "gradient") {
            let  gradientImageView = UIImageView(image: image)
            gradientImageView.frame = customColorView.frame
            customColorView.addSubview(gradientImageView, constrainedTo: customColorView)
        }
        
        let touchGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressCustomColor(_:)))
        touchGesture.minimumPressDuration = 0.5
        touchGesture.delegate = self
        //touchGesture.allowableMovement = CGFloat.greatestFiniteMagnitude
        customColorView.addGestureRecognizer(touchGesture)
       
        configureInputField()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        contentTextView.resignFirstResponder()
        
        
    }
    
    private func configureInputField() {
        
        if  currentNote  == nil {
            currentNote =  Note(title: "", content: "", color: .green, important: .normal)
        }
        titleTextField.text = currentNote.title
        contentTextView.text = currentNote.content
        selectedColor = currentNote.color
        switch selectedColor! {
        case .green :
            greenView.isSelected =  true
        case .blue :
            blueView.isSelected =  true
        case .red :
            redView.isSelected =  true
        default:
            customColorView.bkColor = selectedColor
            customColorView.isSelected = true
            
            if  let gradientImage = customColorView.subviews.first {
                gradientImage.removeFromSuperview()
            }
        }
    }
    
    func showAlert() {
        let message = "Перейти в список заметок без сохранения текущей?"
        let alertController = UIAlertController(title: "Внимание", message: message, preferredStyle: .alert)
        
        let actionSave = UIAlertAction(title: "Сохранить",
                                       style: .default,
                                       handler: {(alert: UIAlertAction!) in self.performSegue(withIdentifier: "back", sender: self)})
        
        alertController.addAction(actionSave)
        
        let actionCancel = UIAlertAction(title: "Не сохранять",
                                         style: .default,
                                         handler: {(alert: UIAlertAction!) in self.navigationController?.popViewController(animated: true) })
        
        alertController.addAction(actionCancel)
        
        
        present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "back" {
            currentNote =  Note(uid: currentNote.uid, title: titleTextField.text!, content: contentTextView.text!, color: selectedColor, important: currentNote.importance, destructionDate: currentNote.selfDestructionDate)
        }else if segue.identifier == "gradientSegue" {// прыгаем для выбора кастомного цвета
            (segue.destination as! GradientViewController).selectColor =   customColorView.bkColor == nil ?
                UIColor.white : customColorView.bkColor
            (segue.destination as! GradientViewController).delegate = self
        }
    }
    
//- MARK: @objc handler`ы
    @objc func handleTap(_ recognizer: UIPanGestureRecognizer) {
        guard let recognizerView = recognizer.view,
            let colorView = recognizerView as? SquareView   else {
                return
        }
        guard !colorView.isSelected else {return}
        selectedColor = colorView.backgroundColor!
        colorView.isSelected = !colorView.isSelected
        for subview in interactiveSquare {
            if subview != colorView {
                subview.isSelected = false
            }
        }
    }
    
    @objc func DoneTapped() {
        contentTextView.resignFirstResponder()
        titleTextField.resignFirstResponder()
    }
    @objc func backToTableView(){
        if !currentNote.compare(with: Note(uid: currentNote.uid, title: titleTextField.text!, content: contentTextView.text!, color: selectedColor, important: currentNote.importance, destructionDate: currentNote.selfDestructionDate)) {
            showAlert()
        }else {
             navigationController?.popViewController(animated: true)
        }
    
    }
    
    
    @objc  func upDateTextView(param: NSNotification){
        if let userInfo = param.userInfo {
            let kbRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect)
            let kbFrame = view.convert(kbRect, to: view.window)// переводит локалные коорд(bound) в координаты frame
            
            if param.name == UIResponder.keyboardWillHideNotification{
                contentTextView.contentInset = UIEdgeInsets.zero
            }else
            {
                contentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbFrame.height - contentTextView.frame.minY, right: 0)
                contentTextView.scrollIndicatorInsets = contentTextView.contentInset
            }
            contentTextView.scrollRangeToVisible(contentTextView.selectedRange)
        }
    }
    
    @objc func longPressCustomColor(_ recognizer: UILongPressGestureRecognizer) {
        if  recognizer.state == UIGestureRecognizer.State.ended {
            performSegue(withIdentifier: "gradientSegue", sender: self)
        }
    }

    
}
//- MARK: Extension ViewController
extension NoteViewController: GradientViewDelegate {
    func handleCustomColor( color: UIColor?) {
         customColorView.bkColor = color
        customColorView.isSelected = true
            selectedColor = color
        if  let gradientImage = customColorView.subviews.first {
            gradientImage.removeFromSuperview()
        }
    }
}


extension NoteViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension NoteViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0.0
    }
}

extension NoteViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth: CGFloat = textView.frame.size.width
        let  newSize: CGSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat(MAXFLOAT)))  
        var newFrame: CGRect = textView.frame
        newFrame.size = CGSize(width: max(newSize.width,fixedWidth),height: newSize.height)
        textView.frame = newFrame
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: newSize.height, right: 0)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
         textView.resignFirstResponder()
    }

}




