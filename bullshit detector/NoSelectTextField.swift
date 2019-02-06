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
//        if action == #selector(paste(_:)) ||
//            action == #selector(cut(_:)) ||
//            action == #selector(copy(_:)) ||
//            action == #selector(select(_:)) ||
//            action == #selector(selectAll(_:)) ||
//            action == #selector(delete(_:)) ||
//            action == #selector(lookup(_:)) ||
//            action == #selector(define(_:)) ||
//            action == #selector(share(_:)) ||
//            action == #selector(makeTextWritingDirectionLeftToRight(_:)) ||
//            action == #selector(makeTextWritingDirectionRightToLeft(_:)) ||
//            action == #selector(toggleBoldface(_:)) ||
//            action == #selector(toggleItalics(_:)) ||
//            action == #selector(toggleUnderline(_:)) {
//            return false
//        }
//        return super.canPerformAction(action, withSender: sender)
    }
    
}
