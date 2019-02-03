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
    @IBInspectable var stampColor: UIColor? {
        didSet {
            contentView.layer.borderColor = stampColor?.cgColor
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
        singleLineLabel.text = "Stamp Text"
    }
    
    func setText(text: String) {
        singleLineLabel.text = text
    }
    
}
