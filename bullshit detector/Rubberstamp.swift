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
    @IBOutlet weak var stampView: UIView!
    @IBOutlet weak var singleLineLabel: UILabel!
    @IBOutlet weak var firstLineLabel: UILabel!
    @IBOutlet weak var secondLineLabel: UILabel!
    
    @IBOutlet weak var stampViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampViewBottomConstraint: NSLayoutConstraint!

    @IBInspectable var stampColor: UIColor? {
        didSet {
            stampView.layer.borderColor = stampColor?.cgColor
        }
    }
    
    @IBInspectable var stampText: String = "stamp text" {
        didSet {
            setText(text: stampText)
        }
    }

    @IBInspectable var angle: CGFloat = 45.0 {
        didSet {
            if angle < 45 && angle > -45  {
                setAngle(angle: 2*CGFloat.pi*angle/360.0)
            } else {
                setAngle(angle: 2*CGFloat.pi*45/360.0)
            }
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

    private func setAngle(angle: CGFloat) {
//        stampView.transform = CGAffineTransform(rotationAngle: 0)
//        stampViewLeadingConstraint.constant = 0
//        stampViewTrailingConstraint.constant = 0
//        stampViewTopConstraint.constant = 0
//        stampViewBottomConstraint.constant = 0
//        stampView.layoutIfNeeded()
        stampView.transform = CGAffineTransform(rotationAngle: angle)
                stampView.layoutIfNeeded()
        print("angle = \(angle)")
        print("stampView frame = \(stampView.frame.size)")
        print("stampView bounds = \(stampView.bounds.size)")
        print("contentView frame = \(contentView.frame.size)")
        print("contentView bounds = \(contentView.bounds.size)")
        let rotationWidthReduction: CGFloat = -0.5*cos(angle) * (stampView.bounds.size.width - stampView.frame.size.width)
        let rotationHeightReduction: CGFloat = -0.5*cos(angle) * (stampView.bounds.size.height - stampView.frame.size.height)
        print("rotationWidthReduction = \(rotationWidthReduction)")
        print("rotationHeightReduction = \(rotationHeightReduction)")
        stampViewLeadingConstraint.constant = rotationWidthReduction
        stampViewTrailingConstraint.constant = rotationWidthReduction
        stampViewTopConstraint.constant = rotationHeightReduction
        stampViewBottomConstraint.constant = rotationHeightReduction
        stampView.layoutIfNeeded()
    }
    
    private func setupView() {
        stampView.layer.cornerRadius = 0;
        stampView.layer.masksToBounds = true;
        stampView.layer.borderColor = UIColor.red.cgColor
        stampView.layer.borderWidth = 1.0
        stampView.backgroundColor = .yellow
        singleLineLabel.text = "single line2"
        firstLineLabel.text = "first line2"
        secondLineLabel.text = "second line2"
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
