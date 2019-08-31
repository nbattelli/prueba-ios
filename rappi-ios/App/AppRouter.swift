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
    var tabBarController: UITabBarController!
    
    init() {
        self.tabBarController = UITabBarController()
        
        
        //Movie
        let movieListRouter = MovieListRouter()
        movieListRouter.mainRouter = self
        let movieListViewController = movieListRouter.buildMovieViewController()
        movieListViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 0)
        
        self.tabBarController.viewControllers = [movieListViewController]
    }
    
    func initialViewController() -> UIViewController {
        return self.tabBarController
    }
    
}
