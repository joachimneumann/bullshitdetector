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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func truthOMeterPressed(_ sender: Any) {
        UserDefaults.standard.set(Template.TruthOMeter.rawValue, forKey: templatekey)
        BullshitViewController.__defaultTexts()
    }

    @IBAction func bullshitOMeterPressed(_ sender: Any) {
        UserDefaults.standard.set(Template.BullshitOMeter.rawValue, forKey: templatekey)
        BullshitViewController.__bullshitOMeterTexts()
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("settings viewDidDisappear")
    }
}
