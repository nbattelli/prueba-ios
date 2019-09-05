//
//  MovieDetailViewController.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 02/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

final class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterBackgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    
    var presenter: MovieDetailPresenterInterface!
    
    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init(_ presenter: MovieDetailPresenterInterface) {
        self.presenter = presenter
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
        self.presenter.viewDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.primaryDarkColor
        self.presenter.viewDidLoad()
    }

}

extension MovieDetailViewController: MovieDetailViewInterface {
    func preload(previewMovie: BaseMovieProtocol) {
        self.titleLabel.text = previewMovie.title
        if let path = previewMovie.posterPath {
            let url = "https://image.tmdb.org/t/p/w500\(path)"
            self.posterBackgroundImageView.load(url: url)
        }
    }
    
    func update(movie: BaseMovieProtocol) {
        
    }
    
    func showError(_ error: String) {
        
    }
    
    func hideError() {
        
    }
    
    func showLoading(message: String) {
        
    }
    
    func hideLoading() {
        
    }
}

extension MovieDetailViewController: DetailTransitionViewProtocol {
    func transitionImageView() -> UIImageView {
        return self.posterImageView
    }
}
