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
    let connector = NetworkConnector<MovieConfigurator, MovieDetail>()
    let videoConnector = NetworkConnector<MovieConfigurator, MovieVideos>()
}

extension MovieDetailInteractor: MovieDetailInteractorInterface {
    
    func fetchMovieDetail(id: Int) {
        connector.cancel()
        connector.request(MovieConfigurator.detail(id: "\(id)")) { (result) in
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
    
    func fetchMovieVideos(id: Int) {
        videoConnector.cancel()
        videoConnector.request(MovieConfigurator.videos(id: "\(id)")) { (result) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.presenterDelegate.movieVideosFetchedSuccess(model.results)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.presenterDelegate.movieFetchedFail(error)
                }
            }
        }
    }
    
}
