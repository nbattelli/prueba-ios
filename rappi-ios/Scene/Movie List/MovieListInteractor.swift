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
    
    var viewModel: [MoviesCategory: MovieListViewModelInterface] = [:]
    
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
                    guard let strongSelf = self else { return }
                    strongSelf.viewModel[category]?.isFromCache = false
                    let indexes = strongSelf.processMovies(model, category: category)
                    strongSelf.presenterDelegate.movieFetchedSuccess(indexes, category: category)
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.presenterDelegate.movieFetchedFail(error, category: category)
                }
            }
        }
    }
    
    private func processMovies(_ movies: Movies, category: MoviesCategory) -> [Int] {
        if self.viewModel[category] == nil {
            self.viewModel[category] = MovieListViewModel()
        }
        let indexes = self.viewModel[category]?.updateMovies(movies) ?? []
        
        MovieRepository.saveMoviesToDisk(category: category, movies: (self.viewModel[category] as! MovieListViewModel))
        
        return indexes
    }
}

extension MovieListInteractor: MovieListInteractorInterface {
    func fetchMovie(category: MoviesCategory, page: Int) {
        if case Reachability()!.connection = Reachability.Connection.none {
            if let movies = MovieRepository.getMoviesFromDisk(category: category) {
                movies.isFromCache = true
                self.viewModel[category] = movies
                let indexes = movies.moviesToShow.enumerated().map {$0.0}
                self.presenterDelegate.movieFetchedSuccess(indexes, category: category)
            } else {
                self.presenterDelegate.movieFetchedFail("No hay internet", category: category)
            }
        } else {
            let connector = self.movieConnectors[category]!
            let configurator = category.configurator(page: page)
            self.fetchMovies(connector: connector, configurator: configurator, category: category)
        }
    }
}
