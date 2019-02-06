//
//  CustomDisplayViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 02.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//


import UIKit

class CustomDisplayViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var displayTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = displayBackgroundColor
        displayTextField.delegate = self
        if let s = UserDefaults.standard.string(forKey: displayCustomTextkey) {
            displayTextField.text = s
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }

    override func viewWillDisappear(_ animated: Bool) {
        if let s = displayTextField.text {
            UserDefaults.standard.set(s, forKey: displayCustomTextkey)
        }
    }

    
}
