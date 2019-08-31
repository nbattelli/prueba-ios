//
//  MovieInteractor.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

final class MovieListInteractor {
    var presenter: MovieListPresenterInterface?
    
    let movieConnector = NetworkConnector<MovieConfigurator, Movies>()
}

extension MovieListInteractor: MovieListInteractorInterface {
    func fetchTopRatedMovies(page: Int) {
        movieConnector.request(MovieConfigurator.topRated(page: page)) { (result) in
            switch result {
            case .success(let model):
                self.presenter?.movieFetchedSuccess(model.results)
            case .failure(let error):
                self.presenter?.movieFetchedFail(error)
            }
        }
    }
    
    func fetchPopularMovies(page: Int) {
        movieConnector.request(MovieConfigurator.popular(page: page)) { (result) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.presenter?.movieFetchedSuccess(model.results)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.presenter?.movieFetchedFail(error)
                }
            }
        }
    }
    
    func fetchUpcomingMovies(page: Int) {
        movieConnector.request(MovieConfigurator.upCooming(page: page)) { (result) in
            switch result {
            case .success(let model):
                self.presenter?.movieFetchedSuccess(model.results)
            case .failure(let error):
                self.presenter?.movieFetchedFail(error)
            }
        }
    }
    
}

