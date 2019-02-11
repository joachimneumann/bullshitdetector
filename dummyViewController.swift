//
//  dummyViewController.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 11.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class dummyViewController: UIViewController {

    @IBOutlet weak var display: Display!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func redraw(_ sender: Any) {
        display.rotateNeedle(to: 0.0)
    }

    @IBAction func xx(_ sender: Any) {
        display.rotateNeedle(to: 0.5)
    }
    @IBAction func xxx(_ sender: Any) {
        display.rotateNeedle(to: 1.0)
    }
}
