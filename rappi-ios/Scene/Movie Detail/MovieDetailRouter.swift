//
//  MovieDetailRouter.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 04/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit


final class MovieDetailRouter {
    weak var parentRouter: MovieListRouterInterface!
}

extension MovieDetailRouter: MovieDetailRouterInterface {
    func buildMovieDetailViewController<T: UIViewController>(movie: BaseMovieProtocol) -> T where T: DetailTransitionViewProtocol {
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter(self, interactor: interactor, preloadMovie: movie)
        
        let vc = MovieDetailViewController(presenter)
        return vc as! T
    }
}
