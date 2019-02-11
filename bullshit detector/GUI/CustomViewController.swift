//
//  CustomViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 02.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit


class CustomViewController: UIViewController, UITextFieldDelegate {
    
    var theme: BullshitTheme?

    @IBOutlet weak var stampPreview: Rubberstamp!
    
    @IBOutlet weak var display: Display!
    @IBOutlet weak var displayTextField: NoSelectTextField!
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var buttonTextField: UITextField!

    @IBOutlet weak var indicatorViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var theButton: UIButton!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!

    @IBOutlet weak var stampContainer: UIView!
    @IBOutlet weak var stampHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampWidhtConstraint: NSLayoutConstraint!

   
    private var truthIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        truthIndex = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleButtonTap(_:)))
        theButton.addGestureRecognizer(tap)
        
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        buttonTextField.delegate = self
        theButton.layer.cornerRadius = 10
        theButton.backgroundColor = bullshitRed
        updateTextFields()
        if let name = theme?.name {
            display.title = name
        }
        if (theme?.readonly ?? false)  {
            displayTextField.isHidden = true
            buttonTextField.isHidden = true
            theButton.setTitle(theme?.buttonText, for: .normal)
            firstTextField.isHidden = true
            secondTextField.isHidden = true
            buttonTextField.isUserInteractionEnabled = false
            buttonTextField.backgroundColor = UIColor.clear
            buttonTextField.borderStyle = .none
        } else {
            displayTextField.isHidden = false
            display.title = ""
            theButton.setTitle(theme?.buttonText, for: .normal)
            buttonTextField.text = theme?.buttonText
            displayTextField.text = theme?.displayText
            displayTextField.isUserInteractionEnabled = true
            displayTextField.delegate = self
            firstTextField.isHidden = false
            secondTextField.isHidden = false
            firstTextField.isUserInteractionEnabled = true
            secondTextField.isUserInteractionEnabled = true
            buttonTextField.isUserInteractionEnabled = true
            firstTextField.delegate = self
            secondTextField.delegate = self
        }

        stampPreview.rubbereffect(imageName: "mask")
        stampPreview.stampColor = bullshitRed

        // back --> always to table, never to purchase
        self.navigationItem.hidesBackButton = true
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(CustomViewController.back(sender:)))
        self.navigationItem.leftBarButtonItem = backButton
        display.newTargetValue(targetValue: 1.0)
        stampPreview.setTextArray(texts: [firstTextField.text!, secondTextField.text!])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTextFields()
        stampHeightConstraint.constant = stampContainer.frame.size.height * 0.9
        stampWidhtConstraint.constant = stampContainer.frame.size.width * 0.9
        stampPreview.border_width = Int(stampPreview.frame.height * 0.1)
        stampPreview.border_radius = Int(stampPreview.frame.height * 0.25)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//    }

    @objc func handleButtonTap(_ sender: UITapGestureRecognizer) {
        let pos = sender.location(in: theButton).x / theButton.frame.size.width
        truthIndex = Int( floor(5.0 * pos) )
        display.newTargetValue(targetValue: 1.0 - Double(truthIndex) * 0.25)
        updateTextFields()
        stampPreview.setTextArray(texts: [firstTextField.text!, secondTextField.text!])
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let dashboardVC = navigationController!.viewControllers.filter { $0 is settingsViewController }.first!
        navigationController!.popToViewController(dashboardVC, animated: true)
    }
    
    func updateTextFields() {
        let x1 = theButton.frame.origin.x
        let w = theButton.frame.size.width / 5
        indicatorViewWidthConstraint.constant = w
        switch truthIndex {
            case 0:
                indicatorViewLeadingConstraint.constant = 0
                indicatorViewWidthConstraint.constant = x1+w
                firstTextField.text  = theme?.farLeftText1
                secondTextField.text = theme?.farLeftText2
            case 1:
                indicatorViewLeadingConstraint.constant = x1+1*w
                firstTextField.text  = theme?.leftText1
                secondTextField.text = theme?.leftText2
            case 2:
                indicatorViewLeadingConstraint.constant = x1+2*w
                firstTextField.text  = theme?.centerText1
                secondTextField.text = theme?.centerText2
            case 3:
                indicatorViewLeadingConstraint.constant = x1+3*w
                firstTextField.text  = theme?.rightText1
                secondTextField.text = theme?.rightText2
            case 4:
                indicatorViewLeadingConstraint.constant = x1+4*w
                indicatorViewWidthConstraint.constant = x1+w
                firstTextField.text  = theme?.farRightText1
                secondTextField.text = theme?.farRightText2
            default:
            print("unexpected case \(truthIndex)")
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func save() {
        switch truthIndex {
        case 0:
            theme?.farLeftText1 = firstTextField.text!
            theme?.farLeftText2 = secondTextField.text!
        case 1:
            theme?.leftText1 = firstTextField.text!
            theme?.leftText2 = secondTextField.text!
        case 2:
            theme?.centerText1 = firstTextField.text!
            theme?.centerText2 = secondTextField.text!
        case 3:
            theme?.rightText1 = firstTextField.text!
            theme?.rightText2 = secondTextField.text!
        case 4:
            theme?.farRightText1 = firstTextField.text!
            theme?.farRightText2 = secondTextField.text!
        default:
            print("unexpected case")
        }
    }
    
    @IBAction func displayTextFieldDidChange(_ sender: Any) {
        theme?.displayText = displayTextField.text!
    }

    @IBAction func buttonTextFieldDidChange(_ sender: Any) {
        theButton.setTitle(buttonTextField.text!, for: .normal)
        theme?.buttonText = buttonTextField.text!
    }

    @IBAction func leftTextFieldDidChange(_ sender: Any) {
        stampPreview.setTextArray(texts: [firstTextField.text!, secondTextField.text!])
        save()
    }

    @IBAction func rightTextFieldDidChange(_ sender: Any) {
        stampPreview.setTextArray(texts: [firstTextField.text!, secondTextField.text!])
        save()
    }

}
