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
    var tabBarController: TabBarController!
    
    init() {
        self.tabBarController = TabBarController()

        //Movie
        let movieListRouter = MovieListRouter()
        movieListRouter.mainRouter = self
        let movieListViewController = movieListRouter.buildMovieViewController()
        movieListViewController.tabBarItem = UITabBarItem(title: "Peliculas", image: nil, tag: 0)
        
        
        let movieListRouter2 = MovieListRouter()
        movieListRouter2.mainRouter = self
        let movieListViewController2 = movieListRouter2.buildMovieViewController()
        movieListViewController2.tabBarItem = UITabBarItem(title: "TV", image: nil, tag: 1)
        
        self.tabBarController.tabBar?.items = [movieListViewController.tabBarItem, movieListViewController2.tabBarItem]
        
        self.tabBarController.viewControllers = [movieListViewController, movieListViewController2]
        
        self.tabBarController.selectedViewController = movieListViewController
    }
    
    func initialViewController() -> UIViewController {
        return self.tabBarController
    }
    
}
