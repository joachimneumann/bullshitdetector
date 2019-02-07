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

    static var __displayText = ""
    static var __buttonText = ""
    static var __farLeftText1 = ""
    static var __leftText1 = ""
    static var __centerText1 = ""
    static var __rightText1 = ""
    static var __farRightText1 = ""
    static var __farLeftText2 = ""
    static var __leftText2 = ""
    static var __centerText2 = ""
    static var __rightText2 = ""
    static var __farRightText2 = ""

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
    @IBOutlet weak var templateImageView: UIImageView!
    
    
    var instructionsDisplayedCounter = 0
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
            displayPointer.layer.add(circularAnimation, forKey: "dummykey")
        }
    }
    

    override func viewDidLoad() {
        IAPService.shared.getProducts()
        let instructionsDisplayed = UserDefaults.standard.object(forKey: instructionsDisplayedKey) as? Bool ?? false
        if instructionsDisplayed {
            instructionsImageView.isHidden = true
        }
        self.view.backgroundColor = displayBackgroundColor
        
        templateImageView.alpha = 0.2
        rubberstamp.isHidden = true
        templateImageView.isHidden = false
        coverView.backgroundColor = UIColor.white
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
        reset()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        targetValue = 0.5
        print("view viewWillAppear")
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        rubberstamp.isHidden = true
        templateImageView.isHidden = false
        if let template = Template(rawValue: UserDefaults.standard.string(forKey: templatekey)!) {
            switch template {
            case Template.TruthOMeter:
                BullshitViewController.__defaultTexts()
                templateImageView.image = UIImage(named: "truth")
            case Template.BullshitOMeter:
                BullshitViewController.__bullshitOMeterTexts()
                templateImageView.image = UIImage(named: "truth")
            case Template.VoiceOMeter:
                BullshitViewController.__voiceOMeterTexts()
                templateImageView.image = UIImage(named: "singer")
            case Template.Custom:
                BullshitViewController.__customTexts()
                templateImageView.image = UIImage(named: "truth")
            }
            templateImageView.alpha = 0.2

        }
        displayLabel.text = BullshitViewController.__displayText
        analyseButton.setTitle(BullshitViewController.__buttonText, for: .normal)
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
        templateImageView.isHidden = false
        templateImageView.alpha = 0.6
        analyseButton.isEnabled = false
        analyseButton.setNeedsDisplay()
        viewToRightOfButton.isUserInteractionEnabled = false
        viewToLeftOfButton.isUserInteractionEnabled = false
        analyseButton.backgroundColor = bullshitGray
        
        // initially move to the center,
        // but a bit on the "wrong" side
        targetValue = 0.5 - 0.2 * (Double(truthIndex)-0.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.targetValue = self.targetValue + 0.3*(Double(truthIndex)-self.targetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.targetValue = self.targetValue + 0.6*(Double(truthIndex)-self.targetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.analyseButton.isEnabled = true
            self.analyseButton.setNeedsDisplay()
            self.viewToRightOfButton.isUserInteractionEnabled = true
            self.viewToLeftOfButton.isUserInteractionEnabled = true
            self.analyseButton.backgroundColor = bullshitRed
            self.rubberstamp.rubbereffect(imageName: "mask")
            self.rubberstamp.isHidden = false
            self.templateImageView.isHidden = true
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
    
    static func __voiceOMeterTexts() {
        BullshitViewController.__buttonText = "How is you voice?"
        BullshitViewController.__displayText = "Voice-O-Meter"
        BullshitViewController.__farLeftText1 = "Sexy"
        BullshitViewController.__farLeftText2 = ""
        BullshitViewController.__leftText1 = "impressive"
        BullshitViewController.__leftText2 = ""
        BullshitViewController.__centerText1 = "good"
        BullshitViewController.__centerText2 = ""
        BullshitViewController.__rightText1 = "could be"
        BullshitViewController.__rightText2 = "better"
        BullshitViewController.__farRightText1 = "flimsy"
        BullshitViewController.__farRightText2 = ""
    }
    
    static func __customTexts() {
        if let s = UserDefaults.standard.string(forKey: buttonCustomTextkey) {
            BullshitViewController.__buttonText = s
        }
        if let s = UserDefaults.standard.string(forKey: displayCustomTextkey) {
            BullshitViewController.__displayText = s
        }
        if let s = UserDefaults.standard.string(forKey: farLeftCustomTextkey1) {
            BullshitViewController.__farLeftText1 = s
        }
        if let s = UserDefaults.standard.string(forKey: farLeftCustomTextkey2) {
            BullshitViewController.__farLeftText2 = s
        }
        if let s = UserDefaults.standard.string(forKey: leftCustomTextkey1) {
            BullshitViewController.__leftText1 = s
        }
        if let s = UserDefaults.standard.string(forKey: leftCustomTextkey2) {
            BullshitViewController.__leftText2 = s
        }
        if let s = UserDefaults.standard.string(forKey: centerCustomTextkey1) {
            BullshitViewController.__centerText1 = s
        }
        if let s = UserDefaults.standard.string(forKey: centerCustomTextkey2) {
            BullshitViewController.__centerText2 = s
        }
        if let s = UserDefaults.standard.string(forKey: rightCustomTextkey1) {
            BullshitViewController.__rightText1 = s
        }
        if let s = UserDefaults.standard.string(forKey: rightCustomTextkey2) {
            BullshitViewController.__rightText2 = s
        }
        if let s = UserDefaults.standard.string(forKey: farRightCustomTextkey1) {
            BullshitViewController.__farRightText1 = s
        }
        if let s = UserDefaults.standard.string(forKey: farRightCustomTextkey2) {
            BullshitViewController.__farRightText2 = s
        }
    }

    func reset() {
        self.templateImageView.isHidden = false
        rubberstamp.isHidden = true
        templateImageView.alpha = 0.2
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

