//
//  SettingsViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 16/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var displayTextField: UITextField!
    @IBOutlet weak var farLeftTextField: UITextField!
    @IBOutlet weak var mediumLeftTextField: UITextField!
    @IBOutlet weak var centerTextField: UITextField!
    @IBOutlet weak var mediumRightTextField: UITextField!
    @IBOutlet weak var farRightTextField: UITextField!
    var activeTextField: UITextField?
    var lastOffset: CGPoint = CGPoint(x: 0, y: 0)
    var keyboardHeight: CGFloat = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = displayBackgroundColor
        
        
        displayTextField.text = UserDefaults.standard.string(forKey: displayTextkey)
        farLeftTextField.text = UserDefaults.standard.string(forKey: farLeftTextkey)
        mediumLeftTextField.text = UserDefaults.standard.string(forKey: mediumLeftTextkey)
        centerTextField.text = UserDefaults.standard.string(forKey: centerTextkey)
        mediumRightTextField.text = UserDefaults.standard.string(forKey: mediumRightTextkey)
        farRightTextField.text = UserDefaults.standard.string(forKey: farRightTextkey)

//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        displayTextField.delegate = self
        farLeftTextField.delegate = self
        mediumLeftTextField.delegate = self
        centerTextField.delegate = self
        mediumRightTextField.delegate = self
        farRightTextField.delegate = self

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func truthOMeterPressed(_ sender: Any) {
        displayTextField.text = displayTextDefault
        farLeftTextField.text = farLeftTextDefault
        mediumLeftTextField.text = mediumLeftTextDefault
        centerTextField.text = centerTextDefault
        mediumRightTextField.text = mediumRightTextDefault
        farRightTextField.text = farRightTextDefault
    }

    @IBAction func bullshitOMeterPressed(_ sender: Any) {
        displayTextField.text = "Bullshit-O-Meter"
        farLeftTextField.text = "Absolute Bullshit"
        mediumLeftTextField.text = "Bullshit"
        centerTextField.text = "undecided"
        mediumRightTextField.text = "Mostly True"
        farRightTextField.text = "True"
    }

    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set(displayTextField.text, forKey: displayTextkey)
        UserDefaults.standard.set(farLeftTextField.text, forKey: farLeftTextkey)
        UserDefaults.standard.set(mediumLeftTextField.text, forKey: mediumLeftTextkey)
        UserDefaults.standard.set(centerTextField.text, forKey: centerTextkey)
        UserDefaults.standard.set(mediumRightTextField.text, forKey: mediumRightTextkey)
        UserDefaults.standard.set(farRightTextField.text, forKey: farRightTextkey)
        print("settings viewDidDisappear")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == farRightTextField {
            animateViewMoving(up: true, moveValue: 150)
        }
        if textField == mediumRightTextField {
            animateViewMoving(up: true, moveValue: 100)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == farRightTextField {
            animateViewMoving(up: false, moveValue: 150)
        }
        if textField == mediumRightTextField {
            animateViewMoving(up: false, moveValue: 100)
        }
    }
    
    // Lifting the view up
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
