//
//  SearchMovieTableViewCell.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 07/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit
import MaterialComponents.MDCInkTouchController

class SearchMovieTableViewCell: UITableViewCell, ConfigurableCell {
    
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
    }
    
    func configure(model: SearchMovieTableViewCellModel) {
        self.titleLabel.text = model.title
        if let path = model.posterPath {
            let url = "https://image.tmdb.org/t/p/w200\(path)"
            self.movieImageView.load(url: url)
        }
    }
}

extension SearchMovieTableViewCell: CellTransitionViewProtocol {
    func transitionImageView() -> UIImageView {
        return self.movieImageView
    }
    
    
}

struct SearchMovieTableViewCellModel: BaseMovieProtocol {
    var id: Int
    var title: String
    var overview: String?
    var posterPath: String?
}
