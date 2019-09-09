//
//  TagLabel.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 08/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

final class TagLabel: UILabel {
    
    let inset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)

    
    static func buildTagLabel(_ text: String) -> TagLabel {
        let label = TagLabel()
        label.textColor = UIColor.secondaryLightColor
        label.text = text
        return label
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    
    override func layoutSubviews() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.secondaryLightColor.cgColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += inset.left + inset.right
        intrinsicContentSize.height += inset.top + inset.bottom
        return intrinsicContentSize
    }

}
