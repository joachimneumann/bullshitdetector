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

    @IBOutlet weak var coverView: UIView!
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
    var displayTargetValue = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO only if not purchased or even later
        IAPService.shared.getProducts()
        if Model.shared.instructionsHaveBeenDisplayed {
            instructionsImageView.isHidden = true
        }
//        self.view.backgroundColor = displayBackgroundColor
        
        templateImageView.alpha = 0.2
        rubberstamp.isHidden = true
        templateImageView.isHidden = false
        coverView.backgroundColor = UIColor.white
        
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
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        reset()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        print("view viewWillAppear")
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        rubberstamp.isHidden = true
        templateImageView.isHidden = false
        let theme = Model.shared.theme()
        templateImageView.image = UIImage(named: theme.imageName)
        templateImageView.alpha = 0.2
        displayLabel.text = theme.displayText
        analyseButton.setTitle(theme.buttonText, for: .normal)
    }
    
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLayoutSubviews() {
        displayLabel.font = UIFont(name: displayLabel.font!.fontName, size: display.frame.size.height*0.14)
//        displayLabelConstraint.constant = display.frame.size.height * 0.8 -  displayLabel.frame.size.height * 0.5
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
            Model.shared.instructionsHaveBeenDisplayed = true
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
        displayTargetValue = 0.5 - 0.2 * (Double(truthIndex)-0.5)
        display.newTargetValue(targetValue: displayTargetValue)
        let theme = Model.shared.theme()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.displayTargetValue = self.displayTargetValue + 0.3*(Double(truthIndex)-self.displayTargetValue)
            self.display.newTargetValue(targetValue: self.displayTargetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.displayTargetValue = self.displayTargetValue + 0.6*(Double(truthIndex)-self.displayTargetValue)
            self.display.newTargetValue(targetValue: self.displayTargetValue)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.displayTargetValue = Double(truthIndex)
            self.display.newTargetValue(targetValue: self.displayTargetValue)
            var text1: String = ""
            var text2: String = ""
            if truthIndex < 0.2 {
                text1 = theme.farRightText1
                text2 = theme.farRightText2
            } else if truthIndex < 0.4 {
                text1 = theme.rightText1
                text2 = theme.rightText2
            } else if truthIndex < 0.6 {
                text1 = theme.centerText1
                text2 = theme.centerText2
            } else if truthIndex < 0.8 {
                text1 = theme.leftText1
                text2 = theme.leftText2
            } else {
                text1 = theme.farLeftText1
                text2 = theme.farLeftText2
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
    
    func reset() {
        self.templateImageView.isHidden = false
        rubberstamp.isHidden = true
        templateImageView.alpha = 0.2
        displayTargetValue = 0.3
        display.newTargetValue(targetValue: displayTargetValue)
    }
    
    @objc func handleImageTap(_ sender: UITapGestureRecognizer) {
        reset()
    }

}

