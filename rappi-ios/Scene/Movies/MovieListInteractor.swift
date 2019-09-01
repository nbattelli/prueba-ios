//
//  MovieInteractor.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

final class MovieListInteractor {
    var presenter: MovieListPresenterInterface!
    let movieConnectors = [MoviesCategory.topRated: NetworkConnector<MovieConfigurator, Movies>(),
                           MoviesCategory.popular: NetworkConnector<MovieConfigurator, Movies>(),
                           MoviesCategory.upComing: NetworkConnector<MovieConfigurator, Movies>()]
}

private extension MovieListInteractor {
    private func fetchMovies(connector: NetworkConnector<MovieConfigurator, Movies>,
                             configurator: MovieConfigurator,
                             category: MoviesCategory)
    {
        connector.cancel()
        connector.request(configurator) { (result) in
            switch result {
            case .success(let model):
                DispatchQueue.main.async { [weak self] in
                    self?.presenter.movieFetchedSuccess(model, category: category)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.presenter.movieFetchedFail(error, category: category)
                }
            }
        }
    }
}

extension MovieListInteractor: MovieListInteractorInterface {
    func fetchMovie(category: MoviesCategory, page: Int) {
        let connector = self.movieConnectors[category]!
        var configurator = MovieConfigurator.topRated(page: page)
        switch category {
        case .topRated:
            configurator = MovieConfigurator.topRated(page: page)
        case .popular:
            configurator = MovieConfigurator.popular(page: page)
        case .upComing:
            configurator = MovieConfigurator.upComing(page: page)
        }
        
        self.fetchMovies(connector: connector, configurator: configurator, category: category)
    }
}
