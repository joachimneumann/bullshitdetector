//
//  ViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 12/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var displayPointer: UIView!
    @IBOutlet weak var display: Display!
//    private var _value = 0.0
//    private var _angle = 0.0

    var value: Double {
        get {
            return 0
        }
        set(newValue) {
            var oldAngle = v0
            if let currentAngle = displayPointer.layer.presentation()?.value(forKeyPath: "transform.rotation") as? Double {
                print("newValue \(currentAngle)")
                oldAngle = currentAngle
            }
            displayPointer.layer.removeAllAnimations()
            let circularAnimation = CABasicAnimation(keyPath: "transform.rotation")
            circularAnimation.delegate = self
            let startAngle = oldAngle//v0 + _value * (v1-v0)
            let endAngle = v0 + newValue * (v1-v0)
            circularAnimation.fromValue = startAngle
            circularAnimation.toValue = endAngle
            circularAnimation.duration = 1.0
            circularAnimation.repeatCount = 1
            circularAnimation.fillMode = CAMediaTimingFillMode.forwards;
            circularAnimation.isRemovedOnCompletion = false
            displayPointer.layer.add(circularAnimation, forKey: "xx")
//            _value = newValue
        }
    }
    
    var v0 = 0.0
    var v1 = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        let displayPointerFrameWidth: CGFloat = 10
        let displayPointerFrame = CGRect(
            x: display.pointerCenter().x - displayPointerFrameWidth / 2.0,
            y: display.pointerCenter().y + self.view.safeAreaInsets.top, // nneded for correct center position
            width: displayPointerFrameWidth,
            height: display.maxRadius())
        displayPointer.frame = displayPointerFrame
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 1.0), forView: displayPointer)
        v0 = Double(.pi/2+display.startAngle())
        v1 = Double(.pi/2+display.endAngle())


        value = 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.value = 0.0
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.value = 0.0
//        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let currentAngle = displayPointer.layer.presentation()?.value(forKeyPath: "transform.rotation") as? Double {
            print("animationDidStop \(currentAngle)")
        }
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
}

