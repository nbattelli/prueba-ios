//
//  MovieDetailInterface.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 04/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import UIKit

//MARK: View
protocol MovieDetailViewInterface: class {
    func preload(previewMovie: BaseMovieProtocol)
    func update(movie: BaseMovieProtocol)
    func showError(_ error: String)
    func hideError()
    func showLoading(message: String)
    func hideLoading()
}

//MARK: Presenter
protocol MovieDetailPresenterInterface: class {
    var router: MovieDetailRouterInterface! { get }
    var viewDelegate: MovieDetailViewInterface! {set get}
    var interactor: MovieDetailInteractorInterface! { get }
    
    func viewDidLoad()
    
    func movieFetchedSuccess(_ movie: Movie)
    func movieFetchedFail(_ error: String)
}

//MARK: Interactor
protocol MovieDetailInteractorInterface: class {
    var presenterDelegate: MovieDetailPresenterInterface! {set get}
    func fetchMovieDetail(id: String)
}


//MARK: Router
protocol MovieDetailRouterInterface: class {
    var parentRouter: MovieListRouterInterface! {set get}
    func buildMovieDetailViewController<T:UIViewController>(movie: BaseMovieProtocol) -> T where T: DetailTransitionViewProtocol
}

