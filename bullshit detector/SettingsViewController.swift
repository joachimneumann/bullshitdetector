//
//  SettingsViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 16/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var customizeButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.gray
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        view.backgroundColor = displayBackgroundColor
        purchasedOrNot()
        NotificationCenter.default.addObserver(self, selector: #selector(OnCustomisablePurchased), name: Notification.Name(customisablePurchasedKey), object: nil)

    }

    @objc func OnCustomisablePurchased() {
        purchasedOrNot()
    }
    
    func purchasedOrNot() {
        if UserDefaults.standard.bool(forKey: customisablePurchasedKey) {
            customizeButton.isHidden = false
        } else {
            customizeButton.isHidden = true
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @IBAction func truthOMeterPressed(_ sender: Any) {
        UserDefaults.standard.set(Template.TruthOMeter.rawValue, forKey: templatekey)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func bullshitOMeterPressed(_ sender: Any) {
        UserDefaults.standard.set(Template.BullshitOMeter.rawValue, forKey: templatekey)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func voiceOMeterPressed(_ sender: Any) {
        UserDefaults.standard.set(Template.VoiceOMeter.rawValue, forKey: templatekey)
        navigationController?.popViewController(animated: true)
    }

    
    @IBAction func purchasePressed(_ sender: Any) {
        IAPService.shared.purchase(product: .customisation)
//        IAPService.shared.restorePurchases()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "customizingSeque" {
            UserDefaults.standard.set(Template.Custom.rawValue, forKey: templatekey)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("settings viewDidDisappear")
    }
}
