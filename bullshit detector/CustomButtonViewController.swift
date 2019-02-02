//
//  CustomButtonViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 02.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class CustomButtonViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var buttonTextField: UITextField!

    @IBOutlet weak var indicatorViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var theButton: UIButton!
    @IBOutlet weak var farLeftTextField: UITextField!
    @IBOutlet weak var leftTextField: UITextField!
    @IBOutlet weak var centerTextField: UITextField!
    @IBOutlet weak var rightTextField: UITextField!
    @IBOutlet weak var farRightTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = displayBackgroundColor
        buttonTextField.delegate = self
        theButton.layer.cornerRadius = 10
        theButton.backgroundColor = bullshitRed
        indicatorView.isHidden = true
        farLeftTextField.isHidden = false // at start the first segment is selected
        leftTextField.isHidden = true
        centerTextField.isHidden = true
        rightTextField.isHidden = true
        farRightTextField.isHidden = true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            indicatorView.isHidden = true
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonTextField.text = UserDefaults.standard.string(forKey: buttonTextkey)
        farLeftTextField.text = UserDefaults.standard.string(forKey: farLeftTextkey)
        leftTextField.text = UserDefaults.standard.string(forKey: leftTextkey)
        centerTextField.text = UserDefaults.standard.string(forKey: centerTextkey)
        rightTextField.text = UserDefaults.standard.string(forKey: rightTextkey)
        farRightTextField.text = UserDefaults.standard.string(forKey: farRightTextkey)
    }
    
    @IBAction func segmentSelected(_ segmentedControl: UISegmentedControl) {
        let x1 = theButton.frame.origin.x
        let w = theButton.frame.size.width / 5
        indicatorViewWidthConstraint.constant = w
        indicatorView.isHidden = false
        
        farLeftTextField.isHidden = true
        leftTextField.isHidden = true
        centerTextField.isHidden = true
        rightTextField.isHidden = true
        farRightTextField.isHidden = true

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            indicatorViewLeadingConstraint.constant = 0
            indicatorViewWidthConstraint.constant = x1+w
            farLeftTextField.isHidden = false
        case 1:
            indicatorViewLeadingConstraint.constant = x1+1*w
            leftTextField.isHidden = false
        case 2:
            indicatorViewLeadingConstraint.constant = x1+2*w
            centerTextField.isHidden = false
        case 3:
            indicatorViewLeadingConstraint.constant = x1+3*w
            rightTextField.isHidden = false
        case 4:
            indicatorViewLeadingConstraint.constant = x1+4*w
            indicatorViewWidthConstraint.constant = x1+w
            farRightTextField.isHidden = false
        default:
            indicatorViewLeadingConstraint.constant = -1000
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(buttonTextField.text, forKey: buttonTextkey)
        UserDefaults.standard.set(farLeftTextField.text, forKey: farLeftTextkey)
        UserDefaults.standard.set(leftTextField.text, forKey: leftTextkey)
        UserDefaults.standard.set(centerTextField.text, forKey: centerTextkey)
        UserDefaults.standard.set(rightTextField.text, forKey: rightTextkey)
        UserDefaults.standard.set(farRightTextField.text, forKey: farRightTextkey)
    }

}
