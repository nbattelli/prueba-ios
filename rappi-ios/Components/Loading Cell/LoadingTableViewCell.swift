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
    
    override func prepareForReuse() {
        self.titleLabel.text = nil
    }
    
    func configure(model: String) {
        self.titleLabel.text = model
    }
}
