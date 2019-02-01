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
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var resultlabel: UILabel!
    @IBOutlet weak var displayLabel: UITextField!
    @IBOutlet weak var displayLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewToRightOfButton: UIView!
    @IBOutlet weak var viewToLeftOfButton: UIView!
    @IBOutlet weak var instructionsImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var instructionsDisplayedCounter = 0
    var waveView: AnimatedWaveView?
    let random = GKRandomSource()
    let distribution = GKGaussianDistribution(lowestValue: -100, highestValue: 100)
    var noiseTimer: Timer!
    var targetValue: Double = 0.3
    let displayPointerFrameWidth: CGFloat = 6
    var displayStartAngle = 0.0
    var displayEndAngle = 0.0

    var value: Double {
        get {
            return 0
        }
        set(newValue) {
            var oldAngle = displayStartAngle
            if let currentAngle = displayPointer.layer.presentation()?.value(forKeyPath: "transform.rotation") as? Double {
                oldAngle = currentAngle
            }
            displayPointer.layer.removeAllAnimations()
            let circularAnimation = CABasicAnimation(keyPath: "transform.rotation")
            circularAnimation.delegate = self
            let startAngle = oldAngle
            let endAngle = displayStartAngle + newValue * (displayEndAngle-displayStartAngle)
            circularAnimation.fromValue = startAngle
            circularAnimation.toValue = endAngle
            circularAnimation.duration = 0.2
            circularAnimation.repeatCount = 1
            circularAnimation.fillMode = CAMediaTimingFillMode.forwards;
            circularAnimation.isRemovedOnCompletion = false
            displayPointer.layer.add(circularAnimation, forKey: "xx")
        }
    }
    

    override func viewDidLoad() {
        let instructionsDisplayed = UserDefaults.standard.object(forKey: "instructionsDisplayedKey") as? Bool ?? false
        if instructionsDisplayed {
            instructionsImageView.isHidden = true
        }
        self.view.backgroundColor = displayBackgroundColor
        
        animationView.isHidden = true
        resultView.isHidden = true
        coverView.backgroundColor = UIColor.white
        animationView.backgroundColor = UIColor(red: 255.0/255.0, green: 166.0/255.0, blue: 161.0/255.0, alpha: 1.0)
        super.viewDidLoad()
        noiseTimer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(noise), userInfo: nil, repeats: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleButtonTap(_:)))
        analyseButton.addGestureRecognizer(tap)

        let tapRight = UITapGestureRecognizer(target: self, action: #selector(self.handleButtonTapRight(_:)))
        viewToRightOfButton.addGestureRecognizer(tapRight)
        let tapLeft = UITapGestureRecognizer(target: self, action: #selector(self.handleButtonTapLeft(_:)))
        viewToLeftOfButton.addGestureRecognizer(tapLeft)

        let imageTap = UITapGestureRecognizer(target: self, action: #selector(self.handleImageTap(_:)))
        resultView.addGestureRecognizer(imageTap)
        resultView.isUserInteractionEnabled = true
        analyseButton.layer.cornerRadius = 10
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
        displayStartAngle = Double(display.startAngle()) - 1.5 * .pi
        displayEndAngle = Double(display.endAngle())   - 1.5 * .pi
        value = targetValue
        resultlabel.textColor = bullshitRed
        let fontSize = resultlabel.bounds.size.width
        let fontDescriptor = UIFontDescriptor(name: "BLACK", size: fontSize)
        resultlabel.font = UIFont(descriptor: fontDescriptor, size: fontSize)
        resultlabel.adjustsFontSizeToFitWidth = true
        resultlabel.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 20)
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
        instructionsDisplayedCounter += 1
        if instructionsDisplayedCounter >= 2 {
            UserDefaults.standard.set(true, forKey: "instructionsDisplayedKey")
            instructionsImageView.isHidden = true
        }

        resultView.isHidden = true
        animationView.isHidden = false
        waveView?.trackMotion()
        analyseButton.isEnabled = false
        analyseButton.setNeedsDisplay()
        viewToRightOfButton.isUserInteractionEnabled = false
        viewToLeftOfButton.isUserInteractionEnabled = false
        analyseButton.backgroundColor = bullshitGray
        
        // initially move to the center,
        // but a bit on the "wrong" side
        targetValue = 0.5 - 0.2 * (Double(truthIndex)-0.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.targetValue = self.targetValue + 0.3*(Double(truthIndex)-self.targetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.targetValue = self.targetValue + 0.6*(Double(truthIndex)-self.targetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.animationView.isHidden = true
            self.waveView?.motionManager.stopDeviceMotionUpdates()
            self.targetValue = Double(truthIndex)
            if truthIndex < 0.1 {
                self.resultlabel.text = "Absolute   Bullshit"
                self.resultlabel.numberOfLines = 2
            } else if truthIndex < 0.2 {
                self.resultlabel.text = "Bullshit"
                self.resultlabel.numberOfLines = 1
            } else if truthIndex < 0.6 {
                self.resultlabel.text = "Undecided"
                self.resultlabel.numberOfLines = 1
            } else if truthIndex < 0.75 {
                self.resultlabel.text = "Mostly     True"
                self.resultlabel.numberOfLines = 2
            } else {
                self.resultlabel.text = "True"
                self.resultlabel.numberOfLines = 1
            }
            self.resultView.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.analyseButton.isEnabled = true
            self.analyseButton.setNeedsDisplay()
            self.viewToRightOfButton.isUserInteractionEnabled = true
            self.viewToLeftOfButton.isUserInteractionEnabled = true
            self.analyseButton.backgroundColor = bullshitRed
        }
    }

    func reset() {
        resultView.isHidden = true
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

