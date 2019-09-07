//
//  BannerView.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 06/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

@IBDesignable
final class BannerView: UIView {
    
    let nibName = "BannerView"

    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var errorButton: UIButton!
    @IBOutlet weak var hideButtonLayout: NSLayoutConstraint!
    
    var actionBlock: (()->Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let xibView = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)!.first as! UIView
        xibView.frame = self.bounds
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.addSubview(xibView)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.primaryColor
        self.errorButton.titleLabel?.textColor = UIColor.secondaryColor
    }
    
    func configure(error: String,
                   buttonTitle: String?,
                   actionBlock:(()->Void)?)
    {
        self.errorMessageLabel.text = error
        if buttonTitle?.count ?? 0 > 0 {
            self.errorButton.setTitle(buttonTitle, for: .normal)
            self.hideButtonLayout.priority = .defaultLow
            self.actionBlock = actionBlock
        } else {
            self.hideButtonLayout.priority = .defaultHigh
        }
    }
    
    @IBAction private func errorWasTapped() {
        self.actionBlock?()
    }
}
