//
//  Extansion.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 09/07/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit

extension UIView {
    ///добавление childView  на весь размер parentView
    func addSubview(
        _ subview: UIView,
        constrainedTo anchorsView: UIView, widthAnchorView: UIView? = nil,
        multiplier: CGFloat = 1
        ) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.centerXAnchor.constraint(equalTo: anchorsView.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: anchorsView.centerYAnchor),
            subview.widthAnchor.constraint(
                equalTo: (widthAnchorView ?? anchorsView).widthAnchor,
                multiplier: multiplier
            ),
            subview.heightAnchor.constraint(
                equalTo: anchorsView.heightAnchor,
                multiplier: multiplier
            )
            ])
    }
}
extension UIColor {
    /// преобразование в текстовую HEX-строку цвета
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
}
