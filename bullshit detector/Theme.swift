//
//  Theme.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 07.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import Foundation

class BullshitTheme {
    let name: String
    let readonly: Bool
    let imageName: String
    init(name: String, readonly: Bool, imageName: String) {
        self.name = name
        self.readonly = readonly
        self.imageName = imageName
    }

    private var _buttonText: String = ""
    private var _displayText: String = ""
    private var _farLeftText1: String = ""
    private var _farLeftText2: String = ""
    private var _leftText1: String = ""
    private var _leftText2: String = ""
    private var _centerText1: String = ""
    private var _centerText2: String = ""
    private var _rightText1: String = ""
    private var _rightText2: String = ""
    private var _farRightText1: String = ""
    private var _farRightText2: String = ""

    var buttonText: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + buttonTextkey) {
                    return res
                } else {
                    return ""
                }
            }
            return _buttonText
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + buttonTextkey)
            } else {
                _buttonText = newValue
            }
        }
    }
    var displayText: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + displayTextkey) {
                    return res
                } else {
                    return ""
                }
            }
            return _displayText
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + displayTextkey)
            } else {
                _displayText = newValue
            }
        }
    }
    var farLeftText1: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + farLeftText1key) {
                    return res
                } else {
                    return ""
                }
            }
            return _farLeftText1
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + farLeftText1key)
            } else {
                _farLeftText1 = newValue
            }
        }
    }
    var farLeftText2: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + farLeftText2key) {
                    return res
                } else {
                    return ""
                }
            }
            return _farLeftText2
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + farLeftText2key)
            } else {
                _farLeftText2 = newValue
            }
        }
    }
    var leftText1: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + leftText1key) {
                    return res
                } else {
                    return ""
                }
            }
            return _leftText1
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + leftText1key)
            } else {
                _leftText1 = newValue
            }
        }
    }
    var leftText2: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + leftText2key) {
                    return res
                } else {
                    return ""
                }
            }
            return _leftText2
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + leftText2key)
            } else {
                _leftText2 = newValue
            }
        }
    }
    var centerText1: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + centerText1key) {
                    return res
                } else {
                    return ""
                }
            }
            return _centerText1
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + centerText1key)
            } else {
                _centerText1 = newValue
            }
        }
    }
    var centerText2: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + centerText2key) {
                    return res
                } else {
                    return ""
                }
            }
            return _centerText2
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + centerText2key)
            } else {
                _centerText2 = newValue
            }
        }
    }
    var rightText1: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + rightText1key) {
                    return res
                } else {
                    return ""
                }
            }
            return _rightText1
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + rightText1key)
            } else {
                _rightText1 = newValue
            }
        }
    }
    var rightText2: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + rightText2key) {
                    return res
                } else {
                    return ""
                }
            }
            return _rightText2
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + rightText2key)
            } else {
                _rightText2 = newValue
            }
        }
    }
    var farRightText1: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + farRightText1key) {
                    return res
                } else {
                    return ""
                }
            }
            return _farRightText1
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + farRightText1key)
            } else {
                _farRightText1 = newValue
            }
        }
    }
    var farRightText2: String {
        get {
            if !readonly {
                if let res = UserDefaults.standard.string(forKey: name + farRightText2key) {
                    return res
                } else {
                    return ""
                }
            }
            return _farRightText2
        }
        set {
            if !readonly {
                UserDefaults.standard.set(newValue, forKey: name + farRightText2key)
            } else {
                _farRightText2 = newValue
            }
        }
    }
    
}

