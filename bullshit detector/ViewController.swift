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
    @IBOutlet weak var displayLabel: UITextField!
    @IBOutlet weak var displayLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewToRightOfButton: UIView!
    @IBOutlet weak var viewToLeftOfButton: UIView!
    @IBOutlet weak var instructionsImageView: UIImageView!
    
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
            let startAngle = oldAngle
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
        let instructionsShown = UserDefaults.standard.object(forKey: "instructionsShown") as? Bool ?? false
        if instructionsShown {
            instructionsImageView.isHidden = true
        }
        self.view.backgroundColor = displayBackgroundColor
        
        animationView.isHidden = true
        imageView.isHidden = true
        coverView.backgroundColor = UIColor.white
        animationView.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        super.viewDidLoad()
        noiseTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(noise), userInfo: nil, repeats: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleButtonTap(_:)))
        analyseButton.addGestureRecognizer(tap)

        let tapRight = UITapGestureRecognizer(target: self, action: #selector(self.handleButtonTapRight(_:)))
        viewToRightOfButton.addGestureRecognizer(tapRight)
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(self.handleButtonTapLeft(_:)))
        viewToLeftOfButton.addGestureRecognizer(tapLeft)

        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        imageView.addGestureRecognizer(imageTap)
        imageView.isUserInteractionEnabled = true
        analyseButton.layer.cornerRadius = 10
        analyseButton.setTitle("...analysing", for: .disabled)
        analyseButton.setTitle("Is that true?", for: .normal)
        analyseButton.backgroundColor = UIColor(red: 255.0/255.0, green: 126.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        displayPointer.layer.cornerRadius = displayPointerFrameWidth/2;
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appWillEnterForeground(_:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        self.navigationController?.setNavigationBarHidden(true, animated: false)

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
    
    override var prefersStatusBarHidden: Bool { return true }
    
    
    override func viewDidLayoutSubviews() {
        displayLabel.font = UIFont(name: displayLabel.font!.fontName, size: display.frame.size.height*0.1)
        displayLabelConstraint.constant = display.frame.size.height * 0.8 -  displayLabel.frame.size.height * 0.5
        var displayPointerFrame: CGRect
        if #available(iOS 11.0, *) {
            displayPointerFrame = CGRect(
                x: display.pointerCenter().x - displayPointerFrameWidth / 2.0,
                y: display.pointerCenter().y - display.maxRadius() + self.view.safeAreaInsets.top,
                width: displayPointerFrameWidth,
                height: display.maxRadius())
        } else {
            displayPointerFrame = CGRect(
                x: display.pointerCenter().x - displayPointerFrameWidth / 2.0,
                y: display.pointerCenter().y - display.maxRadius(),
                width: displayPointerFrameWidth,
                height: display.maxRadius())
        }
        displayPointer.frame = displayPointerFrame
        setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 1.0), forView: displayPointer)
        v0 = Double(display.startAngle()) - 1.5 * .pi
        v1 = Double(display.endAngle())   - 1.5 * .pi
        value = targetValue
    }
    
    @objc func appWillEnterForeground(_ application: UIApplication) {
        reset()
    }

    @objc func handleButtonTapRight(_ sender: UITapGestureRecognizer) {
        newQuestion(truthIndex: 0.0)
    }
    @objc func handleButtonTapLeft(_ sender: UITapGestureRecognizer) {
        newQuestion(truthIndex: 1.0)
    }

    @objc func handleButtonTap(_ sender: UITapGestureRecognizer) {
        let tabPosition = (analyseButton.frame.size.width - sender.location(in: analyseButton).x) / analyseButton.frame.size.width
        newQuestion(truthIndex: tabPosition)
    }
    func newQuestion(truthIndex: CGFloat) {
        UserDefaults.standard.set(true, forKey: "instructionsShown")
        instructionsImageView.isHidden = true

        imageView.isHidden = true
        animationView.isHidden = false
        analyseButton.isEnabled = false
        analyseButton.setNeedsDisplay()
        viewToRightOfButton.isUserInteractionEnabled = false
        viewToLeftOfButton.isUserInteractionEnabled = false
        analyseButton.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.targetValue = self.targetValue + 0.3*(Double(truthIndex)-self.targetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.targetValue = self.targetValue + 0.6*(Double(truthIndex)-self.targetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.animationView.isHidden = true
            self.targetValue = Double(truthIndex)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.analyseButton.setTitle("Done", for: .disabled)
            self.analyseButton.setNeedsDisplay()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            if truthIndex < 0.1 {
                self.imageView.image = UIImage(named: "absolute bullshit")
            } else if truthIndex < 0.2 {
                self.imageView.image = UIImage(named: "bullshit")
            } else if truthIndex < 0.6 {
                self.imageView.image = UIImage(named: "resonable")
            } else if truthIndex < 0.75 {
                self.imageView.image = UIImage(named: "mostly true")
            } else {
                self.imageView.image = UIImage(named: "true")
            }
            self.imageView.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
            self.analyseButton.isEnabled = true
            self.analyseButton.setNeedsDisplay()
            self.viewToRightOfButton.isUserInteractionEnabled = true
            self.viewToLeftOfButton.isUserInteractionEnabled = true
            self.analyseButton.setTitle("...analysing", for: .disabled)
            self.analyseButton.backgroundColor = UIColor(red: 255.0/255.0, green: 126.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        }
    }

    func reset() {
        imageView.isHidden = true
        animationView.isHidden = true
        targetValue = 0.3
    }
    
    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        reset()
    }

    @objc func noise() {
        let n = distribution.nextInt()
        var newValue = targetValue + 0.001 * Double(n)
        if newValue < -0.02 { newValue = -0.02 } // allow a bit more than 100% bullshit
        if newValue > 1.0 { newValue = 1.0 }
        value = newValue
    }

}

