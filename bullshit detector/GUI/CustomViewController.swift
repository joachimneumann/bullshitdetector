//
//  CustomViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 02.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit


class CustomViewController: UIViewController, UITextFieldDelegate {
    
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
        display.title = Model.shared.theme().displayText
        if (Model.shared.theme().readonly)  {
            displayTextField.isHidden = true
            buttonTextField.isHidden = true
            theButton.setTitle(Model.shared.theme().buttonText, for: .normal)
            firstTextField.isHidden = true
            secondTextField.isHidden = true
            buttonTextField.isUserInteractionEnabled = false
            buttonTextField.backgroundColor = UIColor.clear
            buttonTextField.borderStyle = .none
        } else {
            displayTextField.isHidden = false
            display.title = ""
            theButton.setTitle(Model.shared.theme().buttonText, for: .normal)
            buttonTextField.text = Model.shared.theme().buttonText
            displayTextField.text = Model.shared.theme().displayText
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
        stampPreview.border_width = Int(stampPreview.frame.height * 0.1)
        stampPreview.border_radius = Int(stampPreview.frame.height * 0.25)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

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
                firstTextField.text  = Model.shared.theme().farLeftText1
                secondTextField.text = Model.shared.theme().farLeftText2
            case 1:
                indicatorViewLeadingConstraint.constant = x1+1*w
                firstTextField.text  = Model.shared.theme().leftText1
                secondTextField.text = Model.shared.theme().leftText2
            case 2:
                indicatorViewLeadingConstraint.constant = x1+2*w
                firstTextField.text  = Model.shared.theme().centerText1
                secondTextField.text = Model.shared.theme().centerText2
            case 3:
                indicatorViewLeadingConstraint.constant = x1+3*w
                firstTextField.text  = Model.shared.theme().rightText1
                secondTextField.text = Model.shared.theme().rightText2
            case 4:
                indicatorViewLeadingConstraint.constant = x1+4*w
                indicatorViewWidthConstraint.constant = x1+w
                firstTextField.text  = Model.shared.theme().farRightText1
                secondTextField.text = Model.shared.theme().farRightText2
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
            Model.shared.theme().farLeftText1 = firstTextField.text!
            Model.shared.theme().farLeftText2 = secondTextField.text!
        case 1:
            Model.shared.theme().leftText1 = firstTextField.text!
            Model.shared.theme().leftText2 = secondTextField.text!
        case 2:
            Model.shared.theme().centerText1 = firstTextField.text!
            Model.shared.theme().centerText2 = secondTextField.text!
        case 3:
            Model.shared.theme().rightText1 = firstTextField.text!
            Model.shared.theme().rightText2 = secondTextField.text!
        case 4:
            Model.shared.theme().farRightText1 = firstTextField.text!
            Model.shared.theme().farRightText2 = secondTextField.text!
        default:
            print("unexpected case")
        }
    }
    
    @IBAction func displayTextFieldDidChange(_ sender: Any) {
        Model.shared.theme().displayText = displayTextField.text!
    }

    @IBAction func buttonTextFieldDidChange(_ sender: Any) {
        theButton.setTitle(buttonTextField.text!, for: .normal)
        Model.shared.theme().buttonText = buttonTextField.text!
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
