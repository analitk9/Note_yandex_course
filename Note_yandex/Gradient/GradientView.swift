//
//  GradientView.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 07/07/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit



class GradientView: UIView {
   
  
   
  
    @IBOutlet weak var colorViewContainer: UIView!{
        didSet {
            colorViewContainer.layer.borderWidth = 1.0
            colorViewContainer.layer.cornerRadius = 5.0
            colorViewContainer.clipsToBounds = true
        }
    }
    
    
    @IBOutlet weak var selectColorView: UIView!{
        didSet {
            selectColorView.layer.borderWidth = 1.0
        }
    }
    
    @IBOutlet weak var hexColorLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        selectColorView.backgroundColor!.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        let newColor = UIColor(hue: hue, saturation: saturation, brightness: CGFloat(sender.value), alpha: alpha)
        selectColorView.backgroundColor = newColor
       
    
    }
    
    @IBOutlet weak var colorPicker: HSBColorPicker!{
        didSet{
           colorPicker.delegate = self
           colorPicker.layer.borderWidth = 1.0
         
        }
    }


    
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }
    
   
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
       
       
    }
 
}

extension GradientView: HSBColorPickerDelegate {
    func HSBColorColorPickerTouched(sender: HSBColorPicker, color: UIColor, point: CGPoint, state: UIGestureRecognizer.State) {
       hexColorLabel.text = color.toHexString()
       selectColorView.backgroundColor = color
    
    }
    
    
}
