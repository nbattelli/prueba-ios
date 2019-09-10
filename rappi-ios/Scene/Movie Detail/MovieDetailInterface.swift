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
    func update()
    func updateVideos()
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
    
    var viewModel: MovieDetail? { get }
    var videos: [MovieVideo]? { get }
    
    func viewDidLoad()
    
    func movieFetchedSuccess(_ movie: MovieDetail)
    func movieFetchedFail(_ error: String)
    
    func movieVideosFetchedSuccess(_ videos: [MovieVideo])
    func movieVideosFetchedFail(_ error: String)
}

//MARK: Interactor
protocol MovieDetailInteractorInterface: class {
    var presenterDelegate: MovieDetailPresenterInterface! {set get}
    func fetchMovieDetail(id: Int)
    func fetchMovieVideos(id: Int)
}


//MARK: Router
protocol MovieDetailRouterInterface: class {
    var parentRouter: MovieListRouterInterface! {set get}
    func buildMovieDetailViewController<T:UIViewController>(movie: BaseMovieProtocol) -> T where T: DetailTransitionViewProtocol
}

