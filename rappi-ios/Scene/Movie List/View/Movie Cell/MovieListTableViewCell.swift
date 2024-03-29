//
//  MovieListTableViewCell.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialInk
import Cosmos

final class MovieListTableViewCell: UITableViewCell, ConfigurableCell {
    
    var inkController: MDCInkTouchController!
    
    @IBOutlet weak var containerView : UIView! {
        didSet {
            self.containerView.backgroundColor = UIColor.primaryColor
            self.containerView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var movieImageView: UIImageView! {
        didSet {
            self.movieImageView.layer.cornerRadius = 8
        }
    }
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
    @IBOutlet weak var starView: CosmosView! {
        didSet {
            starView.settings.filledColor = UIColor.secondaryLightColor
            starView.settings.filledBorderColor = UIColor.secondaryLightColor
            starView.settings.emptyBorderColor = UIColor.secondaryLightColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.primaryDarkColor
        
        self.inkController = MDCInkTouchController(view: self.containerView)
        inkController.addInkView()
        inkController.defaultInkView.inkColor = UIColor.secondaryLightColor.withAlphaComponent(0.2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieImageView.image = nil
        self.titleLabel.text = nil
        self.descriptionLabel.text = nil
        self.starView.rating = 0
    }
    
    func configure(model: MovieViewModel) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.overview
        self.starView.rating = (model.voteAvarage ?? 0) / 2.0
        if let path = model.posterPath {
            let url = "https://image.tmdb.org/t/p/w200\(path)"
            self.movieImageView.load(url: url)
        }
    }
}

extension MovieListTableViewCell: CellTransitionViewProtocol {
    func transitionImageView() -> UIImageView {
        return self.movieImageView
    }
}
