//
//  MovieDetailInteractor.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 04/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

final class MovieDetailInteractor {
    weak var presenterDelegate: MovieDetailPresenterInterface!
    let connector = NetworkConnector<MovieConfigurator, Movie>()
}

extension MovieDetailInteractor: MovieDetailInteractorInterface {
    
    func fetchMovieDetail(id: String) {
        connector.cancel()
        connector.request(MovieConfigurator.detail(id: id)) { (result) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.presenterDelegate.movieFetchedSuccess(model)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.presenterDelegate.movieFetchedFail(error)
                }
            }
        }
    }
    
}
