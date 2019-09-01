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
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.textColor = UIColor.primaryTextColor
        }
    }
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.textColor = UIColor.primaryTextColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.primaryLightColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieImageView.image = nil
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
    }
    
    func configure(model: MovieListCellViewModel) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.movieDescription
        if let path = model.imagePath {
            let url = "https://image.tmdb.org/t/p/w500\(path)"
            self.movieImageView.load(url: url)
        }
    }
}
