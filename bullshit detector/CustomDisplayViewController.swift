//
//  CustomDisplayViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 02.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//


import UIKit

class CustomDisplayViewController: UIViewController, UITextFieldDelegate {
    
    var theme: BullshitTheme = BullshitTheme()
    
    @IBOutlet weak var displayTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = displayBackgroundColor
        
        displayTextField.text = theme.displayText
        if theme.readonly {
            displayTextField.isUserInteractionEnabled = false
            displayTextField.backgroundColor = UIColor.clear
            displayTextField.borderStyle = .none
        } else {
            displayTextField.isUserInteractionEnabled = true
            displayTextField.delegate = self
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let s = displayTextField.text {
            UserDefaults.standard.set(s, forKey: displayCustomTextkey)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "buttonSettingsSegue" {
            if let destinationVC = segue.destination as? CustomButtonViewController {
                    destinationVC.theme = theme
            }
        }
    }
    
}
