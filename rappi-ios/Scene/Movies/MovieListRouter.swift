//
//  MovieListRouter.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

class MovieListRouter {
    var mainRouter: AppRouter!
    var navigationController: UINavigationController!
}

extension MovieListRouter: MovieListRouterInterface {    
    func buildMovieViewController() -> UIViewController {
        let vc = MovieListViewController(MovieListPresenter())
        self.navigationController = UINavigationController(rootViewController: vc)
        return self.navigationController
    }
}
