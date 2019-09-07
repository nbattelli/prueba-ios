//
//  AppRouter.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

protocol AppRouterInterface {
    func initialViewController()
}

final class AppRouter {
    func initialViewController() -> UIViewController {
        let movieListRouter = MovieListRouter()
        return movieListRouter.buildMovieViewController()
    }
    
}
