//
//  MovieListInterface.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 30/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

let defaultMoviesCategory = MoviesCategory.topRated

enum MoviesCategory: Int {
    case topRated = 0, popular, upComing
}

//MARK: View
protocol MovieListViewInterface: class {
    func update()
    func updateMoviesSection(at indexPats:[IndexPath])
    func showError(_ error: String)
    func hideError()
    func showLoading(message: String)
    func hideLoading()
}

//MARK: Presenter
protocol MovieListPresenterInterface: class {
    var view: MovieListViewInterface! {set get}
    var interactor: MovieListInteractorInterface! {set get}
    
    var currentCategory: MoviesCategory { get }
    
    func viewDidLoad()
    func categoryDidChange(_ category: MoviesCategory)
    
    func movieFetchedSuccess(_ movies: Movies, category: MoviesCategory)
    func movieFetchedFail(_ error: String, category: MoviesCategory)
    
    func numberOfSections() -> Int
    func numberOfCell(in section: Int) -> Int
    func cellConfigurator(at indexPath: IndexPath) -> CellConfigurator
    func cellWasTapped(at indexPath: IndexPath)
}

//MARK: Interactor
protocol MovieListInteractorInterface: class {
    var presenter: MovieListPresenterInterface! {set get}
    
    func fetchMovie(category: MoviesCategory, page: Int)
}


//MARK: Router
protocol MovieListRouterInterface: class {
    var mainRouter: AppRouter! {set get}
    func buildMovieViewController() -> UIViewController
}
