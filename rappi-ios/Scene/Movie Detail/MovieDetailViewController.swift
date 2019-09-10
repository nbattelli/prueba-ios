//
//  MovieDetailViewController.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 02/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit
import Cosmos
import YoutubePlayer_in_WKWebView

final class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var posterBackgroundImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView! {
        didSet {
            posterImageView.layer.cornerRadius = 8
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    @IBOutlet weak var starView: CosmosView! {
        didSet {
            starView.settings.filledColor = UIColor.secondaryLightColor
            starView.settings.filledBorderColor = UIColor.secondaryLightColor
            starView.settings.emptyBorderColor = UIColor.secondaryLightColor
        }
    }
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var genreStackView: UIStackView!
    @IBOutlet weak var videosSectionView: UIView!
    @IBOutlet weak var videosScrollView: UIScrollView!
    @IBOutlet weak var videosStackView: UIStackView!
    
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
        
        self.setupReleaseDate()
        self.setupGenre()
        self.setupVideos()
    }
    
    private func setupReleaseDate() {
        guard let releaseDate = self.presenter.viewModel?.releaseDate else {
            self.releaseDateLabel.isHidden = true
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from:releaseDate) {
            dateFormatter.dateFormat = "yyyy"
            let resultString = dateFormatter.string(from: date)
            
            self.releaseDateLabel.isHidden = false
            self.releaseDateLabel.text = resultString
        } else {
            self.releaseDateLabel.isHidden = true
        }
    }
    
    private func setupGenre() {
        guard let genreDict = self.presenter.viewModel?.genres else {
            self.genreStackView.isHidden = true
            return
        }
        
        self.genreStackView.isHidden = false
        
        self.genreStackView.subviews.forEach {$0.removeFromSuperview()}
        
        let genre = genreDict.map{ $0.name }
        
        genre.forEach {
            let label = TagLabel.buildTagLabel($0)
            self.genreStackView.addArrangedSubview(label)
        }
    }
    
    private func setupVideos() {
        self.videosStackView.subviews.forEach {$0.removeFromSuperview()}
        
        guard let videosModel = self.presenter.videos, videosModel.count > 0 else {
            self.videosSectionView.isHidden = true
            return
        }
        
        self.videosSectionView.isHidden = false
        
        videosModel.forEach {
            let videoView = WKYTPlayerView()
            videoView.backgroundColor = UIColor.primaryLightColor
            videoView.load(withVideoId: $0.key)
            self.videosStackView.addArrangedSubview(videoView)
            
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoView.widthAnchor.constraint(equalToConstant: self.videosScrollView.frame.width).isActive = true
            videoView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
        }
    }

}

extension MovieDetailViewController: MovieDetailViewInterface {
    func preload(previewMovie: BaseMovieProtocol) {
        self.titleLabel.text = previewMovie.title
        if let path = previewMovie.posterPath {
            let url = "https://image.tmdb.org/t/p/w500\(path)"
            self.posterBackgroundImageView.load(url: url)
        }
        self.overview.text = previewMovie.overview
        self.starView.rating = (previewMovie.voteAvarage ?? 0) / 2.0
    }
    
    func update() {
        self.setupReleaseDate()
        self.setupGenre()
    }
    
    func updateVideos() {
        self.setupVideos()
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
