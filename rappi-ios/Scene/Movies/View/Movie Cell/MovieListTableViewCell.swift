//
//  MovieListTableViewCell.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

final class MovieListTableViewCell: UITableViewCell, ConfigurableCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func prepareForReuse() {
        self.movieImageView.image = nil
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }
    
    func configure(model: MovieListCellViewModel) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.movieDescription
        if let url = model.imageURL {
            self.movieImageView.load(url: url)
        }
    }
}
