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

    @IBAction func factoryResetPressed(_ sender: Any) {
        factoryReset()
    }

    func factoryReset() {
        displayTextField.text = "Truth-O-Meter"
        farLeftTextField.text = "True"
        mediumLeftTextField.text = "mostly True"
        centerTextField.text = "undecided"
        mediumRightTextField.text = "Bullshit"
        farRightTextField.text = "Absolute Bullshit"
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
