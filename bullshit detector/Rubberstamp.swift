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
    @IBOutlet weak var singleLineHeightConstraint: NSLayoutConstraint!
    
    @IBInspectable var stampColor: UIColor? {
        didSet {
            //stampView.layer.borderColor = stampColor?.cgColor
        }
    }
    
    @IBInspectable var stampText: String = "stamp text" {
        didSet {
            setTextArray(texts: [stampText])
        }
    }

    @IBInspectable var angle: CGFloat = 20.0 {
        didSet {
            if angle < 90 && angle > -90  {
                setAngle(angle: angle.rad)
            } else {
                setAngle(angle: CGFloat(90.0).rad)
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
        let A = contentView.frame.size.width
        let B = contentView.frame.size.height
        let horizontal = A > B
        let α = abs(angle)
        let γ = horizontal ? atan(B / A) : atan(A / B)
        let D = sqrt(A * A + B * B)

        let R:CGFloat = 0.0//D * 0.08
        stampView.layer.cornerRadius = R
        stampView.layer.borderWidth  = 1//D * 0.05
        let diagonalExtention:CGFloat = (sqrt(2) * cos(45.0 / 360.0 * 2.0 * CGFloat.pi - α) - 1) * R / cos(γ)
        let d = (horizontal ? B : A) / sin(α + γ) + diagonalExtention
        let b = sin(γ) * d
        let scalingFactor = d / D

        stampViewLeadingConstraint.constant  = 0.5 * (1.0 - scalingFactor) * A
        stampViewTrailingConstraint.constant = 0.5 * (1.0 - scalingFactor) * A
        stampViewTopConstraint.constant      = 0.5 * (1.0 - scalingFactor) * B
        stampViewBottomConstraint.constant   = 0.5 * (1.0 - scalingFactor) * B
        stampView.transform = CGAffineTransform(rotationAngle: angle)
        singleLineLabel.font = UIFont(name: singleLineLabel.font.fontName, size: b*0.4)
        singleLineHeightConstraint.constant = b - 2 * stampView.layer.borderWidth
    }
    
    private func setupView() {
        stampView.layer.borderColor = UIColor.red.cgColor
        stampView.backgroundColor = .clear
        singleLineLabel.text = ""
        firstLineLabel.text = ""
        secondLineLabel.text = ""
    }
    
    func setTextArray(texts: [String]) {
        let n = texts.count
        if n == 1 {
            singleLineLabel.text = texts[0]
            singleLineLabel.isHidden = false
            firstLineLabel.isHidden = true
            secondLineLabel.isHidden = true
        } else {
            firstLineLabel.text = texts[0]
            secondLineLabel.text = texts[1]
            singleLineLabel.isHidden = true
            firstLineLabel.isHidden = false
            secondLineLabel.isHidden = false
        }
    }
    
}


extension CGFloat {
    var rad: CGFloat { return self / 360.0 * 2.0 * CGFloat.pi }
}
