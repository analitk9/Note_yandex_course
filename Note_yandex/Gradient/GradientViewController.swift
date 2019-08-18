//
//  GradientViewController.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 19/07/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit

class GradientViewController: UIViewController {

    @IBOutlet weak var gradientView: GradientView!
    
    var selectColor: UIColor?
    weak var delegate: GradientViewDelegate?
   
 
    override func viewDidLoad() {
        super.viewDidLoad()
       
        gradientView.selectColorView.backgroundColor = selectColor
        let point = gradientView.colorPicker.getPointForColor(color: selectColor ??  UIColor.white)
        gradientView.colorPicker.currentPoint = point
        self.navigationItem.hidesBackButton = true
   
        var alpha: CGFloat = 0.0
        selectColor!.getHue(nil, saturation: nil, brightness: &alpha, alpha: nil)
        gradientView.slider.value = Float(alpha)

    }

    @IBAction func donePressed(_ sender: UIButton) {
     
        delegate?.handleCustomColor( color: gradientView.selectColorView.backgroundColor!)
        navigationController?.popViewController(animated: true)
        
    }
}

protocol GradientViewDelegate: class {
    func handleCustomColor( color: UIColor?)
}
