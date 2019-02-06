//
//  constants.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 16/01/2019.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import Foundation
import UIKit

let displayBackgroundColor = UIColor(red: 243/255.0, green: 238/255.0, blue: 220/255.0, alpha: 1.0)
let bullshitRed = UIColor(red: 255.0/255.0, green: 126.0/255.0, blue: 121.0/255.0, alpha: 1.0)
let bullshitGray = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)

enum Template: String {
    case TruthOMeter = "TruthOMeter"
    case BullshitOMeter = "BullshitOMeter"
    case Custom = "Custom"
}

let templatekey              = "templatekey"
let buttonCustomTextkey      = "buttonCustomTextkey"
let displayCustomTextkey     = "displayCustomTextkey"
let farLeftCustomTextkey     = "farLeftCustomTextkey"
let leftCustomTextkey        = "leftCustomTextkey"
let centerCustomTextkey      = "centerCustomTextkey"
let rightCustomTextkey       = "rightCustomTextkey"
let farRightCustomTextkey    = "farRightCustomTextkey"
let instructionsDisplayedKey = "instructionsDisplayedKey"

