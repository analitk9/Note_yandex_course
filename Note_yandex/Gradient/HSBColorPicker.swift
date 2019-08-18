import Foundation
import UIKit
internal protocol HSBColorPickerDelegate : NSObjectProtocol {
    func HSBColorColorPickerTouched(sender:HSBColorPicker, color:UIColor, point:CGPoint, state:UIGestureRecognizer.State)
}

@IBDesignable
class HSBColorPicker : UIView {
    
    weak internal var delegate: HSBColorPickerDelegate?
    let saturationExponentTop:Float = 2.0
    let saturationExponentBottom:Float = 1.3
    var currentPoint: CGPoint?
    
    private var aimView:  AimView!
    private var aimPath: UIBezierPath?
    
    
    @IBInspectable var elementSize: CGFloat = 1.0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func initialize() {
        self.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapColor(gestureRecognizer:)))
        self.addGestureRecognizer(tapGesture)
        
        let PanGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panColor(gestureRecognizer:)))
        self.addGestureRecognizer(PanGesture)
        
        let point = currentPoint  ?? .zero
        aimView = AimView(frame:  getRect(center: point, width: 10.0, height: 10.0))
        aimView.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.addSubview(aimView!)
        
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        for y : CGFloat in stride(from: 0.0 ,to: rect.height, by: elementSize) {
            var saturation = y < rect.height / 2.0 ? CGFloat(2 * y) / rect.height : 2.0 * CGFloat(rect.height - y) / rect.height
            saturation = CGFloat(powf(Float(saturation), y < rect.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
            let brightness = y < rect.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(rect.height - y) / rect.height
            for x : CGFloat in stride(from: 0.0 ,to: rect.width, by: elementSize) {
                let hue = x / rect.width
                let color = UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
                context!.setFillColor(color.cgColor)
                context!.fill(CGRect(x:x, y:y, width:elementSize,height:elementSize))
            }
        }
                
    }
    
    func getColorAtPoint(point:CGPoint) -> UIColor {
        let roundedPoint = CGPoint(x:elementSize * CGFloat(Int(point.x / elementSize)),
                                   y:elementSize * CGFloat(Int(point.y / elementSize)))
        var saturation = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(2 * roundedPoint.y) / self.bounds.height
            : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        saturation = CGFloat(powf(Float(saturation), roundedPoint.y < self.bounds.height / 2.0 ? saturationExponentTop : saturationExponentBottom))
        let brightness = roundedPoint.y < self.bounds.height / 2.0 ? CGFloat(1.0) : 2.0 * CGFloat(self.bounds.height - roundedPoint.y) / self.bounds.height
        let hue = roundedPoint.x / self.bounds.width
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    func getPointForColor(color:UIColor) -> CGPoint {
        var hue: CGFloat = 0.0
        var saturation: CGFloat = 0.0
        var brightness: CGFloat = 0.0
        color.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil);
        
        var yPos:CGFloat = 0
        let halfHeight = (self.bounds.height / 2)
        if (brightness >= 0.99) {
            let percentageY = powf(Float(saturation), 1.0 / saturationExponentTop)
            yPos = CGFloat(percentageY) * halfHeight
        } else {
            //use brightness to get Y
            yPos = halfHeight + halfHeight * (1.0 - brightness)
        }
        let xPos = hue * self.bounds.width
        return CGPoint(x: xPos, y: yPos)
    }
    
    
    @objc func panColor(gestureRecognizer: UIPanGestureRecognizer) {
        
        aimView!.center =  gestureRecognizer.location(in: self)
        
     //   if (gestureRecognizer.state == UIGestureRecognizer.State.changed) {
            let point = gestureRecognizer.location(in: self)
            
            let color = getColorAtPoint(point: point)
            self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
      //  }
    }
    
    @objc func tapColor(gestureRecognizer: UITapGestureRecognizer) {
        
        aimView!.center =  gestureRecognizer.location(in: self)
        
        //   if (gestureRecognizer.state == UIGestureRecognizer.State.changed) {
        let point = gestureRecognizer.location(in: self)
        
        let color = getColorAtPoint(point: point)
        self.delegate?.HSBColorColorPickerTouched(sender: self, color: color, point: point, state:gestureRecognizer.state)
        //  }
    }
    
    
    private func getRect(center: CGPoint, width: CGFloat, height: CGFloat)-> CGRect {
        
        let origin: CGPoint = CGPoint(x: center.x - (width / 2), y: center.y - (height / 2))
        
        return  CGRect(origin: origin, size: CGSize(width:width, height: height) )
    }
}
