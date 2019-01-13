//
//  Display.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 12/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class Display: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 223/255.0, green: 218/255.0, blue: 200/255.0, alpha: 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor(red: 223/255.0, green: 218/255.0, blue: 200/255.0, alpha: 1.0)
    }
    
    func drawLineFrom(start: CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view: UIView) {
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.0
        view.layer.addSublayer(shapeLayer)
    }
    
    override func draw(_ rect: CGRect) {
        let displayRed = UIColor(red: 180/255.0, green: 101/255.0, blue:100/255.0, alpha: 1.0)
        let displayGray = UIColor(red:  88/255.0, green: 89/255.0, blue: 82/255.0, alpha: 1.0)
        let center: CGPoint = CGPoint(x: rect.midX, y: rect.height * 1.2)
        let radiusMain: CGFloat = rect.height * 0.8
        let radiusUpper = radiusMain * 1.07
        let r1 = radiusMain * 1.12
        let r2 = radiusMain * 0.93
        let anglediff: CGFloat = 0.12
        let start: CGFloat = .pi*2*(0.5+anglediff)
        let end: CGFloat   = .pi*2*(1.0-anglediff)
        let mid: CGFloat = start + 0.7*(end-start)

        var track = UIBezierPath(arcCenter: center, radius: radiusMain - (5 / 2), startAngle: start, endAngle: mid, clockwise: true)
        track.lineWidth = 5
        track.lineCapStyle = .butt
        displayGray.setStroke()
        track.stroke()

        track = UIBezierPath(arcCenter: center, radius: radiusMain - (5 / 2), startAngle: mid, endAngle: end, clockwise: true)
        track.lineWidth = 5
        displayRed.setStroke()
        track.stroke()

        track = UIBezierPath(arcCenter: center, radius: radiusUpper - (1 / 2), startAngle: start, endAngle: mid, clockwise: true)
        track.lineWidth = 1
        displayGray.setStroke()
        track.stroke()
        
        track = UIBezierPath(arcCenter: center, radius: radiusUpper - (1 / 2), startAngle: mid, endAngle: end, clockwise: true)
        track.lineWidth = 1
        displayRed.setStroke()
        track.stroke()
        for factor in [0] {
            let a = UIBezierPath(arcCenter: center, radius: r1, startAngle: start, endAngle: start+(end-start)*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: center, radius: r2, startAngle: start, endAngle: start+(end-start)*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, toPoint: b, ofColor: displayGray, inView: self)
        }
        for factor in [0.7, 1] {
            let a = UIBezierPath(arcCenter: center, radius: r1, startAngle: start, endAngle: start+(end-start)*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: center, radius: r2, startAngle: start, endAngle: start+(end-start)*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, toPoint: b, ofColor: displayRed, inView: self)
        }
        for factor in [0.12, 0.2, 0.265, 0.32, 0.37, 0.42, 0.47, 0.52, 0.57, 0.62, 0.66] {
            let a = UIBezierPath(arcCenter: center, radius: r1, startAngle: start, endAngle: start+(end-start)*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: center, radius: radiusUpper, startAngle: start, endAngle: start+(end-start)*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, toPoint: b, ofColor: displayGray, inView: self)
        }
        for factor in [0.79, 0.87, 0.94] {
            let a = UIBezierPath(arcCenter: center, radius: r1, startAngle: start, endAngle: start+(end-start)*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: center, radius: radiusUpper, startAngle: start, endAngle: start+(end-start)*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, toPoint: b, ofColor: displayRed, inView: self)
        }

        let a = UIBezierPath(arcCenter: center, radius: r1, startAngle: start, endAngle: start+(end-start)*CGFloat(0.5), clockwise: true).currentPoint
        let b = UIBezierPath(arcCenter: center, radius: 0, startAngle: start, endAngle: start+(end-start)*CGFloat(0.5), clockwise: true).currentPoint
        let pointer = UIBezierPath()
        pointer.move(to: a)
        pointer.addLine(to: b)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = pointer.cgPath
        shapeLayer.strokeColor = displayGray.cgColor
        shapeLayer.lineWidth = 3.5
        self.layer.addSublayer(shapeLayer)
        var transform = CATransform3DIdentity
        transform.m34 = 1.0/500.0
        setAnchorPoint(anchorPoint: CGPoint(x: 1.0, y: 1.0), forView: self)
        transform = CATransform3DRotate(transform, CGFloat(45*Double.pi/180), 0, 0, 1)
        shapeLayer.transform = transform
//        shapeLayer.add(circularAnimation, forKey: "transform")
    }
    func setAnchorPoint(anchorPoint: CGPoint, forView view: UIView) {
        var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x, y: view.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x, y: view.bounds.size.height * view.layer.anchorPoint.y)
        
        newPoint = __CGPointApplyAffineTransform(newPoint, view.transform)
        oldPoint = __CGPointApplyAffineTransform(oldPoint, view.transform)
        
        var position = view.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        view.layer.position = position
        view.layer.anchorPoint = anchorPoint
    }
//    let circularAnimation: CAAnimation = {
//        let animation = CABasicAnimation()
//        animation.fromValue = 0
//        animation.toValue = 0.4
//        animation.duration = 2
//        animation.repeatCount = MAXFLOAT
//        return animation
//    }()
}
