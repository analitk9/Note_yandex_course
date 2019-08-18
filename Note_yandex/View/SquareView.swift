//
//  squareView.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 04/07/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit
@IBDesignable
class SquareView: UIView {
    
    private var curPath: UIBezierPath?

    
    var bkColor: UIColor? {
        didSet {
            self.backgroundColor = bkColor
        }
    }
    var isSelected: Bool = false {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var shapeSize: CGSize = CGSize(width: 20, height: 20) {
        didSet {
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        guard bkColor != nil else {return}
        if isSelected {
            let p: CGPoint = CGPoint(x:  bounds.midX, y: bounds.minY + 5)
            let path = getCirclePath(in: CGRect(origin: p, size: shapeSize))
            curPath = path
        } else {
            curPath = nil
        }
    }
    private func getCirclePath(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = 1
        path.append(UIBezierPath.init(roundedRect: rect, cornerRadius: rect.maxX / 4)) // нарисовали круг
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.stroke()
   
        return path
    }
}

