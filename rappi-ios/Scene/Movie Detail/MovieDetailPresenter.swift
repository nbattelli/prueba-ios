//
//  MovieDetailPresenter.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 04/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

final class MovieDetailPresenter {
    var router: MovieDetailRouterInterface!
    weak var viewDelegate: MovieDetailViewInterface!
    var interactor: MovieDetailInteractorInterface!
    
    var preloadMovie: BaseMovieProtocol
    var viewModel: MovieDetail?
    var videos: [MovieVideo]?
    
    init(_ router: MovieDetailRouterInterface, interactor: MovieDetailInteractorInterface, preloadMovie: BaseMovieProtocol) {
        self.router = router
        self.interactor = interactor
        self.preloadMovie = preloadMovie
        self.interactor.presenterDelegate = self
    }
}

extension MovieDetailPresenter: MovieDetailPresenterInterface {
    
    func viewDidLoad() {
        self.viewDelegate.preload(previewMovie: self.preloadMovie)
        self.interactor.fetchMovieDetail(id: self.preloadMovie.id)
        self.interactor.fetchMovieVideos(id: self.preloadMovie.id)
    }
    
    func movieFetchedSuccess(_ movieDetail: MovieDetail) {
        self.viewModel = movieDetail
        self.viewDelegate.update()
    }
    
    func movieFetchedFail(_ error: String) {
        //fail
    }
    
    func movieVideosFetchedSuccess(_ videos: [MovieVideo]) {
        self.videos = videos
        self.viewDelegate.updateVideos()
    }
    
    func movieVideosFetchedFail(_ error: String) {
        //fail
    }
}
