//
//  Model.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 07.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import Foundation

class Model: NSObject {
    private override init() {
        super.init()
        defaultValues()
    }
    
    static let shared = Model()
    
    private var themes = [BullshitTheme]()
    private var _themeIndex: Int = 0

    var themeIndex: Int {
        get {
            return UserDefaults.standard.integer(forKey: selectedThemeIndexKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: selectedThemeIndexKey)
        }
    }

    var instructionsHaveBeenDisplayed: Bool {
        get {
            return UserDefaults.standard.bool(forKey: instructionsHaveBeenDisplayedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: instructionsHaveBeenDisplayedKey)
        }
    }
    
    var customizationHasBeenPurchased: Bool {
        get {
            return UserDefaults.standard.bool(forKey: customizationHasBeenPurchasedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: customizationHasBeenPurchasedKey)
        }
    }

    var count: Int {
        get {
            return themes.count
        }
    }

    func themeName(n: Int) -> String {
        if n >= 0 && n < themes.count {
            return themes[n].name
        } else {
            return ""
        }
    }
    
    func theme() -> BullshitTheme {
        return themes[themeIndex]
    }
    func theme(index: Int) -> BullshitTheme {
        return themes[index]
    }

    func defaultValues() {
        let truthOMeter    = BullshitTheme(name: "Truth-O-Meter", readonly: true, imageName: "truth")
        truthOMeter.buttonText = "Is that true?"
        truthOMeter.displayText = "Truth-O-Meter"
        truthOMeter.farLeftText1 = "True"
        truthOMeter.farLeftText2 = ""
        truthOMeter.leftText1 = "Mostly"
        truthOMeter.leftText2 = "True"
        truthOMeter.centerText1 = "Undecided"
        truthOMeter.centerText2 = ""
        truthOMeter.rightText1 = "Bullshit"
        truthOMeter.rightText2 = ""
        truthOMeter.farRightText1 = "Absolute"
        truthOMeter.farRightText2 = "Bullshit"
        themes.append(truthOMeter)
        
        let bullshitOMeter = BullshitTheme(name: "Bullshit-O-Meter", readonly: true, imageName: "truth")
        bullshitOMeter.buttonText = "Is that Bullshit?"
        bullshitOMeter.displayText = "Bullshit-O-Meter"
        bullshitOMeter.farLeftText1 = "Absolute"
        bullshitOMeter.farLeftText2 = "Bullshit"
        bullshitOMeter.leftText1 = "Bullshit"
        bullshitOMeter.leftText2 = ""
        bullshitOMeter.centerText1 = "undecided"
        bullshitOMeter.centerText2 = ""
        bullshitOMeter.rightText1 = "Mostly"
        bullshitOMeter.rightText2 = "True"
        bullshitOMeter.farRightText1 = "True"
        bullshitOMeter.farRightText2 = ""
        themes.append(bullshitOMeter)

        let voiceOMeter = BullshitTheme(name: "Voice-O-Meter", readonly: true, imageName: "singer")
        voiceOMeter.buttonText = "How is you voice?"
        voiceOMeter.displayText = "Voice-O-Meter"
        voiceOMeter.farLeftText1 = "Sexy"
        voiceOMeter.farLeftText2 = ""
        voiceOMeter.leftText1 = "impressive"
        voiceOMeter.leftText2 = ""
        voiceOMeter.centerText1 = "good"
        voiceOMeter.centerText2 = ""
        voiceOMeter.rightText1 = "could be"
        voiceOMeter.rightText2 = "better"
        voiceOMeter.farRightText1 = "flimsy"
        voiceOMeter.farRightText2 = ""
        themes.append(voiceOMeter)

        let customised     = BullshitTheme(name: "Customised", readonly: false, imageName: "truth")
        themes.append(customised)
    }
    
}
