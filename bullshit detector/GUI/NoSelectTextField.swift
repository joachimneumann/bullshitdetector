//
//  NoSelectTextField.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 06.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

class NoSelectTextField: UITextField {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
}
