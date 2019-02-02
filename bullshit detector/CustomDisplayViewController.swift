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
        displayTextField.text = UserDefaults.standard.string(forKey: displayTextkey)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayTextField.text = UserDefaults.standard.string(forKey: displayTextkey)
    }

    override func viewWillDisappear(_ animated: Bool) {
        UserDefaults.standard.set(displayTextField.text, forKey: displayTextkey)
    }

    
}
