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
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var resultLabel1: UITextField!
    @IBOutlet weak var resultLabel2: UITextField!
    @IBOutlet weak var displayLabel: UITextField!
    @IBOutlet weak var displayLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewToRightOfButton: UIView!
    @IBOutlet weak var viewToLeftOfButton: UIView!
    @IBOutlet weak var instructionsImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var resultLabel1BottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultLabel2TopConstraint: NSLayoutConstraint!
    
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
        let instructionsDisplayed = UserDefaults.standard.object(forKey: instructionsDisplayedKey) as? Bool ?? false
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
        
        let fontSize = resultLabel.bounds.size.width
        let fontDescriptor = UIFontDescriptor(name: "BLACK", size: fontSize)
        resultLabel.font = UIFont(descriptor: fontDescriptor, size: fontSize)
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel1.font = UIFont(descriptor: fontDescriptor, size: fontSize)
        resultLabel1.adjustsFontSizeToFitWidth = true
        resultLabel2.font = UIFont(descriptor: fontDescriptor, size: fontSize)
        resultLabel2.adjustsFontSizeToFitWidth = true
        resultView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view viewDidAppear")
        super.viewDidAppear(animated)

        displayLabel.text = UserDefaults.standard.string(forKey: displayTextkey)

        let animatedWaveView = AnimatedWaveView(frame: animationView.bounds)
        animationView.layer.cornerRadius = min(animationView.frame.size.height, animationView.frame.size.width) / 2
        waveView = animatedWaveView
        animationView.addSubview(animatedWaveView)
        waveView?.makeWaves()
        resultLabel2TopConstraint.constant = resultView.frame.size.height * 0.45
        resultLabel1BottomConstraint.constant = resultView.frame.size.height * 0.45
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
        resultLabel.textColor = bullshitRed
        resultLabel1.textColor = resultLabel.textColor
        resultLabel2.textColor = resultLabel.textColor
        let resultLabel1Size = resultLabel1.font!.pointSize
        let resultLabel2Size = resultLabel2.font!.pointSize
        let minimumFontSize = min(resultLabel1Size, resultLabel2Size)
        resultLabel1.font = UIFont(name:"BLACK", size: minimumFontSize)
        resultLabel2.font = UIFont(name:"BLACK", size: minimumFontSize)
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
            UserDefaults.standard.set(true, forKey: instructionsDisplayedKey)
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
            var text: String = ""
            if truthIndex < 0.1 {
                text = UserDefaults.standard.string(forKey: farRightTextkey)!
            } else if truthIndex < 0.2 {
                text = UserDefaults.standard.string(forKey: mediumRightTextkey)!
            } else if truthIndex < 0.6 {
                text = UserDefaults.standard.string(forKey: centerTextkey)!
            } else if truthIndex < 0.75 {
                text = UserDefaults.standard.string(forKey: mediumLeftTextkey)!
            } else {
                text = UserDefaults.standard.string(forKey: farLeftTextkey)!
            }
            let n = text.components(separatedBy: " ").count
            if n < 2 {
                self.resultLabel.text = text
                self.resultLabel.isHidden = false
                self.resultLabel1.isHidden = true
                self.resultLabel2.isHidden = true
                self.resultView.isHidden = false
            } else {
                self.resultLabel1.text = text.components(separatedBy: " ")[0]
                self.resultLabel2.text = text.components(separatedBy: " ")[1]
                self.resultLabel.isHidden = true
                self.resultLabel1.isHidden = false
                self.resultLabel2.isHidden = false
                self.resultView.isHidden = false
            }
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

