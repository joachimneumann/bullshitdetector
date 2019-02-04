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
            if angle < 90 && angle > -90  {
                setAngle(angle: 2*CGFloat.pi*angle/360.0)
            } else {
                setAngle(angle: 2*CGFloat.pi*90/360.0)
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
        // Here, I need to rotate the stampView inside contentView
        // while keeping the centers fixes and shrinking stampView
        // to the maximal size completely inside contentView,
        // keeping its aspect ratio
        // see rectableRotation.pptx for an explanation
        // All values of angles are in radian
        
        stampViewLeadingConstraint.constant  = 0
        stampViewTrailingConstraint.constant = 0
        stampViewTopConstraint.constant    = 0
        stampViewBottomConstraint.constant = 0
        let α = abs(angle)
        let γ = atan(contentView.frame.size.height / contentView.frame.size.width)
        let A = contentView.frame.size.width
        let B = contentView.frame.size.height
        let D = sqrt(A * A + B * B)
        let d = B / sin(α + γ)
        let scalingFactor = d / D
        stampViewLeadingConstraint.constant  = 0.5 * (1.0 - scalingFactor) * A
        stampViewTrailingConstraint.constant = 0.5 * (1.0 - scalingFactor) * A
        stampViewTopConstraint.constant      = 0.5 * (1.0 - scalingFactor) * B
        stampViewBottomConstraint.constant   = 0.5 * (1.0 - scalingFactor) * B
        stampView.transform = CGAffineTransform(rotationAngle: angle)
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
