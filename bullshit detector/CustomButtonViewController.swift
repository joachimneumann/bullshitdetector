//
//  CustomButtonViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 02.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit


class CustomButtonViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var stampPreview: Rubberstamp!
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var buttonTextField: UITextField!

    @IBOutlet weak var indicatorViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var indicatorViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var theButton: UIButton!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var segmentedControlPosition: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = displayBackgroundColor
        buttonTextField.delegate = self
        theButton.layer.cornerRadius = 10
        theButton.backgroundColor = bullshitRed
        indicatorView.isHidden = true
        firstTextField.isUserInteractionEnabled = true
        secondTextField.isUserInteractionEnabled = true
        firstTextField.delegate = self
        secondTextField.delegate = self

        stampPreview.isHidden = true
        stampPreview.rubbereffect(imageName: "mask")
        stampPreview.stampColor = bullshitRed

        if let s = UserDefaults.standard.string(forKey: buttonCustomTextkey) {
            buttonTextField.text = s
        }
        switch segmentedControlPosition.selectedSegmentIndex {
        case 0:
            if let s = UserDefaults.standard.string(forKey: farLeftCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: farLeftCustomTextkey2) {
                secondTextField.text = s
            }
        case 1:
            if let s = UserDefaults.standard.string(forKey: leftCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: leftCustomTextkey2) {
                secondTextField.text = s
            }
        case 2:
            if let s = UserDefaults.standard.string(forKey: centerCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: centerCustomTextkey2) {
                secondTextField.text = s
            }
        case 3:
            if let s = UserDefaults.standard.string(forKey: rightCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: rightCustomTextkey2) {
                secondTextField.text = s
            }
        case 4:
            if let s = UserDefaults.standard.string(forKey: farRightCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: farRightCustomTextkey2) {
                secondTextField.text = s
            }
        default:
            print("unexpected case")
        }
    }
    
    func save() {
        print("save()")
        UserDefaults.standard.set(buttonTextField.text,  forKey: buttonCustomTextkey)
        switch segmentedControlPosition.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(firstTextField.text,  forKey: farLeftCustomTextkey1)
            UserDefaults.standard.set(secondTextField.text, forKey: farLeftCustomTextkey2)
        case 1:
            UserDefaults.standard.set(firstTextField.text,  forKey: leftCustomTextkey1)
            UserDefaults.standard.set(secondTextField.text, forKey: leftCustomTextkey2)
        case 2:
            UserDefaults.standard.set(firstTextField.text,  forKey: centerCustomTextkey1)
            UserDefaults.standard.set(secondTextField.text, forKey: centerCustomTextkey2)
        case 3:
            UserDefaults.standard.set(firstTextField.text,  forKey: rightCustomTextkey1)
            UserDefaults.standard.set(secondTextField.text, forKey: rightCustomTextkey2)
        case 4:
            UserDefaults.standard.set(firstTextField.text,  forKey: farRightCustomTextkey1)
            UserDefaults.standard.set(secondTextField.text, forKey: farRightCustomTextkey2)
        default:
            print("unexpected case")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(buttonTextField) {
            indicatorView.isHidden = true
            stampPreview.isHidden = true
        } else {
            indicatorView.isHidden = false
            stampPreview.isHidden = false
        }
        return true
    }
 
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        save()
        return true
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            if textField.isEqual(firstTextField) {
                stampPreview.setTextArray(texts: [txtAfterUpdate, secondTextField.text!])
            } else {
                stampPreview.setTextArray(texts: [firstTextField.text!, txtAfterUpdate])
            }
            textField.text = txtAfterUpdate
            save()
        }
        return false        
        // this is a hack to allow getting the texts even if the user presses on the seggmented control
    }
    
    @IBAction func segmentSelected(_ segmentedControl: UISegmentedControl) {
        let x1 = theButton.frame.origin.x
        let w = theButton.frame.size.width / 5
        indicatorViewWidthConstraint.constant = w
        indicatorView.isHidden = false
        firstTextField.text = ""
        secondTextField.text = ""
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            indicatorViewLeadingConstraint.constant = 0
            indicatorViewWidthConstraint.constant = x1+w
            if let s = UserDefaults.standard.string(forKey: farLeftCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: farLeftCustomTextkey2) {
                secondTextField.text = s
            }
        case 1:
            indicatorViewLeadingConstraint.constant = x1+1*w
            if let s = UserDefaults.standard.string(forKey: leftCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: leftCustomTextkey2) {
                secondTextField.text = s
            }
        case 2:
            indicatorViewLeadingConstraint.constant = x1+2*w
            if let s = UserDefaults.standard.string(forKey: centerCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: centerCustomTextkey2) {
                secondTextField.text = s
            }
        case 3:
            indicatorViewLeadingConstraint.constant = x1+3*w
            if let s = UserDefaults.standard.string(forKey: rightCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: rightCustomTextkey2) {
                secondTextField.text = s
            }
        case 4:
            indicatorViewLeadingConstraint.constant = x1+4*w
            indicatorViewWidthConstraint.constant = x1+w
            if let s = UserDefaults.standard.string(forKey: farRightCustomTextkey1) {
                firstTextField.text = s
            }
            if let s = UserDefaults.standard.string(forKey: farRightCustomTextkey2) {
                secondTextField.text = s
            }
        default:
            indicatorViewLeadingConstraint.constant = -1000
        }
        firstTextField.isHidden = false
        secondTextField.isHidden = false

        stampPreview.setTextArray(texts: [firstTextField.text!, secondTextField.text!])
        stampPreview.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        UserDefaults.standard.set(buttonTextField.text, forKey: buttonTextkey)
//        UserDefaults.standard.set(farLeftTextField.text, forKey: farLeftTextkey)
//        UserDefaults.standard.set(leftTextField.text, forKey: leftTextkey)
//        UserDefaults.standard.set(centerTextField.text, forKey: centerTextkey)
//        UserDefaults.standard.set(rightTextField.text, forKey: rightTextkey)
//        UserDefaults.standard.set(farRightTextField.text, forKey: farRightTextkey)
    }

}
