//
//  MovieListInterface.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 30/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

//MARK: View
protocol MovieListViewInterface: class {
    func update()
    func showError(_ error: String)
    func hideError()
    func showLoading(message: String)
    func hideLoading()
}

//MARK: Presenter
protocol MovieListPresenterInterface: class {
    var view: MovieListViewInterface? {set get}
    var interactor: MovieListInteractorInterface? {set get}
    
    var viewModel: [Movie]? {set get}
    
    func viewDidLoad()
    
    func movieFetchedSuccess(_ movie: [Movie])
    func movieFetchedFail(_ error: String)
}

//MARK: Interactor
protocol MovieListInteractorInterface: class {
    var presenter: MovieListPresenterInterface? {set get}
    
    func fetchTopRatedMovies(page: Int)
    func fetchPopularMovies(page: Int)
    func fetchUpcomingMovies(page: Int)
}


//MARK: Router
protocol MovieListRouterInterface: class {
    var mainRouter: AppRouter? {set get}
    func buildMovieViewController() -> UIViewController
}
