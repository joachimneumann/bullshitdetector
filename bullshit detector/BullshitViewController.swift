//
//  BullshitViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 12/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit
import GameplayKit

class BullshitViewController: UIViewController, CAAnimationDelegate, UIGestureRecognizerDelegate {

    static var __displayText = "3.1415926"
    static var __buttonText = "3.1415926"
    static var __farLeftText1 = "3.1415926"
    static var __leftText1 = "3.1415926"
    static var __centerText1 = "3.1415926"
    static var __rightText1 = "3.1415926"
    static var __farRightText1 = "3.1415926"
    static var __farLeftText2 = "3.1415926"
    static var __leftText2 = "3.1415926"
    static var __centerText2 = "3.1415926"
    static var __rightText2 = "3.1415926"
    static var __farRightText2 = "3.1415926"

    @IBOutlet weak var animationView: UIView!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var displayPointer: UIView!
    @IBOutlet weak var display: Display!
    @IBOutlet weak var analyseButton: UIButton!
    @IBOutlet weak var rubberstamp: Rubberstamp!
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
        print("view viewDidLoad")
//        rubberstamp.setText(text: "test Text")
        let instructionsDisplayed = UserDefaults.standard.object(forKey: instructionsDisplayedKey) as? Bool ?? false
        if instructionsDisplayed {
            instructionsImageView.isHidden = true
        }
        self.view.backgroundColor = displayBackgroundColor
        
        animationView.isHidden = true
        rubberstamp.isHidden = true
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
        rubberstamp.addGestureRecognizer(imageTap)
        rubberstamp.isUserInteractionEnabled = true
        analyseButton.layer.cornerRadius = 10
        analyseButton.backgroundColor = bullshitRed
        displayPointer.layer.cornerRadius = displayPointerFrameWidth/2;
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("view viewWillAppear")
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        reset()
        rubberstamp.isHidden = true
        displayLabel.text = BullshitViewController.__displayText
        analyseButton.setTitle(BullshitViewController.__buttonText, for: .normal)
        print("view viewWillAppear")
        let animatedWaveView = AnimatedWaveView(frame: animationView.bounds)
        animationView.layer.cornerRadius = min(animationView.frame.size.height, animationView.frame.size.width) / 2
        waveView = animatedWaveView
        animationView.addSubview(animatedWaveView)
        waveView?.makeWaves()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view viewDidAppear")
        super.viewDidAppear(animated)
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
            UserDefaults.standard.set(true, forKey: instructionsDisplayedKey)
            instructionsImageView.isHidden = true
        }

        rubberstamp.isHidden = true
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
            var text1: String = ""
            var text2: String = ""
            if truthIndex < 0.2 {
                text1 = BullshitViewController.__farRightText1
                text2 = BullshitViewController.__farRightText2
            } else if truthIndex < 0.4 {
                text1 = BullshitViewController.__rightText1
                text2 = BullshitViewController.__rightText2
            } else if truthIndex < 0.6 {
                text1 = BullshitViewController.__centerText1
                text2 = BullshitViewController.__centerText2
            } else if truthIndex < 0.8 {
                text1 = BullshitViewController.__leftText1
                text2 = BullshitViewController.__leftText2
            } else {
                text1 = BullshitViewController.__farLeftText1
                text2 = BullshitViewController.__farLeftText2
            }
            self.rubberstamp.setTextArray(texts: [text1, text2])
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            self.analyseButton.isEnabled = true
            self.analyseButton.setNeedsDisplay()
            self.viewToRightOfButton.isUserInteractionEnabled = true
            self.viewToLeftOfButton.isUserInteractionEnabled = true
            self.analyseButton.backgroundColor = bullshitRed
            self.rubberstamp.rubbereffect(imageName: "mask")
            self.rubberstamp.isHidden = false
        }
    }

    static func __defaultTexts() {
        BullshitViewController.__buttonText = "Is that true?"
        BullshitViewController.__displayText = "Truth-O-Meter"
        BullshitViewController.__farLeftText1 = "True"
        BullshitViewController.__farLeftText2 = ""
        BullshitViewController.__leftText1 = "Mostly"
        BullshitViewController.__leftText2 = "True"
        BullshitViewController.__centerText1 = "Undecided"
        BullshitViewController.__centerText2 = ""
        BullshitViewController.__rightText1 = "Bullshit"
        BullshitViewController.__rightText2 = ""
        BullshitViewController.__farRightText1 = "Absolute"
        BullshitViewController.__farRightText2 = "Bullshit"
    }
    
    static func __bullshitOMeterTexts() {
        BullshitViewController.__buttonText = "Is that Bullshit?"
        BullshitViewController.__displayText = "Bullshit-O-Meter"
        BullshitViewController.__farLeftText1 = "Absolute"
        BullshitViewController.__farLeftText2 = "Bullshit"
        BullshitViewController.__leftText1 = "Bullshit"
        BullshitViewController.__leftText2 = ""
        BullshitViewController.__centerText1 = "undecided"
        BullshitViewController.__centerText2 = ""
        BullshitViewController.__rightText1 = "Mostly"
        BullshitViewController.__rightText2 = "True"
        BullshitViewController.__farRightText1 = "True"
        BullshitViewController.__farRightText2 = ""
    }
    
    func reset() {
        if let template = Template(rawValue: UserDefaults.standard.string(forKey: templatekey)!) {
            switch template {
                case Template.TruthOMeter:
                    BullshitViewController.__defaultTexts()
                case Template.BullshitOMeter:
                    BullshitViewController.__bullshitOMeterTexts()
                case Template.Custom:
                    BullshitViewController.__bullshitOMeterTexts()
            }
        }
        rubberstamp.isHidden = true
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

