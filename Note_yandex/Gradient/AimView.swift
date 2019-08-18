//
//  AimView.swift
//  Note_yandex
//
//  Created by Denis Evdokimov on 09/07/2019.
//  Copyright © 2019 Denis Evdokimov. All rights reserved.
//

import UIKit
class AimView: UIView {
    
    private var aimPath: UIBezierPath?

    override func draw(_ rect: CGRect) {
        if aimPath == nil {
            
            let path = getCirclePath(in: CGRect(origin: .zero, size: self.frame.size))
            aimPath = path
        }
    }
    private func getCirclePath(in rect: CGRect) -> UIBezierPath {
              
                let path = UIBezierPath()
                path.lineWidth = 1
                // path.append(UIBezierPath.init(rect: rect)) // прямоугольник в который все вписываеть планируем
                let rect2 = rect.insetBy(dx: rect.width / 4 , dy: rect.height / 4) // квадрат уменьшеный в 2 раза
                //path.append(UIBezierPath.init(rect: rect2))
                path.append(UIBezierPath.init(roundedRect: rect2, cornerRadius: rect2.maxX / 2)) // нарисовали круг
                path.move(to: CGPoint(x: rect2.minX, y: rect2.midY))
                path.addLine(to: CGPoint(x: rect.minX , y: rect.midY))// левая линия
                path.move(to: CGPoint(x: rect.midX, y: rect2.minY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))// верхняя линия
                path.move(to: CGPoint(x: rect2.maxX, y: rect2.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))// правая линия
                path.move(to: CGPoint(x: rect2.midX, y: rect2.maxY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))// нижняя линия
                path.stroke()
                return path
    }
    
}
