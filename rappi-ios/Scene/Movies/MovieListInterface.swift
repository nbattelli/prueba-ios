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
}

//MARK: View
protocol MovieListViewInterface: class {
    func update()
    func updateMoviesSection(at indexPaths:[IndexPath], category: MoviesCategory)
    func updateMoviesSection(at indexPaths:[IndexPath], removeSection: Int, category: MoviesCategory)
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
    
    func numberOfSections(category: MoviesCategory) -> Int
    func numberOfCell(in section: Int, category: MoviesCategory) -> Int
    func cellConfigurator(at indexPath: IndexPath, category: MoviesCategory) -> CellConfigurator
    func cellWasTapped(at indexPath: IndexPath, category: MoviesCategory)
    func filterMovies(_ filter: String)
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

