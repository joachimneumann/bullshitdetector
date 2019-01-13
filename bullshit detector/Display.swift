//
//  Display.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 12/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class Display: UIView {

    let displayRed = UIColor(red: 180/255.0, green: 101/255.0, blue:100/255.0, alpha: 1.0)
    let displayGray = UIColor(red:  88/255.0, green: 89/255.0, blue: 82/255.0, alpha: 1.0)

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 223/255.0, green: 218/255.0, blue: 200/255.0, alpha: 1.0)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = UIColor(red: 223/255.0, green: 218/255.0, blue: 200/255.0, alpha: 1.0)
    }
    
    func startAngle() -> CGFloat {
        return CGFloat(.pi*2*(0.5+0.12))
    }
    func endAngle() -> CGFloat {
        return CGFloat(.pi*2*(1.0-0.12))
    }

    func pointerCenter() -> CGPoint {
        return CGPoint(x: self.frame.midX, y: self.frame.height * 1.2)
    }
    func maxRadius() -> CGFloat {
        return radius() * 1.12
    }
    private func radius() -> CGFloat {
        return self.frame.height * 0.8
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
        let radiusUpper = radius() * 1.07
        let innerRadius = radius() * 0.93
        let mid: CGFloat = startAngle() + 0.7*(endAngle()-startAngle())
        var track = UIBezierPath(arcCenter: center, radius: radius() - (5 / 2), startAngle: startAngle(), endAngle: mid, clockwise: true)
        track.lineWidth = 5
        track.lineCapStyle = .butt
        displayGray.setStroke()
        track.stroke()

        track = UIBezierPath(arcCenter: center, radius: radius() - (5 / 2), startAngle: mid, endAngle: endAngle(), clockwise: true)
        track.lineWidth = 5
        displayRed.setStroke()
        track.stroke()

        track = UIBezierPath(arcCenter: center, radius: radiusUpper - (1 / 2), startAngle: startAngle(), endAngle: mid, clockwise: true)
        track.lineWidth = 1
        displayGray.setStroke()
        track.stroke()
        
        track = UIBezierPath(arcCenter: center, radius: radiusUpper - (1 / 2), startAngle: mid, endAngle: endAngle(), clockwise: true)
        track.lineWidth = 1
        displayRed.setStroke()
        track.stroke()
        for factor in [0] {
            let a = UIBezierPath(arcCenter: center, radius: maxRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: center, radius: innerRadius, startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, toPoint: b, ofColor: displayGray, inView: self)
        }
        for factor in [0.7, 1] {
            let a = UIBezierPath(arcCenter: center, radius: maxRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: center, radius: innerRadius, startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, toPoint: b, ofColor: displayRed, inView: self)
        }
        for factor in [0.12, 0.2, 0.265, 0.32, 0.37, 0.42, 0.47, 0.52, 0.57, 0.62, 0.66] {
            let a = UIBezierPath(arcCenter: center, radius: maxRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: center, radius: radiusUpper, startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, toPoint: b, ofColor: displayGray, inView: self)
        }
        for factor in [0.79, 0.87, 0.94] {
            let a = UIBezierPath(arcCenter: center, radius: maxRadius(), startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            let b = UIBezierPath(arcCenter: center, radius: radiusUpper, startAngle: startAngle(), endAngle: startAngle()+(endAngle()-startAngle())*CGFloat(factor), clockwise: true).currentPoint
            drawLineFrom(start: a, toPoint: b, ofColor: displayRed, inView: self)
        }
    }
}
