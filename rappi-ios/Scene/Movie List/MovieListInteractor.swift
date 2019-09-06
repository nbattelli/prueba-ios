//
//  MovieInteractor.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 31/08/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation
import Reachability

final class MovieListInteractor {
    weak var presenterDelegate: MovieListPresenterInterface!
    let movieConnectors: [MoviesCategory: NetworkConnector<MovieConfigurator, Movies>]!
    
    init() {
        self.movieConnectors = Dictionary(uniqueKeysWithValues: MoviesCategory.allCases.map {($0,NetworkConnector<MovieConfigurator, Movies>())})
    }
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
                    self?.presenterDelegate.movieFetchedSuccess(model, category: category)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.presenterDelegate.movieFetchedFail(error, category: category)
                }
            }
        }
    }
}

extension MovieListInteractor: MovieListInteractorInterface {
    func fetchMovie(category: MoviesCategory, page: Int) {
        if case Reachability()!.connection = Reachability.Connection.none {
            let movies = MovieRepository.getMoviesFromDisk(category: category)
            self.presenterDelegate.movieFetchedSuccess(Movies(movies: movies), category: category)
        } else {
            let connector = self.movieConnectors[category]!
            let configurator = category.configurator(page: page)
            self.fetchMovies(connector: connector, configurator: configurator, category: category)
        }
    }
}
