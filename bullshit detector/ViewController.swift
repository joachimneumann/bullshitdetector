//
//  ViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 12/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CAAnimationDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var cover: UIView!
    @IBOutlet weak var displayPointer: UIView!
    @IBOutlet weak var display: Display!
    @IBOutlet weak var analyseButton: UIButton!
   
    var value: Double {
        get {
            return 0
        }
        set(newValue) {
            var oldAngle = v0
            if let currentAngle = displayPointer.layer.presentation()?.value(forKeyPath: "transform.rotation") as? Double {
                oldAngle = currentAngle
            }
            displayPointer.layer.removeAllAnimations()
            let circularAnimation = CABasicAnimation(keyPath: "transform.rotation")
            circularAnimation.delegate = self
            let startAngle = oldAngle//v0 + _value * (v1-v0)
            let endAngle = v0 + newValue * (v1-v0)
            circularAnimation.fromValue = startAngle
            circularAnimation.toValue = endAngle
            circularAnimation.duration = 0.2
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        cover.addGestureRecognizer(tap)
        cover.isUserInteractionEnabled = true
        analyseButton.layer.cornerRadius = 10
    }
    
    override func viewDidLayoutSubviews() {
        let displayPointerFrameWidth: CGFloat = 10
        let displayPointerFrame = CGRect(
            x: display.pointerCenter().x - displayPointerFrameWidth / 2.0,
            y: display.pointerCenter().y - display.maxRadius() + self.view.safeAreaInsets.top,
            width: displayPointerFrameWidth,
            height: display.maxRadius())
        displayPointer.frame = displayPointerFrame
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 1.0), forView: displayPointer)
        v0 = Double(display.startAngle()) - 1.5 * .pi
        v1 = Double(display.endAngle())   - 1.5 * .pi
        value = 0.3
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
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let tabPosition = sender.location(in: cover).x / cover.frame.size.width
        value = Double(tabPosition)
    }

}

