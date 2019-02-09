//
//  PurchaseViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 08.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController {
    
    var theme: BullshitTheme?

    @IBOutlet weak var purchaseButton: UIButton!
    
    @IBOutlet weak var thankYouView: UIView!
    
    var price: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        thankYouView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(OnCustomisablePurchased), name: Notification.Name(customizablePurchasedNotification), object: nil)
        
        price = IAPService.shared.priceStringForProduct(product: .customisation)
        if price != nil {
            purchaseButton.setTitle("Purchase for "+price!, for: .normal)
        } else {
            purchaseButton.setTitle("Purchase", for: .normal)
        }
    }
    
    
    @objc func OnCustomisablePurchased() {
        thankYouView.isHidden = false
    }

    @IBAction func purchasePressed(_ sender: Any) {
        IAPService.shared.purchase(product: .customisation)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? CustomButtonViewController {
            destinationVC.theme = theme
        }
    }

}
