//
//  LoadingTableViewCell.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 01/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

final class LoadingTableViewCell: UITableViewCell, ConfigurableCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    {
        didSet {
            activity.color = UIColor.secondaryLightColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.primaryDarkColor
    }
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
    }
    
    func configure(model: String) {
        self.titleLabel.text = model
    }
}
