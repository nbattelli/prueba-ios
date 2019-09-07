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
//    var tabBarController: TabBarController!
//
//    init() {
//        self.tabBarController = TabBarController()
//
//        //Movie
//        let movieListRouter = MovieListRouter()
//        let movieListViewController = movieListRouter.buildMovieViewController()
//        movieListViewController.tabBarItem = UITabBarItem(title: "Peliculas", image: UIImage(named: "tabbar-movie"), tag: 0)
//
//
//        let movieListRouter2 = MovieListRouter()
//        let movieListViewController2 = movieListRouter2.buildMovieViewController()
//        movieListViewController2.tabBarItem = UITabBarItem(title: "TV", image: nil, tag: 1)
//
//        self.tabBarController.tabBar?.items = [movieListViewController.tabBarItem, movieListViewController2.tabBarItem]
//
//        self.tabBarController.viewControllers = [movieListViewController, movieListViewController2]
//
//        self.tabBarController.selectedViewController = movieListViewController
//    }
    
    func initialViewController() -> UIViewController {
        let movieListRouter = MovieListRouter()
        return movieListRouter.buildMovieViewController()//self.tabBarController
    }
    
}
