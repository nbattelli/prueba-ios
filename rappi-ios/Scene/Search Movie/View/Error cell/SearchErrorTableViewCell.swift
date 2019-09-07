//
//  SearchErrorTableViewCell.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 07/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

class SearchErrorTableViewCell: UITableViewCell, ConfigurableCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(model: String) {
        self.titleLabel.text = model
    }
    
}
