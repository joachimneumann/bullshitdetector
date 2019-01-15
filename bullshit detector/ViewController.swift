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

    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var displayPointer: UIView!
    @IBOutlet weak var display: Display!
    @IBOutlet weak var analyseButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var waveView: AnimatedWaveView?
    let random = GKRandomSource()
    let distribution = GKGaussianDistribution(lowestValue: -100, highestValue: 100)
    var noiseTimer: Timer!
    var targetValue: Double = 0.3
    let displayPointerFrameWidth: CGFloat = 6
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
        animationView.isHidden = true
        imageView.isHidden = true
        coverView.backgroundColor = UIColor.white
        animationView.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        super.viewDidLoad()
        noiseTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(noise), userInfo: nil, repeats: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleButtonTap(_:)))
        analyseButton.addGestureRecognizer(tap)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        imageView.addGestureRecognizer(imageTap)
        imageView.isUserInteractionEnabled = true
        analyseButton.layer.cornerRadius = 10
        analyseButton.setTitle("Analysing...", for: .disabled)
        analyseButton.setTitle("Is that true?", for: .normal)
        displayPointer.layer.cornerRadius = displayPointerFrameWidth/2;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let animatedWaveView = AnimatedWaveView(frame: animationView.bounds)
        animationView.layer.cornerRadius = min(animationView.frame.size.height, animationView.frame.size.width) / 2
        waveView = animatedWaveView
        animationView.addSubview(animatedWaveView)
        waveView?.makeWaves()
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

    @objc func handleButtonTap(_ sender: UITapGestureRecognizer) {
        imageView.isHidden = true
        animationView.isHidden = false
        analyseButton.isEnabled = false
        let tabPosition = (analyseButton.frame.size.width - sender.location(in: analyseButton).x) / analyseButton.frame.size.width

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.targetValue = self.targetValue + 0.3*(Double(tabPosition)-self.targetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.targetValue = self.targetValue + 0.6*(Double(tabPosition)-self.targetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.animationView.isHidden = true
            self.targetValue = Double(tabPosition)
            self.analyseButton.isEnabled = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.2) {
            self.imageView.isHidden = false
            if tabPosition > 0.9 {
                self.imageView.image = UIImage(named: "absolute bullshit")
            } else if tabPosition > 0.8 {
                self.imageView.image = UIImage(named: "bullshit")
            } else if tabPosition > 0.4 {
                self.imageView.image = UIImage(named: "resonable")
            } else if tabPosition > 0.25 {
                self.imageView.image = UIImage(named: "mostly true")
            } else {
                self.imageView.image = UIImage(named: "true")
            }
        }
    }

    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        imageView.isHidden = true
        animationView.isHidden = true
        targetValue = 0.3
    }

    @objc func noise() {
        let n = distribution.nextInt()
        var newValue = targetValue + 0.001 * Double(n)
        if newValue < 0.0 { newValue = 0.0 }
        if newValue > 1.02 { newValue = 1.02 } // allow a bit more than 100% bullshit
        value = newValue
    }

}

