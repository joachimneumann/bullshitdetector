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
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        }
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonTextField.text = UserDefaults.standard.string(forKey: buttonTextkey)
    }
    
    @IBAction func segmentSelected(_ segmentedControl: UISegmentedControl) {
        let x1 = theButton.frame.origin.x
        let w = theButton.frame.size.width / 5
        indicatorViewWidthConstraint.constant = w
        indicatorView.isHidden = false
        
        firstTextField.isHidden = false
        secondTextField.isHidden = false

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            indicatorViewLeadingConstraint.constant = 0
            indicatorViewWidthConstraint.constant = x1+w
//            stampPreview.setTextArray(texts: [farLeftTextField.text!])
        case 1:
            indicatorViewLeadingConstraint.constant = x1+1*w
//            stampPreview.setTextArray(texts: [leftTextField.text!])
        case 2:
            indicatorViewLeadingConstraint.constant = x1+2*w
//            stampPreview.setTextArray(texts: [centerTextField.text!])
        case 3:
            indicatorViewLeadingConstraint.constant = x1+3*w
//            stampPreview.setTextArray(texts: [rightTextField.text!])
        case 4:
            indicatorViewLeadingConstraint.constant = x1+4*w
            indicatorViewWidthConstraint.constant = x1+w
//            stampPreview.setTextArray(texts: [farRightTextField.text!])

        default:
            indicatorViewLeadingConstraint.constant = -1000
        }
        stampPreview.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(buttonTextField.text, forKey: buttonTextkey)
//        UserDefaults.standard.set(farLeftTextField.text, forKey: farLeftTextkey)
//        UserDefaults.standard.set(leftTextField.text, forKey: leftTextkey)
//        UserDefaults.standard.set(centerTextField.text, forKey: centerTextkey)
//        UserDefaults.standard.set(rightTextField.text, forKey: rightTextkey)
//        UserDefaults.standard.set(farRightTextField.text, forKey: farRightTextkey)
    }

}
