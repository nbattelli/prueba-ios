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
    }
    
    func movieFetchedSuccess(_ movie: Movie) {
        self.viewDelegate.update(movie: movie)
    }
    
    func movieFetchedFail(_ error: String) {
        //fail
    }
}
