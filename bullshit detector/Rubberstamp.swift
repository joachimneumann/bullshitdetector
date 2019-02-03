//
//  Rubberstamp.swift
//  bullshit detector
//
//  Created by Joachim Neumann on 03.02.19.
//  Copyright © 2019 Joachim Neumann. All rights reserved.
//

import UIKit

@IBDesignable
class Rubberstamp: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var singleLineLabel: UILabel!
    @IBOutlet weak var firstLineLabel: UILabel!
    @IBOutlet weak var secondLineLabel: UILabel!
    
    @IBInspectable var stampColor: UIColor? {
        didSet {
            contentView.layer.borderColor = stampColor?.cgColor
        }
    }
    
    @IBInspectable var stampText: String = "stamp text" {
        didSet {
            setText(text: stampText)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initNib()
    }
    
    func initNib() {
        let bundle = Bundle(for: Rubberstamp.self)
        bundle.loadNibNamed("Rubberstamp", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupView()
    }

    private func setupView() {
        contentView.layer.cornerRadius = 25;
        contentView.layer.masksToBounds = true;
        contentView.layer.borderColor = UIColor.red.cgColor
        contentView.layer.borderWidth = 20.0
        contentView.backgroundColor = .yellow
        singleLineLabel.text = "single line2"
        firstLineLabel.text = "first line2"
        secondLineLabel.text = "second line2"
//        contentView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 20)
    }
    
    func setText(text: String) {
        let n = text.components(separatedBy: " ").count
        if n < 2 {
            singleLineLabel.text = text
            singleLineLabel.isHidden = false
            firstLineLabel.isHidden = true
            secondLineLabel.isHidden = true
        } else {
            firstLineLabel.text = text.components(separatedBy: " ")[0]
            secondLineLabel.text = text.components(separatedBy: " ")[1]
            singleLineLabel.isHidden = true
            firstLineLabel.isHidden = false
            secondLineLabel.isHidden = false
        }
        singleLineLabel.text = text
    }
    
}
