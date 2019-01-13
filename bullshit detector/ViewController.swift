//
//  ViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 12/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController, CAAnimationDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var cover: UIView!
    @IBOutlet weak var displayPointer: UIView!
    @IBOutlet weak var display: Display!
    @IBOutlet weak var analyseButton: UIButton!
   
    let random = GKRandomSource()
    let distribution = GKGaussianDistribution(lowestValue: -100, highestValue: 100)
    var noiseTimer: Timer!
    var targetValue: Double = 0.3
    let displayPointerFrameWidth: CGFloat = 10
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
        noiseTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(noise), userInfo: nil, repeats: true)

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        analyseButton.addGestureRecognizer(tap)
        analyseButton.isUserInteractionEnabled = true
        analyseButton.layer.cornerRadius = 10
        displayPointer.layer.cornerRadius = displayPointerFrameWidth/2;
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
    
    
    override func viewDidLayoutSubviews() {
        let displayPointerFrame = CGRect(
            x: display.pointerCenter().x - displayPointerFrameWidth / 2.0,
            y: display.pointerCenter().y - display.maxRadius() + self.view.safeAreaInsets.top,
            width: displayPointerFrameWidth,
            height: display.maxRadius())
        displayPointer.frame = displayPointerFrame
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 1.0), forView: displayPointer)
        v0 = Double(display.startAngle()) - 1.5 * .pi
        v1 = Double(display.endAngle())   - 1.5 * .pi
        value = targetValue
    }

    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let tabPosition = sender.location(in: analyseButton).x / analyseButton.frame.size.width
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.targetValue = Double(tabPosition)
        }
    }
    
    @objc func noise() {
        let n = distribution.nextInt()
        var newValue = targetValue + 0.001 * Double(n)
        if newValue < 0.0 { newValue = 0.0 }
        if newValue > 1.0 { newValue = 1.0 }
        value = newValue
    }

}

