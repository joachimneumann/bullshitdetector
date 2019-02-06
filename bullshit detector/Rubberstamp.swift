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
    @IBOutlet weak var stampLabelView: UIView!
    @IBOutlet weak var singleLineLabel: UILabel!
    @IBOutlet weak var firstLineLabel: UILabel!
    @IBOutlet weak var secondLineLabel: UILabel!
    
    @IBOutlet weak var stampViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var singleLineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var singleLineTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstLineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstLineTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLineLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLineTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var firstLineCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondLineCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stampLabelViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampLabelViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampLabelViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var stampLabelViewRightConstraint: NSLayoutConstraint!
    private var rubberEffectMask: UIImageView?
    
    @IBInspectable var stampColor: UIColor? {
        didSet {
            stampView.layer.borderColor = stampColor?.cgColor
            singleLineLabel.textColor = stampColor
            firstLineLabel.textColor = stampColor
            secondLineLabel.textColor = stampColor
        }
    }
    
    @IBInspectable private var stampText: String = "stamp text" {
        didSet {
            setTextArray(texts: [stampText])
        }
    }

    @IBInspectable private var angle: CGFloat = 20.0 {
        didSet {
            if angle < 90 && angle > -90  {
                setAngle(angle: angle.rad)
            } else {
                setAngle(angle: CGFloat(90.0).rad)
            }
        }
    }

    @IBInspectable private var border_radius: Int = 5 {
        didSet {
            setAngle(angle: angle.rad)
        }
    }
    
    @IBInspectable private var border_width: Int = 5 {
        didSet {
            setAngle(angle: angle.rad)
            stampLabelViewTopConstraint.constant = 0.5*CGFloat(border_width)
            stampLabelViewBottomConstraint.constant = 0.5*CGFloat(border_width)
            stampLabelViewLeftConstraint.constant = CGFloat(border_width)
            stampLabelViewRightConstraint.constant = CGFloat(border_width)
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
    
    private func initNib() {
        let bundle = Bundle(for: Rubberstamp.self)
        bundle.loadNibNamed("Rubberstamp", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        singleLineLabel.adjustsFontSizeToFitWidth = true
        singleLineLabel.baselineAdjustment = .alignCenters
        singleLineLabel.minimumScaleFactor = 0.2

        firstLineLabel.baselineAdjustment = .alignCenters
        firstLineLabel.minimumScaleFactor = 0.2
        firstLineLabel.font = singleLineLabel.font

        firstLineLabel.adjustsFontSizeToFitWidth = true
        secondLineLabel.adjustsFontSizeToFitWidth = true
        secondLineLabel.baselineAdjustment = .alignCenters
        secondLineLabel.minimumScaleFactor = 0.2
        secondLineLabel.font = singleLineLabel.font
    }

    
//    + (void)sizeLabelFontToMinSizeFor:(UILabel *)label1 and:(UILabel *)label2 {
//
//    NSStringDrawingContext *labelContext = [NSStringDrawingContext new];
//    labelContext.minimumScaleFactor = label1.minimumScaleFactor;
//
//    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithString:label1.text attributes:@{NSFontAttributeName : label1.font}];
//    // the NSStringDrawingUsesLineFragmentOrigin and NSStringDrawingUsesFontLeading options are magic
//    [attributedString1 boundingRectWithSize:label1.frame.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:labelContext];
//
//    CGFloat actualFontSize1 = label1.font.pointSize * labelContext.actualScaleFactor;
//
//    labelContext = [NSStringDrawingContext new];
//    labelContext.minimumScaleFactor = label2.minimumScaleFactor;
//
//    NSAttributedString *attributedString2 = [[NSAttributedString alloc] initWithString:label2.text attributes:@{NSFontAttributeName : label2.font}];
//    [attributedString2 boundingRectWithSize:label2.frame.size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:labelContext];
//
//    CGFloat actualFontSize2 = label2.font.pointSize * labelContext.actualScaleFactor;
//
//    CGFloat minSize = MIN(actualFontSize1, actualFontSize2);
//
//    label1.font = [UIFont fontWithName:RCDefaultFontName size:minSize];
//    label2.font = [UIFont fontWithName:RCDefaultFontName size:minSize];
//    }

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

        let d = (horizontal ? B : A) / sin(α + γ)
        let borderRadiusRelation = CGFloat(border_radius) / D
        let R:CGFloat = d * borderRadiusRelation
        stampView.layer.cornerRadius = R

        let borderWidthRelation = CGFloat(border_width) / D
        let borderWidth = d * borderWidthRelation
        stampView.layer.borderWidth = borderWidth
        singleLineTrailingConstraint.constant = 0
        singleLineLeadingConstraint.constant = 0
        singleLineTrailingConstraint.constant = 0
        singleLineLeadingConstraint.constant = 0
        singleLineTrailingConstraint.constant = 0
        singleLineLeadingConstraint.constant = 0
        let extensionAngle = α < CGFloat(45.0).rad ? CGFloat(45.0).rad - α : α - CGFloat(45.0).rad
        let diagonalExtension:CGFloat = sqrt(2)*(sqrt(2) * cos(extensionAngle) - 1) * R / cos(γ)
        let extended_d = (horizontal ? B : A) / sin(α + γ) + diagonalExtension
        let scalingFactor = extended_d / D

        stampViewLeadingConstraint.constant  = 0.5 * (1.0 - scalingFactor) * A
        stampViewTrailingConstraint.constant = 0.5 * (1.0 - scalingFactor) * A
        stampViewTopConstraint.constant      = 0.5 * (1.0 - scalingFactor) * B
        stampViewBottomConstraint.constant   = 0.5 * (1.0 - scalingFactor) * B
        stampView.transform = CGAffineTransform(rotationAngle: angle)
    }
    
    func rubbereffect(imageName: String) {
        let maskImage = UIImage(named: imageName)
        let maskImageView = UIImageView(image: maskImage)
        maskImageView.contentMode = .scaleAspectFill
        var contentFrame = contentView.frame
        contentFrame.origin.y = 0
        contentFrame.origin.x = 0
        maskImageView.frame = contentFrame
        contentView.mask = maskImageView
    }

    func setTextArray(texts: [String]) {
        firstLineCenterConstraint.constant = -0.25 * stampLabelView.frame.size.height
        secondLineCenterConstraint.constant = 0.25 * stampLabelView.frame.size.height
        var n = texts.count
        if n == 2 {
            // second text empty?
            let texts1 = texts[1].copy() as! String
            let trimmed = texts1.trimmingCharacters(in: NSCharacterSet.whitespaces)
            if trimmed.count == 0 {
                n = 1
            }
        }
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

private func adjustedFontSizeForLabel(_ label: UILabel) -> CGFloat {
    let text: NSMutableAttributedString = NSMutableAttributedString(attributedString: label.attributedText!)
    text.setAttributes([NSAttributedString.Key.font: label.font], range: NSMakeRange(0, text.length))
    let context: NSStringDrawingContext = NSStringDrawingContext()
    context.minimumScaleFactor = label.minimumScaleFactor
    text.boundingRect(with: label.frame.size, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: context)
    let adjustedFontSize: CGFloat = label.font.pointSize * context.actualScaleFactor
    return adjustedFontSize
}


private extension CGFloat {
    var rad: CGFloat { return self / 360.0 * 2.0 * CGFloat.pi }
}
