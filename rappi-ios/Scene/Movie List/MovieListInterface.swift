//
//  MovieListInterface.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 30/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

enum MoviesCategory: Int, CaseIterable {
    case topRated, popular, upComing
    
    static var defaultMoviesCategory: MoviesCategory {
        return MoviesCategory.allCases.first!
    }
    
    var description: String {
        switch self {
        case .topRated: return "Top"
        case .popular: return "Popular"
        case .upComing: return "Nuevo"
        }
    }
    
    func configurator(page: Int) -> MovieConfigurator {
        switch self {
        case .topRated: return MovieConfigurator.topRated(page: page)
        case .popular: return MovieConfigurator.popular(page: page)
        case .upComing: return MovieConfigurator.upComing(page: page)
        }
    }
    
    func fileName() -> String {
        switch self {
        case .topRated: return "movie-top-rated.json"
        case .popular: return "movie-popular.json"
        case .upComing: return "movie-nuevo.json"
        }
    }
}


//MARK: View
protocol MovieListViewInterface: class {
    func update(category: MoviesCategory)
    func updateMoviesSection(at indexPaths:[IndexPath], category: MoviesCategory)
    func updateMoviesSection(at indexPaths:[IndexPath], removeSection: Int, category: MoviesCategory)
    func showError(_ error: String, buttonTitle: String, actionBlock:(()->Void)?)
    func hideError()
    func showLoading()
    func hideLoading()
}

//MARK: Presenter
protocol MovieListPresenterInterface: class {
    var router: MovieListRouterInterface! { get }
    var viewDelegate: MovieListViewInterface! {set get}
    var interactor: MovieListInteractorInterface! { get }
    
    var currentCategory: MoviesCategory { get }
    
    func viewDidLoad()
    func reloadCurrentCategory()
    func categoryDidChange(_ category: MoviesCategory)
    
    func movieFetchedSuccess(_ movies: Movies, category: MoviesCategory)
    func movieFetchedFail(_ error: String, category: MoviesCategory)
    
    func numberOfSections(category: MoviesCategory) -> Int
    func numberOfCell(in section: Int, category: MoviesCategory) -> Int
    func cellConfigurator(at indexPath: IndexPath, category: MoviesCategory) -> CellConfigurator
    func cellWasTapped(_ cell: CellTransitionViewProtocol, at indexPath: IndexPath, category: MoviesCategory)
    func filterMovies(_ filter: String)
}

//MARK: Interactor
protocol MovieListInteractorInterface: class {
    var presenterDelegate: MovieListPresenterInterface! {set get}
    func fetchMovie(category: MoviesCategory, page: Int)
}


//MARK: Router
protocol MovieListRouterInterface: class {
    func buildMovieViewController() -> UIViewController
    func movieCellWasTapped(_ cell: CellTransitionViewProtocol, model: Movie)
}

