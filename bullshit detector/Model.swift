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
        themeIndex = UserDefaults.standard.integer(forKey: themeIndexKey)
    }
    
    static let shared = Model()
    
    private var themes = [BullshitTheme]()
    var themeIndex: Int = 0
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
        let truthOMeter    = BullshitTheme()
        truthOMeter.name = "Truth-O-Meter"
        truthOMeter.imageName = "truth"
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
        
        let bullshitOMeter = BullshitTheme()
        bullshitOMeter.name = "Bullshit-O-Meter"
        bullshitOMeter.imageName = "truth"
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

        let voiceOMeter    = BullshitTheme()
        voiceOMeter.buttonText = "How is you voice?"
        voiceOMeter.imageName = "singer"
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
        voiceOMeter.name = "Voice-O-Meter"
        themes.append(voiceOMeter)

        let customised     = BullshitTheme()
        customised.name = "Customised"
        customised.imageName = "truth"
        customised.readonly = false
        themes.append(customised)
    }
    
}
