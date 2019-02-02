//
//  SettingsViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 16/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = displayBackgroundColor
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//       self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func truthOMeterPressed(_ sender: Any) {
        UserDefaults.standard.set(buttonTextDefault, forKey: buttonTextkey)
        UserDefaults.standard.set(displayTextDefault, forKey: displayTextkey)
        UserDefaults.standard.set(farLeftTextDefault, forKey: farLeftTextkey)
        UserDefaults.standard.set(leftTextDefault, forKey: leftTextkey)
        UserDefaults.standard.set(centerTextDefault, forKey: centerTextkey)
        UserDefaults.standard.set(rightTextDefault, forKey: rightTextkey)
        UserDefaults.standard.set(farRightTextDefault, forKey: farRightTextkey)
    }

    @IBAction func bullshitOMeterPressed(_ sender: Any) {
        UserDefaults.standard.set("Is that Bullshit?", forKey: buttonTextkey)
        UserDefaults.standard.set("Bullshit-O-Meter", forKey: displayTextkey)
        UserDefaults.standard.set("Absolute Bullshit", forKey: farLeftTextkey)
        UserDefaults.standard.set("Bullshit", forKey: leftTextkey)
        UserDefaults.standard.set("undecided", forKey: centerTextkey)
        UserDefaults.standard.set("Mostly True", forKey: rightTextkey)
        UserDefaults.standard.set("True", forKey: farRightTextkey)
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("settings viewDidDisappear")
    }
}
