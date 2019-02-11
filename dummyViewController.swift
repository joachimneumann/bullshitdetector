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
        display.drawNeedle(newValue: 0.0)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
//            self.display.drawNeedle(newValue: 0.8)
//        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
