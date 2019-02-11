//
//  Display.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 12/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

@IBDesignable
class Display: UIView, CAAnimationDelegate {

    private var _lineWidth: CGFloat = 7

    private var needleValue: Double = 0.5
    private var needleShapeLayer: CAShapeLayer?
    
    @IBInspectable var value: Double {
        get { return needleValue }
        set {
            var new = newValue
            if new < 0.0 { new = 0 }
            if new > 1.0 { new = 1 }
            drawNeedle(newValue: new)
        }
    }

    @IBInspectable
    var displayRed: UIColor = bullshitRed

    @IBInspectable
    var displayGray: UIColor = UIColor(red:  88/255.0, green: 89/255.0, blue: 82/255.0, alpha: 1.0)
    
    @IBInspectable var borderWidth: Int {
        get { return Int(self.layer.borderWidth) }
        set { self.layer.borderWidth = CGFloat(newValue) }
    }
    
    @IBInspectable var lineWidth: CGFloat {
        get { return _lineWidth }
        set { _lineWidth = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: self.layer.borderColor!) }
        set { self.layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var cornerRadius: Double {
        get { return Double(self.layer.cornerRadius) }
        set { self.layer.cornerRadius = CGFloat(newValue) }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
    }


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func layoutSubviews() {
        drawBackground()
        drawNeedle(newValue: needleValue)
    }

    func startAngle() -> CGFloat {
        return CGFloat(.pi*2*(0.5+0.11))
    }
    func endAngle() -> CGFloat {
        return CGFloat(.pi*2*(1.0-0.11))
    }

    func displayCenter() -> CGPoint {
        return CGPoint(x: self.bounds.midX, y: self.bounds.origin.y + 1.2 * self.bounds.size.height)
    }
    func outerRadius() -> CGFloat {
        return radius() * 1.12
    }
    private func radius() -> CGFloat {
        return self.frame.height * 0.95
    }

    func drawNeedle(newValue: Double) {
        let start = UIBezierPath(arcCenter: displayCenter(), radius: outerRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(needleValue), clockwise: true).currentPoint
        let end = displayCenter()
        
        let needlePath = UIBezierPath()
        needlePath.move(to: start)
        needlePath.addLine(to: end)

        needleShapeLayer?.removeFromSuperlayer()
        needleShapeLayer = CAShapeLayer()
        needleShapeLayer!.path = needlePath.cgPath
        needleShapeLayer!.strokeColor = displayRed.cgColor
        needleShapeLayer!.fillColor = nil
        needleShapeLayer!.lineWidth = 10
        needleShapeLayer!.lineCap = .round
        
//        needleShapeLayer!.removeAllAnimations()
        let circularAnimation = CABasicAnimation(keyPath: "transform.rotation")
        circularAnimation.delegate = self
        circularAnimation.fromValue = startAngle() - 1.5 * .pi
        circularAnimation.toValue = endAngle() - 1.5 * .pi
        circularAnimation.duration = 2
        circularAnimation.repeatCount = 1
        circularAnimation.fillMode = CAMediaTimingFillMode.forwards;
        circularAnimation.isRemovedOnCompletion = false
        let x = needlePath.cgPath.boundingBox
        needleShapeLayer!.bounds = x
        needleShapeLayer?.position =  displayCenter()
        needleShapeLayer!.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        needleShapeLayer!.add(circularAnimation, forKey: "dummykey")
        layer.addSublayer(needleShapeLayer!)
        layer.masksToBounds = true
     }
    
    private func drawBackground() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let radiusUpper = radius() * 1.07
        let innerRadius = radius() * 0.9
        let mid: CGFloat = startAngle() + 0.7*(endAngle()-startAngle())
        var path = UIBezierPath(arcCenter: displayCenter(), radius: radius() - (5 / 2), startAngle: startAngle(), endAngle: mid, clockwise: true)
        path.lineCapStyle = .butt
        addLineSublayer(path: path, color: displayGray, lineWidth1: false)
        
        path = UIBezierPath(arcCenter: displayCenter(), radius: radius() - (5 / 2), startAngle: mid, endAngle: endAngle(), clockwise: true)
        addLineSublayer(path: path, color: displayRed, lineWidth1: false)
        
        path = UIBezierPath(arcCenter: displayCenter(), radius: radiusUpper - (1 / 2), startAngle: startAngle(), endAngle: mid, clockwise: true)
        addLineSublayer(path: path, color: displayGray, lineWidth1: true)
        
        path = UIBezierPath(arcCenter: displayCenter(), radius: radiusUpper - (1 / 2), startAngle: mid, endAngle: endAngle(), clockwise: true)
        addLineSublayer(path: path, color: displayRed, lineWidth1: true)
        
        for factor in [0] {
            let a = UIBezierPath(arcCenter: displayCenter(), radius: outerRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: displayCenter(), radius: innerRadius, startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, end: b, color: displayGray)
        }
        for factor in [0.7, 1] {
            let a = UIBezierPath(arcCenter: displayCenter(), radius: outerRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: displayCenter(), radius: innerRadius, startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, end: b, color: displayRed)
        }
        for factor in [0.12, 0.2, 0.265, 0.32, 0.37, 0.42, 0.47, 0.52, 0.57, 0.62, 0.66] {
            let a = UIBezierPath(arcCenter: displayCenter(), radius: outerRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: displayCenter(), radius: radiusUpper, startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, end: b, color: displayGray)
        }
        for factor in [0.79, 0.87, 0.94] {
            let a = UIBezierPath(arcCenter: displayCenter(), radius: outerRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: displayCenter(), radius: radiusUpper, startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, end: b, color: displayRed)
        }
        for factor in [0.0, 1.0] {
            let a = UIBezierPath(arcCenter: displayCenter(), radius: outerRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            let b = displayCenter()
            drawLineFrom(start: a, end: b, color: displayRed)
        }
    }
    
    func drawLineFrom(start: CGPoint, end:CGPoint, color: UIColor) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = 1
        layer.addSublayer(shapeLayer)
        layer.masksToBounds = true
    }

    private func addLineSublayer(path: UIBezierPath, color: UIColor, lineWidth1: Bool) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineWidth = lineWidth1 ? 1 : _lineWidth
        self.layer.addSublayer(shapeLayer)
    }
    
}

private extension CGFloat {
    var rad: CGFloat { return self * CGFloat.pi / 180.0 }
}

//    override func draw(_ rect: CGRect) {
//    }


//    var value: Double {
//        get {
//            return 0
//        }
//        set(newValue) {
//            var oldAngle = displayStartAngle
//            if let currentAngle = displayPointer.layer.presentation()?.value(forKeyPath: "transform.rotation") as? Double {
//                oldAngle = currentAngle
//            }
//            displayPointer.layer.removeAllAnimations()
//            let circularAnimation = CABasicAnimation(keyPath: "transform.rotation")
//            circularAnimation.delegate = self
//            let startAngle = oldAngle
//            let endAngle = displayStartAngle + newValue * (displayEndAngle-displayStartAngle)
//            circularAnimation.fromValue = startAngle
//            circularAnimation.toValue = endAngle
//            circularAnimation.duration = 0.2
//            circularAnimation.repeatCount = 1
//            circularAnimation.fillMode = CAMediaTimingFillMode.forwards;
//            circularAnimation.isRemovedOnCompletion = false
//            displayPointer.layer.add(circularAnimation, forKey: "dummykey")
//            addSubview(displayPointer)
//        }
//    }


//        self.backgroundColor = displayBackgroundColor
//        displayPointer.layer.cornerRadius = displayPointerFrameWidth/2;
//        var displayPointerFrame: CGRect
//        if #available(iOS 11.0, *) {
//            displayPointerFrame = CGRect(
//                x: pointerCenter().x - displayPointerFrameWidth / 2.0,
//                y: pointerCenter().y - maxRadius() + super.safeAreaInsets.top,
//                width: displayPointerFrameWidth,
//                height: maxRadius())
//        } else {
//            displayPointerFrame = CGRect(
//                x: pointerCenter().x - displayPointerFrameWidth / 2.0,
//                y: pointerCenter().y - maxRadius(),
//                width: displayPointerFrameWidth,
//                height: maxRadius())
//        }
//        displayPointer.frame = CGRect(x: 10, y: 10, width: 100, height: 100) // displayPointerFrame
//        displayPointer.backgroundColor = UIColor.green
//        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 1.0), forView: displayPointer)
//        displayStartAngle = Double(startAngle()) - 1.5 * .pi
//        displayEndAngle = Double(endAngle())   - 1.5 * .pi
//        value = 0.2


//    func setAnchorPoint(anchorPoint: CGPoint, layer: CAShapeLayer) {
//        var newPoint = CGPoint(x: layer.bounds.size.width * anchorPoint.x, y: layer.bounds.size.height * anchorPoint.y)
//        var oldPoint = CGPoint(x: layer.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
//
//        newPoint = __CGPointApplyAffineTransform(newPoint, layer.transform)
//        oldPoint = __CGPointApplyAffineTransform(oldPoint, view.transform)
//
//        var position = view.layer.position
//        position.x -= oldPoint.x
//        position.x += newPoint.x
//
//        position.y -= oldPoint.y
//        position.y += newPoint.y
//
//        layer.position = position
//        layer.anchorPoint = anchorPoint
//    }
//
