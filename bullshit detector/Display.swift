//
//  Display.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 12/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit
import GameplayKit

@IBDesignable
class Display: UIView, CAAnimationDelegate {

    private var _lineWidth: CGFloat = 7

    private var needleShapeLayer: CAShapeLayer?
    private var needlePath: UIBezierPath? = nil
    private let circularAnimation = CABasicAnimation(keyPath: "transform.rotation")
    private var noiseTimer: Timer? = nil
    private let distribution = GKGaussianDistribution(lowestValue: -100, highestValue: 100)
    private var targetValue: Double = 0.5
    private var lastNeedleValue: Double = 0.5

    // main public function
    func newTargetValue(targetValue: Double) {
        if noise {
            self.targetValue = targetValue
        } else {
            setNeedleAngle(to: targetValue)
        }
    }
    
    @IBInspectable
    private var value: Double = 0.5 {
        didSet { targetValue = value }
    }

    @IBInspectable
    private var noise: Bool = false

    @IBInspectable
    private var displayRed: UIColor = bullshitRed

    @IBInspectable
    private var displayGray: UIColor = UIColor(red:  88/255.0, green: 89/255.0, blue: 82/255.0, alpha: 1.0)
    
    @IBInspectable
    private var borderWidth: Int {
        get { return Int(self.layer.borderWidth) }
        set { self.layer.borderWidth = CGFloat(newValue) }
    }
    
    @IBInspectable
    private var lineWidth: CGFloat {
        get { return _lineWidth }
        set { _lineWidth = newValue }
    }
    
    @IBInspectable
    private var borderColor: UIColor? {
        get { return UIColor(cgColor: self.layer.borderColor!) }
        set { self.layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable
    private var cornerRadius: Double {
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
        drawVerticalNeedle()
        if noiseTimer == nil {
            noiseTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(applyNoise), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func applyNoise() {
        if noise {
            let n = distribution.nextInt()
            var newValue = targetValue + 0.001 * Double(n)
            if newValue < -0.02 { newValue = -0.02 }
            if newValue > 1.02 { newValue = 1.02 }
            setNeedleAngle(to: newValue)
        }
    }
    
    private func startAngle() -> CGFloat {
        return CGFloat(.pi*2*(0.5+0.11))
    }
    private func endAngle() -> CGFloat {
        return CGFloat(.pi*2*(1.0-0.11))
    }

    private func displayCenter() -> CGPoint {
        return CGPoint(x: self.bounds.midX, y: self.bounds.origin.y + 1.2 * self.bounds.size.height)
    }
    private func outerRadius() -> CGFloat {
        return radius() * 1.12
    }
    private func radius() -> CGFloat {
        return self.frame.height * 0.95
    }

    private func drawVerticalNeedle() {
        let centerAngle = startAngle()+(endAngle()-startAngle())*CGFloat(0.5)
        let start = UIBezierPath(arcCenter: displayCenter(), radius: outerRadius(), startAngle: startAngle(), endAngle: centerAngle, clockwise: true).currentPoint
        let end = displayCenter()
        
        needlePath = UIBezierPath()
        needlePath?.move(to: start)
        needlePath?.addLine(to: end)
        needleShapeLayer?.removeFromSuperlayer()
        needleShapeLayer = CAShapeLayer()
        needleShapeLayer!.path = needlePath?.cgPath
        needleShapeLayer!.strokeColor = displayRed.cgColor
        needleShapeLayer!.fillColor = nil
        needleShapeLayer!.lineWidth = 10
        needleShapeLayer!.lineCap = .round
        needleShapeLayer?.position =  displayCenter()
        let x = needlePath!.cgPath.boundingBox
        needleShapeLayer!.bounds = x
        needleShapeLayer!.anchorPoint = CGPoint(x: 0.5, y: 1.0)
        layer.addSublayer(needleShapeLayer!)
        
        circularAnimation.delegate = self
        circularAnimation.duration = 0.1
        circularAnimation.repeatCount = 1
        circularAnimation.fillMode = CAMediaTimingFillMode.forwards;
        circularAnimation.isRemovedOnCompletion = false

        setNeedleAngle(to: 0.5)
    }
    

    
    private func setNeedleAngle(to: Double) {
        if needlePath != nil {
            let fromAngle = startAngle() + (endAngle() - startAngle()) * CGFloat(lastNeedleValue) - 1.5 * .pi
            let toAngle = startAngle() + (endAngle() - startAngle()) * CGFloat(to) - 1.5 * .pi
            circularAnimation.fromValue = fromAngle
            circularAnimation.toValue = toAngle
            needleShapeLayer!.add(circularAnimation, forKey: "dummykey")
            layer.masksToBounds = true
            lastNeedleValue = to
        }
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
    
    private func drawLineFrom(start: CGPoint, end:CGPoint, color: UIColor) {
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
